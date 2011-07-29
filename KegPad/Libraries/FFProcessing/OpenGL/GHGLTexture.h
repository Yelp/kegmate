//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

// For lightweight texture struct use Texture from GHGLCommon.h

@protocol GHGLTexture <NSObject>
@property (readonly, nonatomic) GLuint textureId;
- (void)bind;
@end

@interface GHGLTexture : NSObject <GHGLTexture> {
	GLuint _texture[1];
  GLuint _width;
  GLuint _height;
}

@property (readonly, nonatomic) GLuint textureId;
@property (readonly, nonatomic) GLuint width;
@property (readonly, nonatomic) GLuint height;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name width:(GLuint)width height:(GLuint)height;

+ (void)useDefaultTexture;

- (void)drawInRect:(CGRect)rect;

@end
