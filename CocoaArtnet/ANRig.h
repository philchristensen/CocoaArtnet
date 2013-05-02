//
//  ANRig.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/1/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANRig : NSObject <NSCoding>

@property NSString* name;
@property NSMutableDictionary* fixtures;

+(ANRig*) loadRigDefinition: (NSString*) rigName;

@end
