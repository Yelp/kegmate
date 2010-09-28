//
//  KBDefines.h
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//


#define KBDebug(fmt, ...) do {} while(0)
#define KBError(fmt, ...) NSLog(fmt, ##__VA_ARGS__)

#if DEBUG
#undef KBDebug
#define KBDebug(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#endif
