//
//  FFTypes.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"
#import "FFUtils.h"

FFVFormat FFVFormatNone = {0, 0, kFFPixelFormatType_None};

FFVFrameRef _FFVFrameCreateWithData(FFVFormat format, uint8_t *data);

int FFVFormatGetSize(FFVFormat format) {
  int bytesPerPixel = 0;
  switch (format.pixelFormat) {
    case kFFPixelFormatType_32BGRA: bytesPerPixel = 4; break;
    case kFFPixelFormatType_32RGBA: bytesPerPixel = 4; break;
    case kFFPixelFormatType_32ARGB: bytesPerPixel = 4; break;
    case kFFPixelFormatType_24RGB: bytesPerPixel = 3; break;
    case kFFPixelFormatType_1Monochrome: bytesPerPixel = 1; break;
    case kFFPixelFormatType_YUV420P: bytesPerPixel = 3; break;
    default:
      FFWarn(@"No bytesPerPixel for pixel format: %d", format.pixelFormat);
      break;
  }
  return (format.width * format.height * bytesPerPixel);  
}

BOOL FFVFormatIsEqual(FFVFormat format1, FFVFormat format2) {
  return (format1.width == format2.width && format1.height == format2.height && format1.pixelFormat == format2.pixelFormat);
}

FFVFrameRef FFVFrameCreate(FFVFormat format) {
  int size = FFVFormatGetSize(format);
  FFDebug(@"Creating data size: %d", size);
  uint8_t *data = malloc(size);  
  if (data == NULL)
    return NULL;
  return _FFVFrameCreateWithData(format, data);  
}

void FFVFrameCopy(FFVFrameRef source, FFVFrameRef dest) {
  dest->format = source->format;
  dest->pts = source->pts;
  dest->flags = source->flags;  
  memcpy(dest->data, &source->data, FFVFormatGetSize(source->format)); 
  memcpy(dest->linesize, &source->linesize, sizeof(int) * 4); 
}

void FFVFrameReleaseData(FFVFrameRef frame) {
  if (frame == NULL) return;
  if (((frame->flags & FFVFLAGS_EXTERNAL_DATA) != FFVFLAGS_EXTERNAL_DATA) && frame->data != NULL && frame->data[0] != NULL) {
    FFDebug(@"Releasing data");
    free(frame->data);
  }  
}

void _FFVFrameSetData(FFVFrameRef frame, uint8_t *data) {
  FFVFormat format = FFVFrameGetFormat(frame);    
    
  int width = format.width;
  int height = format.height;

  switch (format.pixelFormat) {
    case kFFPixelFormatType_32BGRA:
    case kFFPixelFormatType_32RGBA:
    case kFFPixelFormatType_32ARGB:
      //FFDebug(@"Set data non-planar 4bpp");
      frame->linesize[0] = frame->format.width * 4;      
      frame->linesize[1] = 0;
      frame->linesize[2] = 0;
      frame->linesize[3] = 0;
      frame->data[0] = data;
      frame->data[1] = NULL;
      frame->data[2] = NULL;
      frame->data[3] = NULL;       
      break;
      
    case kFFPixelFormatType_YUV420P: {     
      //FFDebug(@"Set data planar yuv");
      //int w2 = (width + (1 << log2ChromaW) - 1) >> log2ChromaW;        
      int w2 = (width / 2.0);
      int h2 = (height / 2.0);
      frame->linesize[0] = width;
      frame->linesize[1] = w2;
      frame->linesize[2] = w2;
      frame->linesize[3] = 0;
      
      int size = frame->linesize[0] * height;
      int size2 = frame->linesize[1] * h2;
      frame->data[0] = data;
      frame->data[1] = frame->data[0] + size;
      frame->data[2] = frame->data[1] + size2;
      frame->data[3] = NULL;
      break;
    }
      
    case kFFPixelFormatType_24RGB:
      //FFDebug(@"Set data non-planar rgb");
      frame->linesize[0] = width * 3;
      frame->linesize[1] = 0;
      frame->linesize[2] = 0;
      frame->linesize[3] = 0;      
      frame->data[0] = data;
      frame->data[1] = NULL;
      frame->data[2] = NULL;
      frame->data[3] = NULL;
      break;
      
    case kFFPixelFormatType_1Monochrome:        
      //FFDebug(@"Set data non-planar monochrome");
      frame->linesize[0] = width;
      frame->linesize[1] = 0;
      frame->linesize[2] = 0;
      frame->linesize[3] = 0;      
      frame->data[0] = data;
      frame->data[1] = NULL;
      frame->data[2] = NULL;
      frame->data[3] = NULL;
      break;
      
    default:
      // TODO(gabe): FAIL
      break;
  }
}

void FFVFrameSetData(FFVFrameRef frame, uint8_t *data) {
  FFVFrameReleaseData(frame);
  if (data != NULL) {
    _FFVFrameSetData(frame, data);
    frame->flags |= FFVFLAGS_EXTERNAL_DATA;
  }
}

FFVFrameRef _FFVFrameCreateWithData(FFVFormat format, uint8_t *data) {  
  FFVFrameRef frame = (FFVFrameRef)calloc(1, sizeof(_FFVFrame));  
  if (frame != NULL) {
    frame->format = format;
    if (data != NULL) _FFVFrameSetData(frame, data);
  }
  return frame;  
}

FFVFrameRef FFVFrameCreateWithData(FFVFormat format, uint8_t *data) {  
  FFVFrameRef frame = _FFVFrameCreateWithData(format, data);
  if (data != NULL) frame->flags |= FFVFLAGS_EXTERNAL_DATA;
  return frame;
}

void FFVFrameRelease(FFVFrameRef frame) {
  if (frame) {
    FFVFrameReleaseData(frame);
    free(frame);
  }
}

#pragma mark - 

NSData *JPEGDataCreateFromFFVFrame(FFVFrameRef frame, float quality) {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  int bytesPerRow = (frame->format.width) * 4;
  CGContextRef context = CGBitmapContextCreate(frame->data[0], frame->format.width, frame->format.height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
  CGImageRef cgImage = CGBitmapContextCreateImage(context);
  UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationRight];
  NSData *data = [UIImageJPEGRepresentation(image, quality) retain];
  CGImageRelease(cgImage);
  CGContextRelease(context);
  CGColorSpaceRelease(colorSpace);
  return data;
}

CGImageRef CGImageCreateFromJPEGData(NSData *JPEGData) {
  CGDataProviderRef source = CGDataProviderCreateWithCFData((CFDataRef)JPEGData);
  CGImageRef image = CGImageCreateWithJPEGDataProvider(source, NULL, NO, kCGRenderingIntentDefault);
  CGDataProviderRelease(source);
  return image;
}

void FFConvertFromJPEGDataToBGRA(CGImageRef image, FFVFrameRef frame) {
 /*
  int width = CGImageGetWidth(image);
  int height = CGImageGetHeight(image);
  size_t bpp = CGImageGetBitsPerPixel(image);
  FFDebug(@"JPEG, width=%d, height=%d, bpp=%d", width, height, bpp);
   */
  CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(image));
  CFIndex length = CFDataGetLength(dataRef);  
  uint8_t *output = FFVFrameGetData(frame, 0);
  
  // Convert from BGRA to RGBA
  /*
  uint32_t *p = (uint32_t *)CFDataGetBytePtr(dataRef);
  for (int i = 0; i < (length/4); i++) {
    output[i] = ((p[i] >> 16) & 0xFF) | (p[i] & 0xFF00FF00) | ((p[i] & 0xFF) << 16);
  }
   */
  
  uint8_t *p = (uint8_t *)CFDataGetBytePtr(dataRef);
  for (int i = 0; i < length; i += 4) {
    output[i] = p[i + 2];
    output[i + 1] = p[i + 1];
    output[i + 2] = p[i];
    output[i + 3] = 0xFF;
  }
  CFRelease(dataRef);
}

FFVFrameRef FFVFrameCreateFromCGImage(CGImageRef image) {

  //CGBitmapInfo info = CGImageGetBitmapInfo(image); // CGImage may return pixels in RGBA, BGRA, or ARGB order
	CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(image));
	size_t bpp = CGImageGetBitsPerPixel(image);
  
  FFPixelFormat pixelFormat = kFFPixelFormatType_None;
  if (colorSpaceModel == kCGColorSpaceModelRGB && bpp >= 24 && bpp <= 32) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image);
    switch (alphaInfo) {
      case kCGImageAlphaPremultipliedLast: pixelFormat = kFFPixelFormatType_32RGBA; break;
      case kCGImageAlphaPremultipliedFirst: pixelFormat = kFFPixelFormatType_32ARGB; break;
      case kCGImageAlphaNone: pixelFormat = kFFPixelFormatType_24RGB; break;
      default: FFWarn(@"Invalid alpha info: %d", alphaInfo); break;
    }
  } else if (colorSpaceModel == kCGColorSpaceModelMonochrome && bpp == 8) {
    pixelFormat = kFFPixelFormatType_1Monochrome;
  }
  
  if (pixelFormat == kFFPixelFormatType_None) {
    FFWarn(@"Invalid pixel format for colorSpaceModel=%d, bpp=%d", colorSpaceModel, bpp);
    return NULL;
  }
  FFVFormat format = FFVFormatMake(CGImageGetWidth(image), CGImageGetHeight(image), pixelFormat);
  
  CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(image));
  uint8_t *data = (uint8_t *)CFDataGetBytePtr(dataRef);  
  CFIndex length = CFDataGetLength(dataRef);
  uint8_t *dataCopy = malloc(length);
  memcpy(dataCopy, data, length); 
  CFRelease(dataRef);
  
  return FFVFrameCreateWithData(format, dataCopy);
}
