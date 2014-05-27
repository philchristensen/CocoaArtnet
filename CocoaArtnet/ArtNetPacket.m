//
//  ArtNetPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 4/27/14.
//  Copyright (c) 2014 Phil Christensen. All rights reserved.
//

#import "ArtNetPacket.h"

@implementation ArtNetPacket

@synthesize opcode;
@synthesize schema;

+(ArtNetPacket*) decode:(NSData*)data from:(NSString*)address {
    ArtNetPacket* packet = [[ArtNetPacket alloc] init];

    // make a new Poll struct
    Poll pollData;
    [data getBytes:&pollData length:sizeof(pollData)];
    
    return packet;
}

-(ArtNetPacket*)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSData*) encode {
    PollReply pollReply;

    // make a NSData object
    NSData *data = [NSData dataWithBytes:&pollReply length:sizeof(pollReply)];

    return data;
}

@end

