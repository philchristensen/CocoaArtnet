//
//  CocoaArtnetTests.m
//  CocoaArtnetTests
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnetTests.h"

#import <CoreFoundation/CoreFoundation.h>

#import "GCDAsyncUdpSocket.h"
#import "CocoaArtnet.h"

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
    NSMutableArray* frame = [NSMutableArray arrayWithCapacity:512];
    for(int i = 0; i < 512; i++){
        [frame insertObject:[NSNumber numberWithInt:255] atIndex:i];
    }
    
    ANDmxPacket* packet = [[ANDmxPacket alloc] initWithFrame:frame];
    NSData* data = [packet encode];
    
    GCDAsyncUdpSocket* socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [socket bindToPort:6454 error:nil ];
    [socket enableBroadcast:YES error:nil];
    
    NSString* dest = @"255.255.255.255"; //@"192.168.0.88";
    [socket sendData:data toHost:dest port:6454 withTimeout:-1 tag:0];
}

@end
