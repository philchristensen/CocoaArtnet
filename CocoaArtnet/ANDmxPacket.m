//
//  ANDmxPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <inttypes.h>

#import "CocoaArtnet.h"
#import "ANDmxPacket.h"

@implementation ANDmxPacket

-(ANPacket*) initWithFrame: (NSArray*) f {
    self = [super initWithUniverse:0 physical:0];
    if([f count] != 512){
        @throw [NSException
                exceptionWithName:@"InvalidDMXException"
                reason:@"DMX frames must have 512 values."
                userInfo:nil];
    }
    opcode = @"\x00P";
    frame = f;
    return self;
}

-(NSData*) encode {
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:530];

//    char prefix[] = "Art-Net\x00\x00P\x00\x0e\x00\x00\x00\x00\x02\x00";
//    [data appendBytes:prefix length:18];    
    [data appendBytes:[AN_PACKET_HEADER UTF8String] length:[AN_PACKET_HEADER length]];
    [data appendBytes:[opcode UTF8String] length:[opcode length]];
    [data appendBytes:[AN_PROTO_VERSION UTF8String] length:[AN_PROTO_VERSION length]];
    uint8_t s[] = {sequence & 0x00FF, (sequence & 0xFF00) >> 8};
    [data appendBytes:s length:2];
    uint8_t p[] = {physical};
    [data appendBytes:p length:1];
    uint8_t u[] = {universe};
    [data appendBytes:u length:1];
    [data appendBytes:[AN_LEN512 UTF8String] length:[AN_LEN512 length]];
    
    char channels[512];
    for (int i = 0; i < 512; ++i) {
        channels[i] = [[frame objectAtIndex:i] charValue];
    }
    [data appendBytes:channels length:512];
    
    return data;
}

@end
