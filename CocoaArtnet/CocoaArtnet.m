//
//  CocoaArtnet.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>

#import "CocoaArtnet.h"

int const AN_PORT = 6454;

NSString* const AN_PACKET_HEADER = @"Art-Net\x00";
NSString* const AN_PROTO_VERSION = @"\x00\x0e";
NSString* const AN_OPCODE_DMX = @"\x00P";
NSString* const AN_LEN512 = @"\x02\x00";

@implementation CocoaArtnet

@end
