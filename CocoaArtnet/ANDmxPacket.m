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
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:530];

    char prefix[] = "Art-Net\x00\x00P\x00\x0e\x00\x00\x00\x00\x02\x00";
    [data appendBytes:prefix length:18];
    
    char channels[512];
    for (int i = 0; i < 512; ++i) {
        channels[i] = [[frame objectAtIndex:i] charValue];
    }
    [data appendBytes:channels length:512];
    
    return data;
}

@end
