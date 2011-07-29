//
//  GHTextureManager.h
//  Betelgeuse
//
//  Created by Gabriel Handford on 12/25/09.
//  Copyright 2009. All rights reserved.
//

#import "GHGLTexture.h"

@interface GHTextureManager : NSObject {
  NSMutableDictionary *_textures;
}

- (void)addTexture:(id<GHGLTexture>)texture forKey:(id)key;

- (id<GHGLTexture>)textureForKey:(id)key;

@end
