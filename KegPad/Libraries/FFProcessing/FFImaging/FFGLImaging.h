//
//  FFGLImaging.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/13/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLCommon.h"

typedef enum {
  FFGLImagingHue = 1 << 0,
  FFGLImagingBrightness = 1 << 1,
  FFGLImagingBlur = 1 << 2,
  FFGLImagingContrast = 1 << 3,
} FFGLImagingMode;

typedef struct {
  FFGLImagingMode mode;
  float hueAmount;
  float brightnessAmount;
  float blurAmount;
  float contrastAmount;
} FFGLImagingOptions;

static inline BOOL FFGLImagingHasMode(FFGLImagingMode value, FFGLImagingMode mode) {
  return ((mode & value) == mode);
}

static inline FFGLImagingOptions FFGLImagingOptionsMake(FFGLImagingMode mode, float amount) {
  FFGLImagingOptions options;
  options.mode = mode;
  options.hueAmount = amount;
  options.brightnessAmount = amount;
  options.blurAmount = amount;
  options.contrastAmount = amount;
  return options;
}

@interface FFGLImaging : NSObject {

  // Framebuffer objects
  GLuint _systemFBO;
  GLuint _degenFBO;
  GLuint _scratchFBO;

  TextureSize _texSize;
  TextureCoord3D _texCoord;

  // Textures used for filtering
  Texture _half;
  Texture _degen;
  Texture _scratch;
}

- (id)initWithTextureSize:(TextureSize)texSize textureCoord:(TextureCoord3D)texCoord;

- (BOOL)apply:(TexturedVertexData2D[4])quad options:(FFGLImagingOptions)options;

- (void)draw:(TexturedVertexData2D[4])quad;

- (void)brightness:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)contrast:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)greyscale:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)extrapolate:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)hue:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)blur:(TexturedVertexData2D[4])quad amount:(float)amount;

@end
