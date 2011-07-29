//
//  FFUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFUtils.h"

void FFFill32BGRAImage(FFVFrameRef frame, NSInteger frameIndex) {  
  FFVFormat format = FFVFrameGetFormat(frame);
  assert(format.pixelFormat == kFFPixelFormatType_32BGRA);
  
  uint8_t *data = FFVFrameGetData(frame, 0);
  int bytesPerRow = FFVFrameGetBytesPerRow(frame, 0);
  int bytesPerPixel = FFVFrameGetBytesPerPixel(frame, 0);
  
  for (int y = 0; y < format.height; y++) {
    for (int x = 0; x < format.width; x++) {
      int p = (x * bytesPerPixel) + (y * bytesPerRow);
      data[p] = (y % 4 == 0 ? 255 : 0);
      data[p + 1] = (y % 4 == 1 ? 255 : 0);
      data[p + 2] = (y % 4 == 2 ? 0 : 255);
      data[p + 3] = (y % 4 == 3 ? 127 : 0);
    }
  }
}

void FFFillYUVImage(FFVFrameRef frame, NSInteger frameIndex) {
  
  FFVFormat format = FFVFrameGetFormat(frame);
  assert(format.pixelFormat == kFFPixelFormatType_YUV420P);

  uint8_t *data0 = FFVFrameGetData(frame, 0);
  int linesize0 = FFVFrameGetBytesPerRow(frame, 0);
  
  /* Y */
  for (int y = 0; y < format.height; y++) {
    for (int x = 0; x < format.width; x++) {
      data0[y * linesize0 + x] = x + y + frameIndex * 3;
    }
  }
  
  uint8_t *data1 = FFVFrameGetData(frame, 1);
  int linesize1 = FFVFrameGetBytesPerRow(frame, 1);

  uint8_t *data2 = FFVFrameGetData(frame, 2);
  int linesize2 = FFVFrameGetBytesPerRow(frame, 2);

  /* Cb and Cr */
  for (int y = 0; y < format.height/2.0; y++) {
    for (int x = 0; x < format.width/2.0; x++) {
      data1[y * linesize1 + x] = 128 + y + frameIndex * 2;
      data2[y * linesize2 + x] = 64 + x + frameIndex * 5;
    }
  }  
}

FFRational FFFindRationalApproximation(float r, long maxden) {  

  long m[2][2];
  long ai;
  float x = r;
  
  // initialize matrix
  m[0][0] = m[1][1] = 1;
  m[0][1] = m[1][0] = 0;
  
  // loop finding terms until denom gets too big
  while (m[1][0] * (ai = (long)x ) + m[1][1] <= maxden) {
    long t;
    t = m[0][0] * ai + m[0][1];
    m[0][1] = m[0][0];
    m[0][0] = t;
    t = m[1][0] * ai + m[1][1];
    m[1][1] = m[1][0];
    m[1][0] = t;
    if (x == (double)ai) break;     // AF: division by zero
    x = 1/(x - (double) ai);
    if (x > (double)0x7FFFFFFF) break;  // AF: representation failure
  } 
  
  return (FFRational){m[0][0], m[1][0]};
}

double FFAngleRadians(double x, double y) {
  double xu, yu, ang;
  
  xu = fabs(x);
  yu = fabs(y);
  
  if ((xu == 0) && (yu == 0)) return(0);
  
  ang = atan(yu/xu);
  
  if(x >= 0){
    if(y >= 0) return(ang);
    else return(2*M_PI - ang);
  }
  else{
    if(y >= 0) return(M_PI - ang);
    else return(M_PI + ang);
  }
}

/*!
 #pragma mark FFRBG
 
 static inline void FFVFrameGetRGB(FFVFrameRef frame, int x, int y, uint8_t *r, uint8_t *g, uint8_t *b) {
 //NSAssert(frame->format.pixelFormat == , @"Only supports RGB24");
 int p = (x * (FFVFrameGetBytesPerPixel(frame, 0))) + (y * FFVFrameGetBytesPerRow(frame, 0));
 
 uint8_t *data = FFVFrameGetData(frame, 0);
 *r = data[p];
 *g = data[p + 1];
 *b = data[p + 2];
 }
 
 static inline void FFVFrameSetRGB(FFVFrameRef frame, int x, int y, uint8_t r, uint8_t g, uint8_t b) {
 int p = (x * (FFVFrameGetBytesPerPixel(frame, 0))) + (y * FFVFrameGetBytesPerRow(frame, 0));
 uint8_t *data = FFVFrameGetData(frame, 0);
 data[p] = r;
 data[p + 1] = g;
 data[p + 2] = b;
 }
 */

@implementation FFUtils

+ (NSString *)documentsDirectory {	
	static NSString *DocumentsDirectory = NULL;
  if (DocumentsDirectory == NULL) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsDirectory = [[paths objectAtIndex:0] copy];
	}
	return DocumentsDirectory;
}

+ (NSString *)resolvedPathForURL:(NSURL *)URL {  
  URL = [self resolvedURLForURL:URL];
  if ([URL isFileURL]) return [URL path];
  return [URL absoluteString];
}

+ (NSURL *)resolvedURLForURL:(NSURL *)URL {
  if ([[URL scheme] isEqualToString:@"bundle"]) {
    NSString *path = [URL host];
    NSString *pathInBundle = [[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:[path pathExtension]];
    if (!pathInBundle) {
      FFDebug(@"Path in bundle not found: %@", path);
      return nil;
    }
    return [NSURL fileURLWithPath:pathInBundle];
  }  
  return URL;  
}

@end
