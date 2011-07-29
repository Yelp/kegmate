//
//  FFGLImaging.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/13/10.
//  Copyright 2010. All rights reserved.
//

/*
 
 Abstract: Simple 2D image processing using OpenGL ES1.1
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

//
//  FFGLImageFilters.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/12/10.
//  Copyright 2010. All rights reserved.
//

//
//  Simple 2D image processing using OpenGL ES1.1
//
//  The key concepts here are described at
//  http://www.graficaobscura.com/interp/index.html
//  http://www.graficaobscura.com/matrix/index.html
//
//  The only tricky part is how to process inputs outside of [0..1] in the fixed-function pipeline.
//  Simple algebra provides a solution for extrapolation to  [0..2]:
//
//  lerp = Src*t + Dst*(1-t), where (Src, Dst, t) [0..1]
//  if t = 2, then
//  lerp = Src*(2t) + Dst*(1-2t)
//       = 2(Src*t  + Dst*(0.5-t))
//
//  Now, the inputs (Src, Dst, t) are inside [0..1], and the final multiply by 2 can be done with
//  TexEnv. Extrapolation by values larger than 2 can be handled by iteration.
//
//  With that solved, the rest of the problem is simply mapping math operations to TexEnv state.
//  Equations that are too complex to fit in the available texture units have to be broken apart
//  into multiple passes. In that case, a scratch FBO is used to store intermediate results.
//
//  This sample demonstrates mapping simple filters like Brightness, Contrast, Saturation,
//  Hue rotation, and Sharpness to TexEnv. Additional filters such as Convolution, Invert,
//  Sepia, etc can be similarly implemented.
//
//  For details on the available TexEnv COMBINE operators, see the ES1.1 specification, or
//  the equivalent desktop GL extensions:
//  http://www.opengl.org/registry/specs/ARB/texture_env_combine.txt
//  http://www.opengl.org/registry/specs/ARB/texture_env_dot3.txt
//
//  Note: the PowerVR MBX does not support all possible COMBINE state permutations. A debug utility
//  is used here to validate the TexEnv state against known hardware errata.
//

#import "FFGLImaging.h"

#import "GHGLUtils.h"

// Geometry for a fullscreen quad
TexturedVertexData2D fullquad[4] = {
  { 0, 0, 0, 0 },
  { 1, 0, 1, 0 },
  { 0, 1, 0, 1 },
  { 1, 1, 1, 1 },
};

// Geometry for a fullscreen quad, flipping texcoords upside down
TexturedVertexData2D flipquad[4] = {
  { 0, 0, 0, 1 },
  { 1, 0, 1, 1 },
  { 0, 1, 0, 0 },
  { 1, 1, 1, 0 },
};

@implementation FFGLImaging

- (id)initWithTextureSize:(TextureSize)texSize textureCoord:(TextureCoord3D)texCoord {
  if ((self = [self init])) {
    _texSize = texSize;
    _texCoord = texCoord;
    
    // Create 1x1 for default constant texture
    // To enable a texture unit, a valid texture has to be bound even if the combine modes do not access it
    GLubyte half[4] = {0x80, 0x80, 0x80, 0x80};	  
    _half.wide = 1;
    _half.high = 1;
    _half.s = 1.0;
    _half.t = 1.0;  
    glActiveTexture(GL_TEXTURE1);
    GHGLGenTexImage2D(&_half, half);
    glActiveTexture(GL_TEXTURE0);
    
    // Remember the FBO being used for the display framebuffer
    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, (GLint *)&_systemFBO);
    
    // Degen + FBO
    _degen.wide = _texSize.wide;
    _degen.high = _texSize.high;
    _degen.s = _texCoord.s;
    _degen.t = _texCoord.t;
    GHGLGenTexImage2D(&_degen, NULL);  
    glGenFramebuffersOES(1, &_degenFBO);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _degenFBO);
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _degen.texID, 0);
    GHGLAssert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    
    // Scratch + FBO
    _scratch.wide = _texSize.wide;
    _scratch.high = _texSize.high;
    _scratch.s = _texCoord.s;
    _scratch.t = _texCoord.t;
    GHGLGenTexImage2D(&_scratch, NULL);  
    glGenFramebuffersOES(1, &_scratchFBO);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _scratchFBO);
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _scratch.texID, 0);
    GHGLAssert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    
    // Reset to system FBO
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _systemFBO);
    
    GHGLCheckError();
  }
  return self;
}

- (BOOL)apply:(TexturedVertexData2D[4])quad options:(FFGLImagingOptions)options {
  if (FFGLImagingHasMode(options.mode, FFGLImagingHue)) {
    [self hue:quad amount:options.hueAmount];
  } else if (FFGLImagingHasMode(options.mode, FFGLImagingBrightness)) {
    [self brightness:quad amount:options.brightnessAmount];
  } else if (FFGLImagingHasMode(options.mode, FFGLImagingBlur)) {
    [self blur:quad amount:options.blurAmount];
  } else if (FFGLImagingHasMode(options.mode, FFGLImagingContrast)) {
    [self contrast:quad amount:options.contrastAmount];
  } else {
    [self draw:quad];
    return NO;
  }
  return YES;
}

- (void)draw:(TexturedVertexData2D[4])quad {
  glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].vertex.x);
  glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].texCoord.s);	
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  GHGLCheckError();
}  

// The following filters change the TexEnv state in various ways.
// To reduce state change overhead, the convention adopted here is
// that each filter is responsible for setting up common state, and
// restoring uncommon state to the default.
//
// Common state for this application is defined as:
// GL_TEXTURE_ENV_MODE
// GL_COMBINE_RGB, GL_COMBINE_ALPHA
// GL_SRC[012]_RGB, GL_SRC[012]_ALPHA
// GL_TEXTURE_ENV_COLOR
//
// Uncommon state for this application is defined as:
// GL_OPERAND[012]_RGB, GL_OPERAND[012]_ALPHA
// GL_RGB_SCALE, GL_ALPHA_SCALE
//
// For all filters, the texture's alpha channel is passed through unchanged.
// If you need the alpha channel for compositing purposes, be mindful of
// premultiplication that may have been performed by your image loader.


- (void)brightness:(TexturedVertexData2D[4])quad amount:(float)amount { // amount [0..2]
                                                             // One pass using one unit:
                                                             // brightness < 1.0 biases towards black
                                                             // brightness > 1.0 biases towards white
                                                             //
                                                             // Note: this additive definition of brightness is
                                                             // different than what matrix-based adjustment produces,
                                                             // where the brightness factor is a scalar multiply.
                                                             //
                                                             // A +/-1 bias will produce the full range from black to white,
                                                             // whereas the scalar multiply can never reach full white.
  
	glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->vertex.x);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	if (amount > 1.0f) {
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);
		glColor4f(amount - 1, amount - 1, amount - 1, amount - 1);
	} else {
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_SUBTRACT);
		glColor4f(1 - amount, 1 - amount, 1 - amount, 1 - amount);
	}
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA, GL_TEXTURE);
  
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


- (void)contrast:(TexturedVertexData2D[4])quad amount:(float)amount { // amount [0..2]
	GLfloat h = amount * 0.5f;
	
	// One pass using two units:
	// contrast < 1.0 interpolates towards grey
	// contrast > 1.0 extrapolates away from grey
	//
	// Here, the general extrapolation 2*(Src*t + Dst*(0.5-t))
	// can be simplified, because Dst is a constant (grey).
	// That results in: 2*(Src*t + 0.25 - 0.5*t)
	//
	// Unit0 calculates Src*t
	// Unit1 adds 0.25 - 0.5*t
	// Since 0.5*t will be in [0..0.5], it can be biased up and the addition done in signed space.
  
	glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->vertex.x);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_MODULATE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_TEXTURE);
  
	glActiveTexture(GL_TEXTURE1);
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_ADD_SIGNED);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_PREVIOUS);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB,     GL_SRC_ALPHA);
	glTexEnvi(GL_TEXTURE_ENV, GL_RGB_SCALE,        2);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_PREVIOUS);
  
	glColor4f(h, h, h, 0.75 - 0.5 * h);	// 2x extrapolation
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Restore state
	glDisable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB,     GL_SRC_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_RGB_SCALE,        1);
	glActiveTexture(GL_TEXTURE0);
}


- (void)greyscale:(TexturedVertexData2D[4])quad amount:(float)amount { // amount = 1 for standard perceptual weighting
  
	GLfloat lerp[4] = { 1.0, 1.0, 1.0, 0.5 };
	GLfloat avrg[4] = { .667, .667, .667, 0.5 };	// average
	GLfloat prcp[4] = { .646, .794, .557, 0.5 };	// perceptual NTSC
	GLfloat dot3[4] = { 
    prcp[0] * amount + avrg[0] * (1 - amount), 
    prcp[1] * amount + avrg[1] * (1 - amount), 
    prcp[2] * amount + avrg[2] * (1 - amount), 0.5 
  };
	
	// One pass using two units:
	// Unit 0 scales and biases into [0.5..1.0]
	// Unit 1 dot products with perceptual weights
  
	glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->vertex.x);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_INTERPOLATE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_CONSTANT);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC2_RGB,         GL_CONSTANT);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_TEXTURE);
	glTexEnvfv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_COLOR, lerp);
  
	// Note: we prefer to dot product with primary color, because
	// the constant color is stored in limited precision on MBX
	glActiveTexture(GL_TEXTURE1);
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_DOT3_RGB);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_PREVIOUS);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_PREVIOUS);
  
	glColor4f(dot3[0], dot3[1], dot3[2], dot3[3]);
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Restore state
	glDisable(GL_TEXTURE_2D);
	glActiveTexture(GL_TEXTURE0);
}


- (void)extrapolate:(TexturedVertexData2D[4])quad amount:(float)amount { // amount [0..2]
  
	// t < 1.0 interpolates towards degenerate image
	// t > 1.0 extrapolates away from degenerate image
	//
	// Unlike the simpler filters, extrapolation from an arbitrary image
	// requires two passes to implement 2*(Src*t + Dst(0.5-t)).
	//
	// The extrapolation works in both directions, but when t <= 1.0f,
	// the interpolation can be done in a single pass, which is faster.
	//
	// The degenerate image to extrapolate from is generated
	// outside of this function. It can be cached for a static image,
	// or regenerated every frame for dynamic content.
  
	if (amount <= 1.0f) {
		// One pass using two units:
		// Unit 0 samples the input image
		// Unit 1 interpolates towards the degenerate image
    
		glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].vertex.x);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].texCoord.s);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_REPLACE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_TEXTURE);
    
		glClientActiveTexture(GL_TEXTURE1);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].texCoord.s);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, _degen.texID);
		glEnable(GL_TEXTURE_2D);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_INTERPOLATE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PREVIOUS);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC2_RGB,         GL_PRIMARY_COLOR);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_PREVIOUS);
		glColor4f(0.0, 0.0, 0.0, 1.0f - amount);
		GHGLValidateTexEnv();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
		// Restore state
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glClientActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, _half.texID);
		glDisable(GL_TEXTURE_2D);
		glActiveTexture(GL_TEXTURE0);
	} else {
		GLint fbo, tex, viewport[4], blend;
		float h = amount * 0.5f;
		TexturedVertexData2D flipquad[4];
    
		for (int i = 0; i < 4; i++) {
			flipquad[i].texCoord.s = quad[i].texCoord.s;
			flipquad[i].texCoord.t = quad[3-i].texCoord.t;
		}
		
		// Push state
		glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &fbo);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &tex);
		glGetIntegerv(GL_VIEWPORT, viewport);
		glGetIntegerv(GL_BLEND, &blend);
    
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _scratchFBO);
		glViewport(0, 0, _scratch.wide * _scratch.s, _scratch.high * _scratch.t);
		glClear(GL_COLOR_BUFFER_BIT);
		glDisable(GL_BLEND);
		glBindTexture(GL_TEXTURE_2D, _degen.texID);
		glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].vertex.x);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &flipquad[0].texCoord.s);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_MODULATE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PRIMARY_COLOR);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_TEXTURE);
    
		// Note: we prefer to sample 0.5 from a texture, because
		// the constant color is stored in limited precision on MBX
		glActiveTexture(GL_TEXTURE1);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, _half.texID);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
		if (h < 0.5) {
			float bias = 0.5 - h;
			
			// First pass: 0.5 + degenerate * bias;
			glColor4f(bias, bias, bias, 1.0);
			glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);
		} else {
			float bias = h - 0.5;
			
			// First pass: 0.5 - degenerate * bias;
			glColor4f(bias, bias, bias, 1.0);
			glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_SUBTRACT);
		}
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PREVIOUS);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_PREVIOUS);
		GHGLValidateTexEnv();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
		// Second pass: 2.0 * (Src * h + first - 0.5)
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, fbo);
		glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
		if (blend) glEnable(GL_BLEND);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
		glClientActiveTexture(GL_TEXTURE1);
		glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glBindTexture(GL_TEXTURE_2D, _scratch.texID);
		glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD_SIGNED);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,    GL_PREVIOUS);
		glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,    GL_TEXTURE);
		glTexEnvi(GL_TEXTURE_ENV, GL_RGB_SCALE,   2);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, tex);
		glColor4f(h, h, h, 1.0);
		GHGLValidateTexEnv();
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
		// Restore state
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glClientActiveTexture(GL_TEXTURE0);
		glActiveTexture(GL_TEXTURE1);
		glTexEnvi(GL_TEXTURE_ENV, GL_RGB_SCALE,   1);
		glBindTexture(GL_TEXTURE_2D, _half.texID);
		glDisable(GL_TEXTURE_2D);
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, tex);
	}
}

static inline void Matrix3DRotateX(Matrix3D matrix, float rs, float rc) {
	matrix[0] = 1.0;
	matrix[1] = 0.0;
	matrix[2] = 0.0;
	matrix[3] = 0.0;
  
	matrix[4] = 0.0;
	matrix[5] = rc;
	matrix[6] = rs;
	matrix[7] = 0.0;
  
	matrix[8] = 0.0;
	matrix[9] = -rs;
	matrix[10] = rc;
	matrix[11] = 0.0;
  
	matrix[12] = 0.0;
	matrix[13] = 0.0;
	matrix[14] = 0.0;
	matrix[15] = 1.0;
}

static inline void Matrix3DRotateY(Matrix3D matrix, float rs, float rc) {
	matrix[0] = rc;
	matrix[1] = 0.0;
	matrix[2] = -rs;
	matrix[3] = 0.0;
  
	matrix[4] = 0.0;
	matrix[5] = 1.0;
	matrix[6] = 0.0;
	matrix[7] = 0.0;
  
	matrix[8] = rs;
	matrix[9] = 0.0;
	matrix[10] = rc;
	matrix[11] = 0.0;
  
	matrix[12] = 0.0;
	matrix[13] = 0.0;
	matrix[14] = 0.0;
	matrix[15] = 1.0;
}

static inline void Matrix3DRotateZ(Matrix3D matrix, float rs, float rc) {
	matrix[0] = rc;
	matrix[1] = rs;
	matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;  
  
	matrix[4] = -rs;
	matrix[5] = rc;
  
	matrix[10] = 1.0;
	matrix[15] = 1.0;
}

static void FFHueMatrix(Matrix3D matrix, float angle) {
  Matrix3D rot;
	float mag;
	float xrs, xrc;
	float yrs, yrc;
	float zrs, zrc;
  
  const float sqrt2 = 1.41421356;
  const float sqrt3 = 1.73205081;
  
	// Rotate the grey vector into positive Z
	mag = sqrt2;
	xrs = 1.0/mag;
	xrc = 1.0/mag;
	Matrix3DRotateX(matrix, xrs, xrc);
	mag = sqrt3;
	yrs = -1.0/mag;
	yrc = sqrt2/mag;
	Matrix3DRotateY(rot, yrs, yrc);
	Matrix3DMultiply(rot, matrix, matrix);
  
	// Rotate the hue
	zrs = fastSinf(angle);
	zrc = cosf(angle);
	Matrix3DRotateZ(rot, zrs, zrc);
	Matrix3DMultiply(rot, matrix, matrix);
  
	// Rotate the grey vector back into place
	Matrix3DRotateY(rot, -yrs, yrc);
	Matrix3DMultiply(rot, matrix, matrix);
	Matrix3DRotateX(rot, -xrs, xrc);
	Matrix3DMultiply(rot, matrix, matrix);
}


- (void)hue:(TexturedVertexData2D[4])quad amount:(float)amount { // amount [0..2] == [-180..180] degrees
	Matrix3D matrix;
	GLfloat lerp[4] = {1.0, 1.0, 1.0, 0.5};
  
	// Color matrix rotation can be expressed as three dot products
	// Each DOT3 needs inputs prescaled to [0.5..1.0]
  
	// Construct 3x3 matrix
	FFHueMatrix(matrix, (amount - 1.0) * M_PI);
  
	// Prescale matrix weights
	matrix[0] *= 0.5; matrix[0] += 0.5;
	matrix[1] *= 0.5; matrix[1] += 0.5;
	matrix[2] *= 0.5; matrix[2] += 0.5;
	matrix[3] = 1.0;
  
	matrix[4] *= 0.5; matrix[4] += 0.5;
	matrix[5] *= 0.5; matrix[5] += 0.5;
	matrix[6] *= 0.5; matrix[6] += 0.5;
	matrix[7] = 1.0;
  
	matrix[8] *= 0.5; matrix[8] += 0.5;
	matrix[9] *= 0.5; matrix[9] += 0.5;
	matrix[10] *= 0.5; matrix[10] += 0.5;
	matrix[11] = 1.0;
  
	glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->vertex.x);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad->texCoord.s);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_INTERPOLATE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_CONSTANT);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC2_RGB, GL_CONSTANT);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA, GL_TEXTURE);
	glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, lerp);
  
	// Note: we prefer to dot product with primary color, because
	// the constant color is stored in limited precision on MBX
	glActiveTexture(GL_TEXTURE1);
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_DOT3_RGB);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB, GL_PREVIOUS);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB, GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA, GL_PREVIOUS);
  
	// Red channel
	glColorMask(1, 0, 0, 0);
	glColor4f(matrix[0], matrix[1], matrix[2], matrix[3]);
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Green channel
	glColorMask(0, 1, 0, 0);
	glColor4f(matrix[4], matrix[5], matrix[6], matrix[7]);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Blue channel
	glColorMask(0, 0, 1, 0);
	glColor4f(matrix[8], matrix[9], matrix[10], matrix[11]);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	// Restore state
	glDisable(GL_TEXTURE_2D);
	glActiveTexture(GL_TEXTURE0);
	glColorMask(1, 1, 1, 1);
}


- (void)blur:(TexturedVertexData2D[4])quad amount:(float)amount { // amount = 1
	GLint tex;
	TexturedVertexData2D tmpquad[4];
	float offw = amount / _texSize.wide;
	float offh = amount / _texSize.high;
	
	glGetIntegerv(GL_TEXTURE_BINDING_2D, &tex);
  
	// Three pass small blur, using rotated pattern to sample 17 texels:
	//
	// .\/.. 
	// ./\\/ 
	// \/X/\   rotated samples filter across texel corners
	// /\\/. 
	// ../\. 
	
	// Pass one: center nearest sample
	glVertexPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].vertex.x);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &quad[0].texCoord.s);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glColor4f(1.0/5, 1.0/5, 1.0/5, 1.0);
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	// Pass two: accumulate two rotated linear samples
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	for (int i = 0; i < 4; i++) {
		tmpquad[i].vertex.x = quad[i].texCoord.s + 1.5 * offw;
		tmpquad[i].vertex.y = quad[i].texCoord.t + 0.5 * offh;
		tmpquad[i].texCoord.s = quad[i].texCoord.s - 1.5 * offw;
		tmpquad[i].texCoord.t = quad[i].texCoord.t - 0.5 * offh;
	}
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &tmpquad->vertex.x);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glActiveTexture(GL_TEXTURE1);
	glEnable(GL_TEXTURE_2D);
	glClientActiveTexture(GL_TEXTURE1);
	glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData2D), &tmpquad->texCoord.s);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glBindTexture(GL_TEXTURE_2D, tex);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB,      GL_INTERPOLATE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_RGB,         GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC1_RGB,         GL_PREVIOUS);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC2_RGB,         GL_PRIMARY_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND2_RGB,     GL_SRC_COLOR);
	glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,    GL_REPLACE);
	glTexEnvi(GL_TEXTURE_ENV, GL_SRC0_ALPHA,       GL_PRIMARY_COLOR);
  
	glColor4f(0.5, 0.5, 0.5, 2.0/5);
	GHGLValidateTexEnv();
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	// Pass three: accumulate two rotated linear samples
	for (int i = 0; i < 4; i++) {
		tmpquad[i].vertex.x = quad[i].texCoord.s - 0.5 * offw;
		tmpquad[i].vertex.y = quad[i].texCoord.t + 1.5 * offh;
		tmpquad[i].texCoord.s = quad[i].texCoord.s + 0.5 * offw;
		tmpquad[i].texCoord.t = quad[i].texCoord.t - 1.5 * offh;
	}
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	// Restore state
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glClientActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _half.texID);
	glDisable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND2_RGB, GL_SRC_ALPHA);
	glActiveTexture(GL_TEXTURE0);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glDisable(GL_BLEND);
}

@end
