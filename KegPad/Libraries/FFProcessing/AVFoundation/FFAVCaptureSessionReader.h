//
//  FFAVCaptureSessionReader.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FFReader.h"

#if !TARGET_IPHONE_SIMULATOR
@interface FFAVCaptureSessionReader : NSObject <FFReader, AVCaptureVideoDataOutputSampleBufferDelegate> {
  AVCaptureSession *_captureSession;
  AVCaptureVideoDataOutput *_videoOutput;
  
  FFVFrameRef _frame;
  BOOL _dataChanged;
  BOOL _wantsData;

  uint8_t *_data; // Data from camera
  size_t _dataSize;
  
  CVImageBufferRef _imageBuffer;
  
  dispatch_queue_t _queue;
}

@end
#else
@interface FFAVCaptureSessionReader : NSObject <FFReader> { 
  FFVFrameRef _frame;
}
@end
#endif

