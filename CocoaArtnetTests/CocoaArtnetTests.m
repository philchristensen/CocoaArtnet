//
//  CocoaArtnetTests.m
//  CocoaArtnetTests
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnetTests.h"

#import <CoreFoundation/CoreFoundation.h>

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
    [ctl addGenerator:@"red" onTarget:self];
    [ctl start];
}

- (NSArray*) red {
    NSMutableArray* frame = [[NSMutableArray alloc] initWithCapacity:512];
    frame[420] = @255;
    frame[421] = @255;
    frame[422] = @255;
    frame[426] = @255;
    return frame;
}

@end
