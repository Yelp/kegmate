//
//  FFAVUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/9/10.
//  Copyright 2010. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "FFAVUtils.h"

int CVPixelFormatFromFFPixelFormat(FFPixelFormat pixelFormat) {
  switch (pixelFormat) {
    case kFFPixelFormatType_32BGRA: return kCVPixelFormatType_32BGRA;
    case kFFPixelFormatType_32RGBA: return kCVPixelFormatType_32RGBA;
    case kFFPixelFormatType_32ARGB: return kCVPixelFormatType_32ARGB;
    case kFFPixelFormatType_24RGB: return kCVPixelFormatType_24RGB;
    case kFFPixelFormatType_1Monochrome: return kCVPixelFormatType_1Monochrome;
    // TODO(gabe): Is this right?
    case kFFPixelFormatType_YUV420P: return kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    default:
      return kFFPixelFormatType_None;
  }
}

FFPixelFormat FFPixelFormatFromCVPixelFormat(int pixelFormat) {
  switch (pixelFormat) {
    case kCVPixelFormatType_32BGRA: return kFFPixelFormatType_32BGRA;
    case kCVPixelFormatType_32RGBA: return kFFPixelFormatType_32RGBA;
    case kCVPixelFormatType_32ARGB: return kFFPixelFormatType_32ARGB;
    case kCVPixelFormatType_24RGB: return kFFPixelFormatType_24RGB;
    case kCVPixelFormatType_1Monochrome: return kFFPixelFormatType_1Monochrome;
      // TODO(gabe): Is this right?
    case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange: return kFFPixelFormatType_YUV420P;
    default:
      return kFFPixelFormatType_None;
  }
}
