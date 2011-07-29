//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class GHGLView;

@protocol GHGLViewDrawable <NSObject>
- (void)start;
- (void)stop;
- (BOOL)drawView:(GHGLView *)view;
- (void)setupView:(GHGLView *)view;
@end

@interface GHGLView : UIView {
	GLint _backingWidth;
	GLint _backingHeight;
    
	EAGLContext *_context;    
	GLuint _viewRenderbuffer;
	GLuint _viewFramebuffer;
	GLuint _depthRenderbuffer;
	
	CADisplayLink *_displayLink;
    
  GLint _maxTextureSize;
  BOOL _supportsBGRA8888;
  BOOL _supportsNPOT;
  
	id<GHGLViewDrawable> _drawable; // weak
		
}

@property (retain, nonatomic) id<GHGLViewDrawable> drawable;
@property (readonly, nonatomic) GLint backingWidth;
@property (readonly, nonatomic) GLint backingHeight;


- (void)startAnimation;
- (void)stopAnimation;
- (BOOL)isAnimating;
- (void)drawView;

- (void)setFrameInterval:(NSInteger)frameInterval;

@end


@interface GHGLViewDrawable : NSObject <GHGLViewDrawable> {
  GLuint _texture;
  BOOL _textureLoaded;
}

@end