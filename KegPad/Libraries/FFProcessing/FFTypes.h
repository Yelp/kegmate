//
//  FFTypes.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

typedef enum {
  kFFPixelFormatType_None = 0,
  kFFPixelFormatType_YUV420P,
  kFFPixelFormatType_32BGRA,
  kFFPixelFormatType_32RGBA,
  kFFPixelFormatType_32ARGB,
  kFFPixelFormatType_24RGB,
  kFFPixelFormatType_1Monochrome,  
} FFPixelFormat;

typedef struct {
  int width;
  int height;
  FFPixelFormat pixelFormat;
} FFVFormat;

struct __FFVFrame {  
  uint8_t *data[4]; //! Pointer to the picture planes  
  int linesize[4]; //! Line size of picture planes
  
  int64_t pts;
  FFVFormat format;
  int32_t flags; // Flags (see FFVFLAGS)
} _FFVFrame;

typedef enum {
  FFVFLAGS_EXTERNAL_DATA = 1 << 1
} FFVFLAGS;

typedef struct _FFRational {
  int num; // Numerator
  int den; // Denominator
} FFRational;

typedef struct __FFVFrame *FFVFrameRef;

#pragma mark FFAVFormat

static inline FFVFormat FFVFormatMake(int width, int height, FFPixelFormat pixelFormat) {
  return (FFVFormat){width, height, pixelFormat};
}

static inline NSString *NSStringFromFFVFormat(FFVFormat format) {
  return [NSString stringWithFormat:@"(%d,%d,%d)", format.width, format.height, format.pixelFormat];
}

BOOL FFVFormatIsEqual(FFVFormat format1, FFVFormat format2);

extern FFVFormat FFVFormatNone;

#pragma mark FFVFrame

FFVFrameRef FFVFrameCreate(FFVFormat format);

FFVFrameRef FFVFrameCreateWithData(FFVFormat format, uint8_t *data);

void FFVFrameSetData(FFVFrameRef frame, uint8_t *data);

void FFVFrameRelease(FFVFrameRef frame);

void FFVFrameCopy(FFVFrameRef source, FFVFrameRef dest);

FFVFrameRef FFVFrameCreateFromCGImage(CGImageRef image);

int FFVFormatGetSize(FFVFormat format);

#pragma mark JPEG

NSData *JPEGDataCreateFromFFVFrame(FFVFrameRef frame, float quality);

CGImageRef CGImageCreateFromJPEGData(NSData *JPEGData);

void FFConvertFromJPEGDataToBGRA(CGImageRef image, FFVFrameRef frame);

#pragma mark - 

static inline uint8_t *FFVFrameGetData(FFVFrameRef frame, int index) {
  return frame->data[index];
}

static inline NSUInteger FFVFrameGetBytesPerPixel(FFVFrameRef frame, int index) {
  return frame->linesize[index] / frame->format.width;
}

static inline NSUInteger FFVFrameGetBytesPerRow(FFVFrameRef frame, int index) {
  return frame->linesize[index];
}

static inline FFVFormat FFVFrameGetFormat(FFVFrameRef frame) {
  return frame->format;
}

static inline int FFFrameGetPosition(FFVFrameRef frame, int x, int y) {
  int bytesPerRow = FFVFrameGetBytesPerRow(frame, 0);
  int bytesPerPixel = FFVFrameGetBytesPerPixel(frame, 0);  
  return (x * bytesPerPixel) + (y * bytesPerRow);  
}

#pragma mark Filters

typedef enum {
  FFFilterEdge = 1 << 0,
  FFFilterErode = 1 << 1,
} FFFilterMode;

