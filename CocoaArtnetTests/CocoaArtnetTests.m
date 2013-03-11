//
//  CocoaArtnetTests.m
//  CocoaArtnetTests
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnetTests.h"

#import <CoreFoundation/CoreFoundation.h>
#import <stdlib.h>

#import "CocoaArtnet.h"

@implementation CocoaArtnetTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    ANController* ctl = [[ANController alloc] initWithAddress:@"255.255.255.255" andBPM:120.0];
    [ctl add:@"fixturesWithController:" onTarget:self];
    [ctl start];
    [ctl stop];
    [ctl wait];
}

- (NSArray*) fixturesWithController: (ANController*) ctl {
    NSString* path = @"/Users/phil/Workspace/CocoaArtnet/FixtureDefinitions/chauvet/slimpar-64.yaml";
    ANFixture* fixture = [ANFixture createWithAddress:420 andFixturePath:path];

    [fixture setColor:@"#ff0000"];
    [fixture setIntensity:255];
    return [fixture getFrame];
}

- (NSMutableArray*) redWithController: (ANController*) ctl {
    NSMutableArray* frame = [ctl createFrame];
    NSArray* addresses = @[@419, @426, @433, @440];
    for(id num in addresses){
        frame[[num intValue]] = @255;
        frame[[num intValue] + 1] = @0;
        frame[[num intValue] + 2] = @0;
        frame[[num intValue] + 6] = @255;
    }
    return frame;
}

- (NSMutableArray*) randomWhiteWithController: (ANController*) ctl {
    NSMutableArray* frame = [ctl createFrame];
    NSArray* addresses = @[@419, @426, @433, @440];
    int num = [addresses[arc4random_uniform(4)] intValue];
    frame[num] = @255;
    frame[num + 1] = @255;
    frame[num + 2] = @255;
    frame[num + 6] = @255;
    return frame;
}

@end
