//
//  CocoaArtnetTests.m
//  CocoaArtnetTests
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnetTests.h"

#include <CoreFoundation/CoreFoundation.h>

#include "CocoaAsyncSocket/GCD/GCDAsyncUdpSocket.h"
#include "CocoaArtnet.h"

@implementation CocoaArtnetTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    GCDAsyncUdpSocket* socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    NSString* source = @"192.168.0.88";
//    NSMutableArray* frame = [NSMutableArray arrayWithCapacity:512];
//    
//    ANDmxPacket* packet = [[ANDmxPacket alloc] initWithSource:source andFrame:frame];
//    NSData* data = [packet encode];
    
    STFail(@"Unit tests are not implemented yet in CocoaArtnetTests");
}

@end
