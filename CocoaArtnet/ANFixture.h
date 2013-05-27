//
//  ANFixture.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <inttypes.h>
#import <UIKit/UIColor.h>

UIColor* hex2UIColor(NSString* hexcolor, CGFloat alpha);
NSArray* hex2RGBArray(NSString* hexcolor);
NSString* RGB2Hex(int red, int green, int blue);
NSString* getHexColorInFade(NSString* start, NSString* end, int frameIndex, int totalFrames);
int getIntInFade(double start, double end, double frameIndex, double totalFrames);

@interface ANFixture : NSObject <NSCoding>
    @property int address;
    @property NSMutableDictionary* controls;
    @property NSMutableDictionary* config;
    @property NSMutableDictionary* fixtureDefinition;
    @property NSString* fixtureConfigPath;

    -(ANFixture*) initWithAddress: (int) anAddress;
    +(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath;
    -(void) loadFixtureDefinition: (NSString*) aPath;
    -(NSArray*) getChannels;
    -(NSDictionary*) getCueState;
    -(NSArray*) getFrame;
@end

@interface RGBControl : NSObject
    @property ANFixture* fixture;
    @property int r_value;
    @property int g_value;
    @property int b_value;
    @property int r_offset;
    @property int g_offset;
    @property int b_offset;

    -(RGBControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef;
    -(NSArray*) getChannels;
    -(void) setColor:(NSString*) hexcolor;
    -(NSString*) getColor;
    -(void) setUIColor:(UIColor*) color;
    -(UIColor*) getUIColor;
@end

@interface ANFixture (RGBFixture)
    -(void) setColor:(NSString*) hexcolor;
    -(NSString*) getColor;
    -(void) setUIColor:(UIColor*) color;
    -(UIColor*) getUIColor;
@end

@interface StrobeControl : NSObject
    @property ANFixture* fixture;
    @property int offset;
    @property int value;

    -(StrobeControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef;
    -(NSArray*) getChannels;
    -(void) setStrobe:(int) level;
    -(int) getStrobe;
@end

@interface ANFixture (StrobeFixture)
    -(void) setStrobe:(int) level;
    -(int) getStrobe;
@end

@interface IntensityControl : NSObject
    @property ANFixture* fixture;
    @property int offset;
    @property int offset_fine;
    @property int value;

    -(IntensityControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef;
    -(NSArray*) getChannels;
    -(void) setIntensity:(int) level;
    -(int) getIntensity;
@end

@interface ANFixture (IntensityFixture)
    -(void) setIntensity:(int) level;
    -(int) getIntensity;
@end

@interface ProgramControl : NSObject
    @property ANFixture* fixture;
    @property int offset;
    @property int speedOffset;
    @property int value;
    @property int speedValue;
    @property NSString* macroType;
    @property NSMutableDictionary* macros;

    -(ProgramControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef andChannel: (NSDictionary*) aChannel;
    -(NSArray*) getChannels;
    -(void) setMacro: (NSString*) macroName withValue: (int) aValue andSpeed: (int) aSpeed;
    -(void) setMacro: (NSString*) macroName withValue: (int) aValue;
@end

@interface ANFixture (ProgramFixture)

@end
