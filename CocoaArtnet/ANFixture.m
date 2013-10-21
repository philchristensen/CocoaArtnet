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
@synthesize channels;
@synthesize values;
@synthesize config;
@synthesize definition;
@synthesize path;

-(ANFixture*) initWithAddress: (int) anAddress {
    self = [super init];
    self.address = anAddress;
    self.config = [[NSMutableDictionary alloc] init];
    self.channels = [[NSMutableArray alloc] init];
    return self;
}

+(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath {
    ANFixture* fixture = [[ANFixture alloc] initWithAddress:anAddress];
    [fixture loadFixtureDefinition:aPath];
    return fixture;
}

+(NSArray*) getAvailableFixtureDefinitions {
    NSFileManager* mgr = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* userFixturedefDirectory = [documentsDirectory stringByAppendingPathComponent:@"FixtureDefinitions"];
    
    NSDirectoryEnumerator *userEnum = [mgr enumeratorAtPath:userFixturedefDirectory];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSString* userFixtureFile;
    while(userFixtureFile = [userEnum nextObject]){
        if([userEnum level] > 1){
            NSString* savedPath = [userFixturedefDirectory stringByAppendingPathComponent:userFixtureFile];
            [result addObject:savedPath];
            NSLog(@"Found fixturedef: %@", savedPath);
        }
    }
    
    for(NSString* subdir in [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"FixtureDefinitions"]){
        NSDirectoryEnumerator* dirEnum = [mgr enumeratorAtPath:subdir];
        NSString* baseDirectory = [[subdir pathComponents] lastObject];
        NSString* fixtureFile;
        while(fixtureFile = [dirEnum nextObject]){
            NSString* savedPath = [NSString stringWithFormat:@"%@/FixtureDefinitions/%@/%@", documentsDirectory, baseDirectory, fixtureFile];
            if(! [mgr fileExistsAtPath:savedPath]){
                [result addObject:[subdir stringByAppendingPathComponent:fixtureFile]];
                NSLog(@"Found preset fixturedef: %@", [subdir stringByAppendingPathComponent:fixtureFile]);
            }
        }
    }
    
    return result;
}

-(void) loadFixtureDefinition: (NSString*) aPath {
    @autoreleasepool {
        self.path = aPath;
        
        NSString* realPath;
        if([aPath hasPrefix:@"/"]){
            realPath = aPath;
        }
        else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];

            NSString* resourcePath = [NSString stringWithFormat:@"FixtureDefinitions/%@", aPath];
            NSString* savedPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.yaml", resourcePath]];
            if([[NSFileManager defaultManager] fileExistsAtPath:savedPath]){
                realPath = savedPath;
            }
            else {
                realPath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"yaml"];
            }
        }
        
        NSString* yaml = [[NSString alloc] initWithContentsOfFile:realPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
        
        NSDictionary* fixturedef = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
        [self installFixtureDefinition:fixturedef];
    }
}

- (NSString*) makeSlug:(NSString*)value {
    NSRegularExpression *forbidden = [NSRegularExpression regularExpressionWithPattern:@"[^\\w\\s-]"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSRegularExpression *whitespace = [NSRegularExpression regularExpressionWithPattern:@"[-\\s]+"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
    NSString* slug = [forbidden stringByReplacingMatchesInString:value
                                                             options:0
                                                               range:NSMakeRange(0, value.length)
                                                        withTemplate:@""];
    return [[whitespace stringByReplacingMatchesInString:slug
                                                    options:0
                                                      range:NSMakeRange(0, slug.length)
                                               withTemplate:@"-"] lowercaseString];
}

-(BOOL) saveFixtureDefinition {
    @autoreleasepool {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* nameSlug = [self makeSlug:self.definition[@"name"]];
        NSString* manufacturerSlug = [self makeSlug:self.definition[@"manufacturer"]];
        NSString* newPath = [NSString stringWithFormat:@"%@/%@.yaml", manufacturerSlug, nameSlug];
        NSString* basePath = [NSString stringWithFormat:@"FixtureDefinitions/%@", self.path];
        NSString* dataPath = [documentsDirectory stringByAppendingPathComponent:basePath];

        NSFileManager* mgr = [NSFileManager defaultManager];
        
        // If the fixture has a path, the path has changed, and the old path was a user-created file, remove it
        if(self.path && ![self.path isEqualToString:newPath] && [mgr fileExistsAtPath:dataPath]){
            NSError *error;
            BOOL success = [mgr removeItemAtPath:dataPath error:&error];
            
            if (!success) {
                NSLog(@"Error removing old fixturedef: %@", [error localizedDescription]);
                return success;
            }
            
            // update the paths
            self.path = newPath;
        }
        else if(! self.path){
            self.path = newPath;
        }
        basePath = [NSString stringWithFormat:@"FixtureDefinitions/%@", self.path];
        dataPath = [documentsDirectory stringByAppendingPathComponent:basePath];
        
        NSError *error;
        BOOL success = [mgr createDirectoryAtPath:[dataPath stringByDeletingLastPathComponent]
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        
        if (!success) {
            NSLog(@"Error creating fixturedef directory: %@", [error localizedDescription]);
            return success;
        }
        
        NSLog(@"Data path: %@", dataPath);
        NSMutableData *data = [[NSMutableData alloc] init];
        YACYAMLKeyedArchiver *archiver = [[YACYAMLKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self.definition];
        [archiver finishEncoding];
        [data writeToFile:dataPath atomically:YES];
        
        return success;
    }
}

-(void) installFixtureDefinition:(NSDictionary*) fixturedef {
    @autoreleasepool {
        self.definition = [[NSMutableDictionary alloc] initWithDictionary:fixturedef];
        self.channels = [[NSMutableArray alloc] initWithArray:fixturedef[@"channels"]];
        self.values = [[NSMutableArray alloc] initWithCapacity:[fixturedef[@"channels"] count]];
        for(int i = 0; i < [fixturedef[@"channels"] count]; i++){
            self.values[i] = @-1;
        }
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
        for(int j = 0; j < [self.values count]; j++){
            frame[j + self.address - 1] = self.values[j];
        }
        return frame;
    }
}

#pragma mark NSCoding

#define kAddressKey  @"address"
#define kConfigKey   @"config"
#define kStateKey   @"state"

-(id) initWithCoder:(NSCoder *)decoder {
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

-(void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.address forKey:kAddressKey];
    [encoder encodeObject:self.path forKey:kConfigKey];
    [encoder encodeObject:self.config forKey:kStateKey];
}

-(int) getValueOfType:(NSString*)type {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:type]){
            return [self.values[i] intValue];
        }
    }
    return -1;
}

-(int) getValueOfType:(NSString*)type andSubtype:(NSString*)subtype {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:type] &&
            [self.channels[i][@"subtype"] isEqualToString:subtype]){
            return [self.values[i] intValue];
        }
    }
    return -1;
}

-(void) setValue:(int)value ofType:(NSString*)type {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:type]){
            self.values[i] = @(value);
            return;
        }
    }
}

-(void) setValue:(int)value ofType:(NSString*)type andSubtype:(NSString*)subtype {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:type] &&
            [self.channels[i][@"subtype"] isEqualToString:subtype]){
            self.values[i] = @(value);
            return;
        }
    }
}

-(BOOL) hasColor {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:@"rgb"]){
            return YES;
        }
    }
    return NO;
}

-(void) setColor:(NSString*) hexcolor {
    NSArray* result = hex2RGBArray(hexcolor);
    [self setValue:[result[0] intValue] ofType:@"rgb" andSubtype:@"red"];
    [self setValue:[result[1] intValue] ofType:@"rgb" andSubtype:@"green"];
    [self setValue:[result[2] intValue] ofType:@"rgb" andSubtype:@"blue"];
}

-(NSString*) getColor {
	return RGB2Hex(
       [self getValueOfType:@"rgb" andSubtype:@"red"],
       [self getValueOfType:@"rgb" andSubtype:@"green"],
       [self getValueOfType:@"rgb" andSubtype:@"blue"]
    );
}

-(void) setUIColor:(UIColor*) color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self setValue:roundf(255 * red) ofType:@"rgb" andSubtype:@"red"];
    [self setValue:roundf(255 * green) ofType:@"rgb" andSubtype:@"green"];
    [self setValue:roundf(255 * blue) ofType:@"rgb" andSubtype:@"blue"];
    
    self.config[@"color"] = [self getColor];
}

-(UIColor*) getUIColor {
    return [UIColor colorWithRed:([self getValueOfType:@"rgb" andSubtype:@"red"]/255.0)
                           green:([self getValueOfType:@"rgb" andSubtype:@"green"]/255.0)
                            blue:([self getValueOfType:@"rgb" andSubtype:@"blue"]/255.0)
                           alpha:1.0];
}


-(BOOL) hasStrobe {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:@"strobe"]){
            return YES;
        }
    }
    return NO;
}

-(void) setStrobe:(int) level {
    [self setValue:level ofType:@"strobe"];
    self.config[@"strobe"] = @(level);
}

-(int) getStrobe {
	return [self getValueOfType:@"strobe"];
}

-(BOOL) hasIntensity {
    for(int i = 0; i < [self.channels count]; i++){
        if([self.channels[i][@"type"] isEqualToString:@"intensity"]){
            return YES;
        }
    }
    return NO;
}

-(void) setIntensity:(int) level {
    [self setValue:level ofType:@"intensity"];
    self.config[@"intensity"] = @(level);
}

-(int) getIntensity {
	return [self getValueOfType:@"intensity"];
}

@end
