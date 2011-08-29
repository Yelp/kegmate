//
//  FFGLDrawable.m
//  FFMP
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFGLDrawable.h"
#import "FFUtils.h"
#import "GHGLUtils.h"

@implementation FFGLDrawable

@synthesize filter=_filter, reader=_reader, textureFrame=_textureFrame;

- (id)init {
  if ((self = [super init])) {
    _GLFormat = GL_BGRA;
    _imagingOptions = FFGLImagingOptionsMake(FFGLImagingNone, 0);
    _textureFrame = CGRectZero;
  }
  return self;
}

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter {
  if ((self = [self init])) {
    _reader = [reader retain];
    _filter = [filter retain];
  }
  return self;
}

- (void)dealloc {
  [_imaging release];
  [_reader close];
  [_reader release];
  [_filter release];
  [super dealloc];
}

- (void)stop {
  [_reader close];
}

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions {
  _imagingOptions = imagingOptions;
}

- (void)setupView:(GHGLView *)view {
  [super setupView:view];
  TextureSize texSize = {(GLsizei)view.frame.size.width, (GLsizei)view.frame.size.height};
  TextureCoord3D texCoord = {1, 1}; 
  [_imaging release];
  _imaging = [[FFGLImaging alloc] initWithTextureSize:texSize textureCoord:texCoord];
  //_imageEncoder = [[FFGLImageEncoder alloc] initWithWidth:texSize.wide height:texSize.high format:_GLFormat];
  GHGLCheckError();
}

- (BOOL)drawView:(GHGLView *)view {
  if (!_reader) return NO;

  FFVFrameRef frame = NULL;
  
  if (_reader) {
    frame = [_reader nextFrame:nil];
  }
  
  glBindTexture(GL_TEXTURE_2D, _texture);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  
  // You have to do clamp to edge to support NPOT textures
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);  
  
  /*
   glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);   
   GHGLCheckError();
   */

  if (frame != NULL) {
    if (_filter) {
      frame = [_filter filterFrame:frame error:nil];
      if (frame == NULL) return NO;
    }
    
    uint8_t *data = FFVFrameGetData(frame, 0);
    // TODO(gabe): Assert (pixel) format is correct for our GL setup
    if (data == NULL) {
      FFDebug(@"No data");
    } else {
      FFVFormat format = FFVFrameGetFormat(frame);
      // Create texture with data or update existing texture data
      if (!_textureLoaded) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, format.width, format.height, 0, _GLFormat, GL_UNSIGNED_BYTE, data);        
        _textureLoaded = YES;
        FFDebug(@"Texture loaded");
      } else {
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, format.width, format.height, _GLFormat, GL_UNSIGNED_BYTE, data);
      }
    }
  }
  
  GHGLCheckError();

  // TODO(gabe): Height and width, x and y are flipped
  CGRect textureFrame = CGRectMake(0, 0, view.frame.size.height, view.frame.size.width);
  if (_textureFrame.size.width > 0 && _textureFrame.size.height > 0) {
    textureFrame = CGRectMake(_textureFrame.origin.y, _textureFrame.origin.x, _textureFrame.size.height, _textureFrame.size.width);;
  }
  
  TexturedVertexData2D quad[4] = {
    {{textureFrame.origin.y, textureFrame.origin.x}, {0, 1}},
    {{textureFrame.origin.y, textureFrame.origin.x + textureFrame.size.width}, {1, 1}},
    {{textureFrame.origin.y + textureFrame.size.height, textureFrame.origin.x}, {0, 0}},
    {{textureFrame.origin.y + textureFrame.size.height, textureFrame.origin.x + textureFrame.size.width}, {1, 0}}
  };
  
  if (_textureLoaded) {
    NSAssert(_imaging, @"No imaging");
    [_imaging apply:quad options:_imagingOptions];
  }
  
  /*
  TexturedVertexData3D quad[4] = {
    {{textureFrame.origin.y, textureFrame.origin.x, _textureZ}, {0, 0, 0}, {0, 1}},
    {{textureFrame.origin.y, textureFrame.origin.x + textureFrame.size.width, _textureZ}, {0, 0, 0}, {1, 1}},
    {{textureFrame.origin.y + textureFrame.size.height, textureFrame.origin.x, _textureZ}, {0, 0, 0}, {0, 0}},
    {{textureFrame.origin.y + textureFrame.size.height, textureFrame.origin.x + textureFrame.size.width, _textureZ}, {0, 0, 0}, {1, 0}}
  };
  [FFGLImaging drawVertexData3D:quad];
   */
  
  /*
  [_imageEncoder GLReadPixels];
  [_imageEncoder writeToPhotosAlbum];    
   */
  return YES;
}

@end
