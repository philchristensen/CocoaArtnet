//
//  ANDmxPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <inttypes.h>

#import "CocoaArtnet.h"

@implementation ANDmxPacket
@synthesize frame;

-(ANPacket*) initWithFrame: (NSArray*) aFrame {
    self = [super initWithUniverse:0 physical:0];
    if([aFrame count] != 512){
        @throw [NSException
                exceptionWithName:@"InvalidDMXException"
                reason:@"DMX frames must have 512 values."
                userInfo:nil];
    }
    self.opcode = @"\x00P";
    self.frame = aFrame;
    return self;
}

-(NSData*) encode {
    @autoreleasepool {
        NSMutableData* data = [[NSMutableData alloc] initWithCapacity:530];

        // char prefix[] = "Art-Net\x00\x00P\x00\x0e\x00\x00\x00\x00\x02\x00";
        // [data appendBytes:prefix length:18];
        [data appendBytes:[AN_PACKET_HEADER UTF8String] length:[AN_PACKET_HEADER length]];
        [data appendBytes:[self.opcode UTF8String] length:[self.opcode length]];
        [data appendBytes:[AN_PROTO_VERSION UTF8String] length:[AN_PROTO_VERSION length]];
        uint8_t s[] = {self.sequence & 0x00FF, (self.sequence & 0xFF00) >> 8, self.physical, self.universe};
        [data appendBytes:s length:4];
        [data appendBytes:[AN_LEN512 UTF8String] length:[AN_LEN512 length]];
        
        char channels[512];
        for (int i = 0; i < 512; ++i) {
            NSNumber* value = [self.frame objectAtIndex:i];
            if([value intValue] == -1){
                channels[i] = '\x00';
            }
            else{
                channels[i] = [value charValue];
            }
        }
        [data appendBytes:channels length:512];
        
        return data;
    }
}

@end
