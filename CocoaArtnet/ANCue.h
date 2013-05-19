//
//  ANCue.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/19/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANCue : NSObject <NSCoding>

@property NSString* name;
@property NSMutableDictionary* config;

@end
