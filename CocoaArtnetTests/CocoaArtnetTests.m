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
    ctl = [[ANController alloc] initWithAddress:@"255.255.255.255" andBPM:120.0];
    [ctl addGenerator:@"red" onTarget:self];
    // this works
    [ctl run:nil];
//    // this doesn't
//    [ctl start];
}

- (NSMutableArray*) red {
    NSMutableArray* frame = [ctl createFrame];
    frame[419] = @255;
    frame[420] = @0;
    frame[421] = @0;
    frame[425] = @255;
    return frame;
}

@end
