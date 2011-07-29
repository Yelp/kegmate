//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import <UIKit/UIKit.h>
#import "GHGLView.h"

@interface GHGLViewController : UIViewController {
	GHGLView *_GLView;
	id<GHGLViewDrawable> _drawable;
}

@property (readonly, nonatomic) GHGLView *GLView;

- (id)initWithDrawable:(id<GHGLViewDrawable>)drawable;

@end
