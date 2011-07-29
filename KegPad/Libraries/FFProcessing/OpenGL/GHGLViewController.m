//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import "GHGLViewController.h"
#import "GHGLDefines.h"
#import "GHGLCommon.h"

@implementation GHGLViewController

@synthesize GLView=_GLView;

- (id)initWithDrawable:(id<GHGLViewDrawable>)drawable {
	if ((self = [super init])) {
		_drawable = [drawable retain];
	}
	return self;
}

- (void)dealloc {
	[_GLView release];
	[_drawable release];
	[super dealloc];
}

- (void)loadView {
	_GLView = [[GHGLView alloc] init];
	NSAssert(_GLView, @"No GL view");
	_GLView.frame = CGRectMake(0, 0, 320, 480);
	_GLView.drawable = _drawable;
	self.view = _GLView;
}

@end
