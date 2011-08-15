//
//  FFGLDrawable.h
//  FFMP
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"
#import "FFFilter.h"
#import "FFGLImaging.h"

@interface FFGLDrawable : GHGLViewDrawable {
  
  id<FFReader> _reader;
  id<FFFilter> _filter;
  
  GLint _GLFormat; // For example, GL_RGB, GL_BGRA
  
  FFGLImaging *_imaging;
  FFGLImagingOptions _imagingOptions;
  
  CGRect _textureFrame; // If not set, defaults to the size of the view
}

@property (retain, nonatomic) id<FFFilter> filter;
@property (retain, nonatomic) id<FFReader> reader;

@property (assign, nonatomic) CGRect textureFrame;

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter;

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions;

@end
