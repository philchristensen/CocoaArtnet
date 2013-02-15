//
//  ANDmxPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANDmxPacket.h"

@implementation ANDmxPacket

-(ANPacket*) initWithSource: (NSString*) s andFrame: (NSArray*) f {
    self = [super initWithSource:s physical:0 universe:0];

    if([f count] != 512){
        @throw [NSException
                exceptionWithName:@"InvalidDMXException"
                reason:@"DMX frames must have 512 values."
                userInfo:nil];
    }
    frame = f;
    return self;
}

-(NSData*) encode {
    NSMutableData* data = [NSMutableData dataWithLength:530];

    const char* prefix = "Art-Net\00\x00\x20\x00\x0e\x02\x00";
    NSRange prefixRange = {.location = 0, .length = 18};
    [data replaceBytesInRange:prefixRange withBytes:prefix];
    
    char channels[512];
    for (int i = 0; i < 512; ++i) {
        channels[i] = [[frame objectAtIndex:i] charValue];
    }
    NSRange channelsRange = {.location = 18, .length = 512};
    [data replaceBytesInRange:channelsRange withBytes:channels];
    
    return data;
}

@end
