//
//  ANRig.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/1/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANCue.h"
#import "ANFixture.h"

@interface ANRig : NSObject <NSCoding>

@property NSString* name;
@property NSString* rigPath;
@property NSMutableDictionary* fixtures;
@property NSMutableArray* cues;

+ (ANRig*)loadRigDefinition: (NSString*) rigPath;
- (BOOL)saveRigDefinition;
- (NSArray*)getFrame;
- (ANCue*)createCue;
- (ANCue*)createCue:(NSDictionary* (^)(NSString*))filter;
- (void)updateCue:(ANCue*)cue;

- (void)applyCue:(ANCue*)cue;
- (NSArray*)generateFadeToCue:(ANCue*)cue forSeconds:(int)secs atFPS:(int)fps;

@end
