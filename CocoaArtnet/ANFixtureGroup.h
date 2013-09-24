//
//  ANFixtureGroup.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 3/16/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANFixtureGroup : NSObject
    @property NSMutableArray* fixtures;
    -(ANFixtureGroup*) initWithFixtures: (NSArray*) someFixtures;
    -(NSArray*) getFrame;
@end

@interface ANFixtureGroup (RGBFixtureGroup)
    -(void) setColor:(NSString*) hexcolor;
    -(NSString*) getColor;
@end

@interface ANFixtureGroup (StrobeFixtureGroup)
    -(void) setStrobe:(int) level;
    -(int) getStrobe;
@end

@interface ANFixtureGroup (IntensityFixtureGroup)
    -(void) setIntensity:(int) level;
    -(int) getIntensity;
@end
