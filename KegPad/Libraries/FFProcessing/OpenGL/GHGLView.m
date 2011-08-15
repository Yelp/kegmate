

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GHGLView.h"
#import "GHGLDefines.h"
#import "GHGLUtils.h"


@interface GHGLView ()
@property (retain, nonatomic) EAGLContext *context;
- (BOOL)_createFramebuffer;
- (void)_destroyFramebuffer;
@end


@implementation GHGLView

@synthesize backingWidth=_backingWidth, backingHeight=_backingHeight;
@synthesize context=_context; // Private properties

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {    
	if ((self = [super initWithFrame:frame])) {
		CAEAGLLayer *EAGLLayer = (CAEAGLLayer *)self.layer;
		
		EAGLLayer.opaque = YES;
		EAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
																		[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, 
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
#if kAttemptToUseOpenGLES2
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if (_context == NULL) {
#endif
			_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
			
			if (!_context) {
        GHGLDebug(@"No GL context");
				[self release];
				return nil;
			}
      if (![EAGLContext setCurrentContext:_context]) {
        GHGLDebug(@"Couldn't set current context");
				[self release];
				return nil;        
      }
#if kAttemptToUseOpenGLES2
		}
#endif

    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_maxTextureSize);
    _supportsNPOT = GHGLCheckForExtension(GHGLExtension_GL_APPLE_texture_2D_limited_npot);
    _supportsBGRA8888 = GHGLCheckForExtension(GHGLExtension_GL_IMG_texture_format_BGRA8888);
    
    GHGLDebug(@"GL_MAX_TEXTURE_SIZE: %d", _maxTextureSize);
    GHGLDebug(@"Supports BGRA8888 textures: %d", _supportsBGRA8888);
    GHGLDebug(@"Supports NPOT textures: %d", _supportsNPOT);
    
    _drawables = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[self stopAnimation];
	
	if ([EAGLContext currentContext] == _context) 
		[EAGLContext setCurrentContext:nil];

  [_displayLink invalidate];
	[_context release];
  [_drawables release];
	[super dealloc];
}

- (void)drawView {
  if ([_drawables count] == 0) return;
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
  BOOL render = NO;
  for (id<GHGLViewDrawable> drawable in _drawables) {
    render |= [drawable drawView:self];    
  }
  if (render) {
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
  }
}

- (void)layoutSubviews {
  if ([_drawables count] == 0) return;
	[EAGLContext setCurrentContext:_context];
	[self _destroyFramebuffer];
	[self _createFramebuffer];
	[self drawView];
}

- (NSArray *)drawables {
  return _drawables;
}

- (void)setDrawable:(id<GHGLViewDrawable>)drawable {
  [self removeDrawables];
  [self addDrawable:drawable];
}

- (void)removeDrawables {
  for (id<GHGLViewDrawable> drawable in _drawables) {
    [drawable stop];
  }
  [_drawables removeAllObjects];
}

- (void)removeDrawable:(id<GHGLViewDrawable>)drawable {
  [drawable stop];
  [_drawables removeObject:drawable];
}

- (void)addDrawable:(id<GHGLViewDrawable>)drawable {
  [_drawables addObject:drawable];
  if (_displayLink) [drawable start]; // Start if we are running
  [self setNeedsLayout];
}

- (BOOL)_createFramebuffer {    
	glGenFramebuffersOES(1, &_viewFramebuffer);
	glGenRenderbuffersOES(1, &_viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer *)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

	if (USE_DEPTH_BUFFER) {
		glGenRenderbuffersOES(1, &_depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderbuffer);
	}
	
	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		GHGLDebug(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
  for (id<GHGLViewDrawable> drawable in _drawables) {
    [drawable setupView:self];
  }
	return YES;
}

- (void)_destroyFramebuffer {
	glDeleteFramebuffersOES(1, &_viewFramebuffer);
	_viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
	_viewRenderbuffer = 0;
	
	if (_depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
		_depthRenderbuffer = 0;
	}
}

- (void)startAnimation {
  if (!_displayLink) {
    GHGLDebug(@"Start animation");
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];    
    //_displayLink.frameInterval = 3;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    GHGLDebug(@"Display link; frame interval %d", _displayLink.frameInterval);
  }
  if ([_drawables count] == 0) GHGLError(@"No drawable set, can't start it");
  for (id<GHGLViewDrawable> drawable in _drawables) {
    [drawable start];
  }
}

- (BOOL)isAnimating {
  return (!!_displayLink);
}

- (void)stopAnimation {
  if (_displayLink) {
    GHGLDebug(@"Stop animation");
    [_displayLink invalidate];
    _displayLink = nil;    
  }
  for (id<GHGLViewDrawable> drawable in _drawables) {
    [drawable stop];
  }
}

- (void)setFrameInterval:(NSInteger)frameInterval {
  GHGLDebug(@"Set frame interval: %d", frameInterval);
  _displayLink.frameInterval = frameInterval;
}

@end


@implementation GHGLViewDrawable

- (void)dealloc {
  glDeleteTextures(1, &_texture);
  [super dealloc];
}

- (void)setupView:(GHGLView *)view {
  GHGLDebug(@"Setup view; viewport: (%d, %d, %d, %d)", 0, 0, view.backingWidth, view.backingHeight);
  glViewport(0, 0, view.backingWidth, view.backingHeight);  
	glMatrixMode(GL_PROJECTION);
  
	glLoadIdentity();
  
	glOrthof(0, view.backingWidth, view.backingHeight, 0, -1, 1);
	glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  //glScalef(view.backingWidth, view.backingHeight, 1);

  glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnable(GL_TEXTURE_2D);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, &_texture);
  
  GHGLCheckError();
}

- (BOOL)drawView:(GHGLView *)view {
  // Subclasses should implement
  return NO;
}

- (void)start { }
- (void)stop { }

@end
