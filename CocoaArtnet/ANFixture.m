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
    
    NSString* fixturedef = [[NSString alloc] initWithContentsOfFile:fixturePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    NSDictionary* result = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:fixturedef];
}

@end
