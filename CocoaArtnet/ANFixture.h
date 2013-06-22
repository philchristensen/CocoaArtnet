//
//  ANFixture.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

UIColor* hex2UIColor(NSString* hexcolor, CGFloat alpha);
NSArray* hex2RGBArray(NSString* hexcolor);
NSString* RGB2Hex(int red, int green, int blue);
NSString* getHexColorInFade(NSString* start, NSString* end, int frameIndex, int totalFrames);
int getIntInFade(double start, double end, double frameIndex, double totalFrames);

@interface ANFixture : NSObject <NSCoding>
    @property int address;
    @property NSMutableArray* channels;
    @property NSMutableArray* values;
    @property NSMutableDictionary* config;
    @property NSMutableDictionary* definition;
    @property NSString* path;

    -(ANFixture*) initWithAddress: (int) anAddress;
    +(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath;
    +(NSArray*) getAvailableFixtureDefinitions;
    -(void) loadFixtureDefinition: (NSString*) aPath;
    -(void) installFixtureDefinition: (NSDictionary*) fixturedef;
    -(NSDictionary*) getCueState;
    -(NSArray*) getFrame;

    -(int) getValueOfType:(NSString*)type;
    -(int) getValueOfType:(NSString*)type andSubtype:(NSString*)subtype;
    -(void) setValue:(int)value ofType:(NSString*)type;
    -(void) setValue:(int)value ofType:(NSString*)type andSubtype:(NSString*)subtype;

    -(BOOL) hasColor;
    -(void) setColor:(NSString*) hexcolor;
    -(NSString*) getColor;
    -(void) setUIColor:(UIColor*) color;
    -(UIColor*) getUIColor;
    -(BOOL) hasStrobe;
    -(void) setStrobe:(int) level;
    -(int) getStrobe;
    -(BOOL) hasIntensity;
    -(void) setIntensity:(int) level;
    -(int) getIntensity;
@end
