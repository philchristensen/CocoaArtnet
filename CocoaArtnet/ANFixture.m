//
//  ANFixture.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <stdlib.h>
#import "ANFixture.h"
#import <YACYAML/YACYAML.h>
#import <UIKit/UIColor.h>

NSArray* hex2RGBArray(NSString* hexcolor){
    NSScanner* scanner = [NSScanner scannerWithString:hexcolor];
    unsigned int hex;
    int r = 0, g = 0, b = 0;
    if ([scanner scanHexInt:&hex]) {
        // Parsing successful. We have a big int representing the 0xBD8F60 value
        r = (hex >> 16) & 0xFF; // get the first byte
        g = (hex >>  8) & 0xFF; // get the middle byte
        b = (hex      ) & 0xFF; // get the last byte
    } else {
        NSLog(@"Parsing error: no hex value found in string");
    }
    return @[@(r), @(g), @(b)];
}

UIColor* hex2UIColor(NSString* hexcolor, CGFloat alpha) {
    NSArray* rgb = hex2RGBArray(hexcolor);
    return [UIColor colorWithRed: [rgb[0] floatValue] / 255
                           green: [rgb[1] floatValue] / 255
                            blue: [rgb[2] floatValue] / 255
                           alpha: alpha];
}


NSString* RGB2Hex(int red, int green, int blue){
    return [NSString stringWithFormat:@"%02x%02x%02x", red, green, blue];
}

int getIntInFade(double start, double end, double frameIndex, double totalFrames) {
    return (int)(start + (((end - start) / (totalFrames - 1)) * frameIndex));
}

NSString* getHexColorInFade(NSString* start, NSString* end, int frameIndex, int totalFrames){
    if(frameIndex == 0) return start;
    if(frameIndex == totalFrames - 1) return end;
    
    NSArray* startRGB = hex2RGBArray(start);
    NSArray* endRGB = hex2RGBArray(end);
    return RGB2Hex(
       getIntInFade([startRGB[0] intValue], [endRGB[0] intValue], frameIndex, totalFrames),
       getIntInFade([startRGB[1] intValue], [endRGB[1] intValue], frameIndex, totalFrames),
       getIntInFade([startRGB[2] intValue], [endRGB[2] intValue], frameIndex, totalFrames)
    );
}

@implementation ANFixture
@synthesize address;
@synthesize controls;
@synthesize fixtureConfigPath;
@synthesize config;

-(ANFixture*) initWithAddress: (int) anAddress {
    self = [super init];
    self.address = anAddress;
    self.config = [[NSMutableDictionary alloc] init];
    self.controls = [[NSMutableDictionary alloc] init];
    return self;
}

+(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath {
    ANFixture* fixture = [[ANFixture alloc] initWithAddress:anAddress];
    [fixture loadFixtureDefinition:aPath];
    return fixture;
}

+(NSArray*) getAvailableFixtureDefinitions {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for(NSString* subdir in [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"FixtureDefinitions"]){
        NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:subdir];
        NSString* baseDirectory = [[subdir pathComponents] lastObject];
        NSString* fixtureFile;
        while(fixtureFile = [dirEnum nextObject]){
            NSString* savedPath = [NSString stringWithFormat:@"%@/FixtureDefinitions/%@/%@", documentsDirectory, baseDirectory, fixtureFile];
            if([[NSFileManager defaultManager] fileExistsAtPath:savedPath]){
                [result addObject:savedPath];
            }
            else{
                [result addObject:[subdir stringByAppendingPathComponent:fixtureFile]];
            }
        }
    }
    
    return result;
}

-(void) loadFixtureDefinition: (NSString*) fixturePath {
    @autoreleasepool {
        self.fixtureConfigPath = fixturePath;
        
        NSString *bundlePath;
        if([fixturePath hasPrefix:@"/"]){
            bundlePath = fixturePath;
        }
        else{
            bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"FixtureDefinitions/%@", fixturePath]
                                                               ofType:@"yaml"];
        }
        
        NSString* yaml = [[NSString alloc] initWithContentsOfFile:bundlePath
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
        // TODO: test this, and use it
        
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        //NSString *documentsDirectory = [paths objectAtIndex:0];
        //
        //NSString* resourcePath = [NSString stringWithFormat:@"FixtureDefinitions/%@", fixturePath];
        //NSString* savedPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.yaml", resourcePath]];
        //NSString* realPath;
        //if([[NSFileManager defaultManager] fileExistsAtPath:savedPath]){
        //    realPath = savedPath;
        //}
        //else {
        //    realPath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"yaml"];
        //}
        //NSString* yaml = [[NSString alloc] initWithContentsOfFile:realPath
        //                                                 encoding:NSUTF8StringEncoding
        //                                                    error:nil];
        
        NSMutableDictionary* fixturedef = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
        self.fixtureDefinition = fixturedef;
        
        RGBControl* rgb = [[RGBControl alloc] initWithFixture:self andDefinition:fixturedef];
        [rgb setColor:self.config[@"color"]];
        [self.controls setValue: rgb forKey:@"rgb"];

        StrobeControl* strobe = [[StrobeControl alloc] initWithFixture:self andDefinition:fixturedef];
        [strobe setStrobe:[self.config[@"strobe"] intValue]];
        [self.controls setValue: strobe forKey:@"strobe"];
        
        IntensityControl* intensity = [[IntensityControl alloc] initWithFixture:self andDefinition:fixturedef];
        [intensity setIntensity:[self.config[@"intensity"] intValue]];
        [self.controls setValue: intensity forKey:@"intensity"];
        
        for(NSDictionary* channel in fixturedef[@"program_channels"]){
            [controls setValue: [[ProgramControl alloc] initWithFixture:self
                                                          andDefinition:fixturedef
                                                             andChannel:channel]
                        forKey: [NSString stringWithFormat:@"program-%d",
                                 [channel[@"offset"] integerValue]
                                 ]
             ];
        }
    }
}


-(void) forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    for (NSString* key in self.controls) {
        id ctl = self.controls[key];
        if([ctl respondsToSelector:aSelector]){
            [anInvocation invokeWithTarget:ctl];
            return;
        }
    }
    [super forwardInvocation:anInvocation];
}

-(NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if(signature) {
        return signature;
    }
    
    for (NSString* key in self.controls) {
        id ctl = self.controls[key];
        if([ctl respondsToSelector:aSelector]){
            return [[ctl class] instanceMethodSignatureForSelector:aSelector];
        }
    }
    return nil;
}

-(NSArray*) getChannels {
    @autoreleasepool {
        NSMutableArray* result = [[NSMutableArray alloc] init];
        for(NSString* key in [[self.controls allKeys] sortedArrayUsingComparator: ^(id a, id b){
            return ([a hasPrefix:@"program-"] ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedAscending);
        }]){
            id ctl = self.controls[key];
            [result addObjectsFromArray:[ctl getChannels]];
        }
        return result;
    }
}

-(NSDictionary*) getCueState {
    NSMutableDictionary* cueState = [[NSMutableDictionary alloc] init];
    cueState[@"color"] = [self getColor];
    cueState[@"intensity"] = @([self getIntensity]);
    cueState[@"strobe"] = @([self getStrobe]);
    return cueState;
}

-(NSArray*) getFrame {
    @autoreleasepool {
        NSMutableArray* frame = [[NSMutableArray alloc] init];
        for(int i = 0; i < 512; i++){
            frame[i] = @-1;
        }
        for(NSArray* channelSet in [self getChannels]){
            frame[[channelSet[0] integerValue] + self.address - 1] = channelSet[1];
        }
        return frame;
    }
}

#pragma mark NSCoding

#define kAddressKey  @"address"
#define kConfigKey   @"config"
#define kStateKey   @"state"

- (id)initWithCoder:(NSCoder *)decoder {
    int anAddress = [decoder decodeIntegerForKey:kAddressKey];
    NSString* configPath = [decoder decodeObjectForKey:kConfigKey];
    ANFixture* fixture = [[ANFixture alloc] initWithAddress:anAddress];
    fixture.config = [[NSMutableDictionary alloc] initWithDictionary:[decoder decodeObjectForKey:kStateKey]];
    [fixture loadFixtureDefinition:configPath];
    
    for(NSString* key in [fixture.config allKeys]){
        if([key isEqualToString:@"color"]){
            [fixture setColor:fixture.config[key]];
        }
        else if([key isEqualToString:@"strobe"]){
            [fixture setStrobe:[fixture.config[key] intValue]];
        }
        else if([key isEqualToString:@"intensity"]){
            [fixture setIntensity:[fixture.config[key] intValue]];
        }
    }
    
    return fixture;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.address forKey:kAddressKey];
    [encoder encodeObject:self.fixtureConfigPath forKey:kConfigKey];
    [encoder encodeObject:self.config forKey:kStateKey];
}

@end

@implementation RGBControl
@synthesize fixture;
@synthesize r_value;
@synthesize g_value;
@synthesize b_value;
@synthesize r_offset;
@synthesize g_offset;
@synthesize b_offset;

-(RGBControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef {
	self = [super init];
    self.r_offset = [fixturedef[@"rgb_offsets"][@"red"] integerValue];
    self.g_offset = [fixturedef[@"rgb_offsets"][@"green"] integerValue];
    self.b_offset = [fixturedef[@"rgb_offsets"][@"blue"] integerValue];
    self.r_value = 0;
    self.g_value = 0;
    self.b_value = 0;
    return self;
}

-(NSArray*) getChannels {
	return @[
          @[@(self.r_offset), @(self.r_value)],
          @[@(self.g_offset), @(self.g_value)],
          @[@(self.b_offset), @(self.b_value)]
          ];
}

-(void) setColor:(NSString*) hexcolor {
    NSArray* result = hex2RGBArray(hexcolor);
    self.r_value = [result[0] intValue];
    self.g_value = [result[1] intValue];
    self.b_value = [result[2] intValue];
    self.fixture.config[@"color"] = hexcolor;
}

-(NSString*) getColor {
	return RGB2Hex(self.r_value, self.g_value, self.b_value);
}

-(void) setUIColor:(UIColor*) color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    self.r_value = roundf(255 * red);
    self.g_value = roundf(255 * green);
    self.b_value = roundf(255 * blue);
    
    self.fixture.config[@"color"] = [self getColor];
}

-(UIColor*) getUIColor {
    return [UIColor colorWithRed:(self.r_value/255.0) green:(self.g_value/255.0) blue:(self.b_value/255.0) alpha:1.0];
}


@end

@implementation StrobeControl
@synthesize fixture;
@synthesize offset;
@synthesize value;

-(StrobeControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef {
	self = [super init];
    self.offset = [fixturedef[@"strobe_offset"] integerValue];
    self.value = 0;
    return self;
}

-(NSArray*) getChannels {
	return @[
          @[@(self.offset), @(self.value)]
          ];
}

-(void) setStrobe:(int) level {
	self.value = level;
    self.fixture.config[@"strobe"] = @(level);
}

-(int) getStrobe {
	return self.value;
}

@end

@implementation IntensityControl
@synthesize fixture;
@synthesize offset;
@synthesize offset_fine;
@synthesize value;

-(IntensityControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef {
	self = [super init];
    self.offset = [fixturedef[@"intensity_offset"] integerValue];
    self.value = 0;
    return self;
}

-(NSArray*) getChannels {
	return @[
          @[@(self.offset), @(self.value)]
          ];
}

-(void) setIntensity:(int) level {
	self.value = level;
    self.fixture.config[@"intensity"] = @(level);
}

-(int) getIntensity {
	return self.value;
}

@end

@implementation ProgramControl
@synthesize fixture;
@synthesize offset;
@synthesize speedOffset;
@synthesize value;
@synthesize speedValue;
@synthesize macroType;
@synthesize macros;

-(ProgramControl*) initWithFixture:(ANFixture*)aFixture andDefinition:(NSDictionary*) fixturedef andChannel: (NSDictionary*) channel {
	self = [super init];
    
    self.offset = [channel[@"offset"] integerValue];
    self.macroType = channel[@"type"];
    if([self.macroType isEqualToString:@"program"]){
        id o = [channel objectForKey:@"speed_offset"];
        if(o == nil){
            self.speedOffset = [[fixturedef objectForKey:@"strobe_offset"] intValue];
        }
        else{
            self.speedOffset = [o intValue];
        }
    }
    
    
    for(NSString* label in channel[@"macros"]){
        id conf = channel[@"macros"][label];
        if([conf isKindOfClass:[NSNumber class]]){
            [self setMacro:label withValue:[conf integerValue]];
        }
        else{
            [self setMacro:label withValue:[conf[@"value"] integerValue] andSpeed:[conf[@"speed"] integerValue]];
        }
    }
    
    return self;
}

-(NSArray*) getChannels {
    if(self.speedOffset){
        return @[
                 @[@(self.offset), @(self.value)],
                 @[@(self.speedOffset), @(self.speedValue)]
                 ];
    }
    else{
        return @[
              @[@(self.offset), @(self.value)],
              ];
    }
}

-(void) setMacro: (NSString*) macroName withValue: (int) aValue andSpeed: (int) aSpeed {
    self.macros[macroName] = @[@(aValue), @(aSpeed)];
}

-(void) setMacro: (NSString*) macroName withValue: (int) aValue {
    self.macros[macroName] = @[@(aValue), [NSNull null]];
}

@end
