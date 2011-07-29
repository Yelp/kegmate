//
//  GHGLUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/10/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLDefines.h"
#import "GHGLUtils.h"

NSUInteger GHGLNextPOT(NSUInteger x) {
	x = x - 1;
	x = x | (x >> 1);
	x = x | (x >> 2);
	x = x | (x >> 4);
	x = x | (x >> 8);
	x = x | (x >>16);
	return x + 1;
}

NSString *const GHGLExtension_GL_APPLE_texture_2D_limited_npot = @"GL_APPLE_texture_2D_limited_npot";
NSString *const GHGLExtension_GL_IMG_texture_format_BGRA8888 = @"GL_APPLE_texture_format_BGRA8888";

BOOL GHGLCheckForExtension(NSString *name) {
  static NSArray *ExtensionNames = NULL;
  if (ExtensionNames == NULL) {
    NSString *extensionsString = [NSString stringWithCString:(char *)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
    ExtensionNames = [[extensionsString componentsSeparatedByString:@" "] retain];
    //GHGLDebug(@"Extension names: %@", ExtensionNames);
  }
  return [ExtensionNames containsObject:name];
}

void GHGLGenTexImage2D(Texture *texture, const GLvoid *pixels) {
  glGenTextures(1, &texture->texID);
	glBindTexture(GL_TEXTURE_2D, texture->texID);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texture->wide, texture->high, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
}

NSString *GHGLErrorDescription(GLenum GLError) {
  switch (GLError) {
    case GL_INVALID_ENUM: return [NSString stringWithFormat:@"GL_INVALID_ENUM (%d, 0x%x)", GLError, GLError];
    case GL_INVALID_VALUE: return [NSString stringWithFormat:@"GL_INVALID_VALUE (%d, 0x%x)", GLError, GLError];
    case GL_INVALID_OPERATION: return [NSString stringWithFormat:@"GL_INVALID_OPERATION (%d, 0x%x)", GLError, GLError];
    case GL_STACK_OVERFLOW: return [NSString stringWithFormat:@"GL_STACK_OVERFLOW (%d, 0x%x)", GLError, GLError];
    case GL_STACK_UNDERFLOW: return [NSString stringWithFormat:@"GL_STACK_UNDERFLOW (%d, 0x%x)", GLError, GLError];
    case GL_OUT_OF_MEMORY: return [NSString stringWithFormat:@"GL_OUT_OF_MEMORY (%d, 0x%x)", GLError, GLError];
    case 0x0506: return [NSString stringWithFormat:@"INVALID_FRAMEBUFFER_OPERATION_EXT (%d, 0x%x)", GLError, GLError];
    default:
      return [NSString stringWithFormat:@"Unknown (%d, 0x%x)", GLError, GLError];
  }
}

/*!
 Validate the current texture environment against MBX errata.
 Assert if we use a state combination not supported by the MBX hardware.
 
 From GLImageProcessing Apple example.
 */
void _GHGLValidateTexEnv(void) {  
  
  typedef struct {
		GLint combine;
		GLint src[3];
		GLint op[3];
		GLint scale;
	} Channel;
  
	typedef struct {
		GLint enabled;
		GLint binding;
		GLint mode;
		Channel rgb;
		Channel a;
		GLfloat color[4];
	} TexEnv;
  
	// MBX supports two texture units
	TexEnv unit[2];
	GLint active;
	int prev = -1;
  
	glGetIntegerv(GL_ACTIVE_TEXTURE, &active);
	for (int i = 0; i < 2; i++) {
		glActiveTexture(GL_TEXTURE0 + i);
		unit[i].enabled = glIsEnabled(GL_TEXTURE_2D);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &unit[i].binding);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,  &unit[i].mode);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_COMBINE_RGB,       &unit[i].rgb.combine);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC0_RGB,          &unit[i].rgb.src[0]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC1_RGB,          &unit[i].rgb.src[1]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC2_RGB,          &unit[i].rgb.src[2]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND0_RGB,      &unit[i].rgb.op[0]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND1_RGB,      &unit[i].rgb.op[1]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND2_RGB,      &unit[i].rgb.op[2]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_RGB_SCALE,         &unit[i].rgb.scale);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_COMBINE_ALPHA,     &unit[i].a.combine);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC0_ALPHA,        &unit[i].a.src[0]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC1_ALPHA,        &unit[i].a.src[1]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_SRC2_ALPHA,        &unit[i].a.src[2]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA,    &unit[i].a.op[0]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA,    &unit[i].a.op[1]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_OPERAND2_ALPHA,    &unit[i].a.op[2]);
		glGetTexEnviv(GL_TEXTURE_ENV, GL_ALPHA_SCALE,       &unit[i].a.scale);
		glGetTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, &unit[i].color[0]);
    
		if (unit[i].enabled == 0) continue;
		if (unit[i].mode != GL_COMBINE) continue;
    
		// PREVIOUS on unit 0 means PRIMARY_COLOR.
		if (i == 0)
		{
			int j;
      
			for (j = 0; j < 3; j++)
			{
				if (unit[i].rgb.src[j] == GL_PREVIOUS)
					unit[i].rgb.src[j] = GL_PRIMARY_COLOR;
				if (unit[i].a.src[j] == GL_PREVIOUS)
					unit[i].a.src[j] = GL_PRIMARY_COLOR;
			}
		}
    
		// If the value of COMBINE_RGB is MODULATE, only one of the two multiplicands can use an ALPHA operand.
		GHGLAssert(!(unit[i].rgb.combine == GL_MODULATE &&
                (unit[i].rgb.op[0] == GL_SRC_ALPHA || unit[i].rgb.op[0] == GL_ONE_MINUS_SRC_ALPHA) &&
                (unit[i].rgb.op[1] == GL_SRC_ALPHA || unit[i].rgb.op[1] == GL_ONE_MINUS_SRC_ALPHA)));
    
		// If the value of COMBINE_RGB is INTERPOLATE and either SRC0 or SRC1 uses an ALPHA operand, SRC2 can not be CONSTANT or PRIMARY_COLOR or use an ALPHA operand.
		GHGLAssert(!(unit[i].rgb.combine == GL_INTERPOLATE &&
                (unit[i].rgb.op[0] == GL_SRC_ALPHA || unit[i].rgb.op[0] == GL_ONE_MINUS_SRC_ALPHA ||
                 unit[i].rgb.op[1] == GL_SRC_ALPHA || unit[i].rgb.op[1] == GL_ONE_MINUS_SRC_ALPHA) &&
                (unit[i].rgb.op[2] == GL_SRC_ALPHA || unit[i].rgb.op[2] == GL_ONE_MINUS_SRC_ALPHA ||
                 unit[i].rgb.src[2] == GL_CONSTANT || unit[i].rgb.src[2] == GL_PRIMARY_COLOR)));
    
		// If the value of COMBINE_RGB is INTERPOLATE and SRC0 and SRC1 are CONSTANT or PRIMARY COLOR, SRC2 can not be CONSTANT or PRIMARY_COLOR or use an ALPHA operand.
		GHGLAssert(!(unit[i].rgb.combine == GL_INTERPOLATE &&
                ((unit[i].rgb.src[0] == GL_CONSTANT      && unit[i].rgb.src[1] == GL_CONSTANT) ||
                 (unit[i].rgb.src[0] == GL_PRIMARY_COLOR && unit[i].rgb.src[1] == GL_PRIMARY_COLOR)) &&
                (unit[i].rgb.op[2] == GL_SRC_ALPHA || unit[i].rgb.op[2] == GL_ONE_MINUS_SRC_ALPHA ||
                 unit[i].rgb.src[2] == GL_CONSTANT || unit[i].rgb.src[2] == GL_PRIMARY_COLOR)));
    
		// If the value of COMBINE_RGB is DOT3_RGB or DOT3_RGBA, only one of the sources can be PRIMARY_COLOR or use an ALPHA operand.
		GHGLAssert(!((unit[i].rgb.combine == GL_DOT3_RGB || unit[i].rgb.combine == GL_DOT3_RGBA) &&
		            (unit[i].rgb.src[0] == GL_PRIMARY_COLOR || unit[i].rgb.op[0] == GL_SRC_ALPHA || unit[i].rgb.op[0] == GL_ONE_MINUS_SRC_ALPHA) &&
		            (unit[i].rgb.src[1] == GL_PRIMARY_COLOR || unit[i].rgb.op[1] == GL_SRC_ALPHA || unit[i].rgb.op[1] == GL_ONE_MINUS_SRC_ALPHA)));
    
		// If the value of COMBINE_RGB is SUBTRACT, SCALE_RGB must be 1.0.
		GHGLAssert(!(unit[i].rgb.combine == GL_SUBTRACT && unit[i].rgb.scale != 1));
    
		if (unit[i].rgb.combine != GL_DOT3_RGBA)
		{
			// If the value of COMBINE_ALPHA is MODULATE or INTERPOLATE, only one of the two multiplicands can be CONSTANT.
			GHGLAssert(!(unit[i].a.combine == GL_MODULATE    &&  unit[i].a.src[0] == GL_CONSTANT && unit[i].a.src[1] == GL_CONSTANT));
			GHGLAssert(!(unit[i].a.combine == GL_INTERPOLATE && (unit[i].a.src[0] == GL_CONSTANT || unit[i].a.src[1] == GL_CONSTANT) && unit[i].a.src[2] == GL_CONSTANT));
      
			// If the value of COMBINE_ALPHA is SUBTRACT, SCALE_ALPHA must be 1.0.
			GHGLAssert(!(unit[i].a.combine == GL_SUBTRACT && unit[i].a.scale != 1));
		}
		
		// The value of TEXTURE_ENV_COLOR must be the same for all texture units that CONSTANT is used on.
		if (unit[i].rgb.src[0] == GL_CONSTANT ||
        (unit[i].rgb.src[1] == GL_CONSTANT && unit[i].rgb.combine != GL_REPLACE) ||
        (unit[i].rgb.src[2] == GL_CONSTANT && unit[i].rgb.combine == GL_INTERPOLATE) ||
        (unit[i].rgb.combine != GL_DOT3_RGBA &&
         (unit[i].a.src[0] == GL_CONSTANT ||
          (unit[i].a.src[1] == GL_CONSTANT && unit[i].a.combine != GL_REPLACE) ||
          (unit[i].a.src[2] == GL_CONSTANT && unit[i].a.combine == GL_INTERPOLATE))))
		{
			if (prev >= 0)
				GHGLAssert(!(unit[prev].color[0] != unit[i].color[0] ||
                    unit[prev].color[1] != unit[i].color[1] ||
                    unit[prev].color[2] != unit[i].color[2] ||
                    unit[prev].color[3] != unit[i].color[3]));
			prev = i;
		}
	}
  
	glActiveTexture(active);
	GHGLCheckError();
}

CGImageRef GHGLCreateImageFromBuffer(GLubyte *buffer, int length, GLsizei width, GLsizei height, CGColorSpaceRef colorSpace) {
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, length, NULL);
  
  int bitsPerComponent = 8;
  int bytesPerPixel = 4;
  int bitsPerPixel = bytesPerPixel * 8;
  int bytesPerRow = bytesPerPixel * width;
  
  CGImageRef image = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, 
                                   kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);
  
  CGDataProviderRelease(provider);
  return image;
}
