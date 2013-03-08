//
//  ANFixture.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <inttypes.h>

@interface ANFixture : NSObject
    @property int address;
    @property NSMutableDictionary* controls;

    -(ANFixture*) initWithAddress: (int) anAddress;
    +(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath;
    -(void) loadFixtureDefinition: (NSString*) aPath;
@end

@interface RGBControl : NSObject
    @property int r_value;
    @property int g_value;
    @property int b_value;
    @property int r_offset;
    @property int g_offset;
    @property int b_offset;

    -(RGBControl*) initWith: (NSDictionary*) fixturedef;
    -(NSArray*) getState;
    -(void) setColor:(NSString*) hexcolor;
    -(NSString*) getColor;
@end

@interface StrobeControl : NSObject
    @property int offset;
    @property int value;

    -(StrobeControl*) initWith: (NSDictionary*) fixturedef;
    -(NSArray*) getState;
    -(void) setStrobe:(int) level;
    -(int) getStrobe;
@end

@interface IntensityControl : NSObject
    @property int offset;
    @property int offset_fine;
    @property int value;

    -(IntensityControl*) initWith: (NSDictionary*) fixturedef;
    -(NSArray*) getState;
    -(void) setIntensity:(int) level;
    -(int) getIntensity;
@end

@interface ProgramControl : NSObject
    @property int offset;
    @property int speedOffset;
    @property int value;
    @property int speedValue;
    @property NSString* macroType;
    @property NSMutableDictionary* macros;

    -(ProgramControl*) initWith: (NSDictionary*) fixturedef andChannel: (NSDictionary*) aChannel;
    -(NSArray*) getState;
    -(void) setMacro: (NSString*) macroName withValue: (int) aValue andSpeed: (int) aSpeed;
@end
