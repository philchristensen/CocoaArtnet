//
//  ANFixture.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANFixture.h"
#import <YACYAML/YACYAML.h>

@implementation ANFixture
@synthesize address;
@synthesize controls;

-(ANFixture*) initWithAddress: (int) anAddress {
    self = [super init];
    self.address = anAddress;
    return self;
}

+(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath {
    ANFixture* fixture = [[ANFixture alloc] initWithAddress:anAddress];
    [fixture loadFixtureDefinition:aPath];
    return fixture;
}

-(void) loadFixtureDefinition: (NSString*) fixturePath {
    
    NSString* yaml = [[NSString alloc] initWithContentsOfFile:fixturePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    NSDictionary* fixturedef = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
    [controls setValue: [[RGBControl alloc] initWith: fixturedef] forKey:@"rgb"];
    [controls setValue: [[StrobeControl alloc] initWith: fixturedef] forKey:@"strobe"];
    [controls setValue: [[IntensityControl alloc] initWith: fixturedef] forKey:@"intensity"];
}

@end

@implementation RGBControl
@synthesize r_value;
@synthesize g_value;
@synthesize b_value;
@synthesize r_offset;
@synthesize g_offset;
@synthesize b_offset;

-(RGBControl*) initWith: (NSDictionary*) fixturedef {
	self = [super init];

    return self;
}

-(NSArray*) getState {
	return @[
          @[@(self.r_offset), @(self.r_value)],
          @[@(self.g_offset), @(self.g_value)],
          @[@(self.b_offset), @(self.b_value)]
          ];
}

-(void) setColor:(NSString*) hexcolor {
	
}

-(NSString*) getColor {
	return @"#ffffff";
}

@end

@implementation StrobeControl
@synthesize offset;
@synthesize value;

-(StrobeControl*) initWith: (NSDictionary*) fixturedef {
	self = [super init];
    
    return self;
}

-(NSArray*) getState {
	return @[
          @[@(self.offset), @(self.value)]
          ];
}

-(void) setStrobe:(int) level {
	self.value = level;
}

-(int) getStrobe {
	return self.value;
}

@end

@implementation IntensityControl
@synthesize offset;
@synthesize offset_fine;
@synthesize value;

-(IntensityControl*) initWith: (NSDictionary*) fixturedef {
	self = [super init];
    
    return self;
}

-(NSArray*) getState {
	return @[
          @[@(self.offset), @(self.value)]
          ];
}

-(void) setIntensity:(int) level {
	self.value = level;
}

-(int) getIntensity {
	return self.value;
}

@end

@implementation ProgramControl
@synthesize offset;
@synthesize speedOffset;
@synthesize value;
@synthesize speedValue;
@synthesize currentMacro;
@synthesize macros;

-(ProgramControl*) initWith: (NSDictionary*) fixturedef {
	self = [super init];
    
    return self;
}

-(NSArray*) getState {
	return @[
          @[@(self.offset), @(self.value)],
          @[@(self.speedOffset), @(self.speedValue)]
          ];
}

@end
