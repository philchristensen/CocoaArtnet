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
    
    return packet;
}

-(ArtNetPacket*)init {
    self = [super init];
    if (self) {
        [self initSchema];
    }
    return self;
}

-(void) initSchema {
    self.schema = @[];
}

-(NSData*) encode {
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:1024];
    for(NSArray* spec in self.schema){
        NSString* name = spec[0];
        //NSString* fmt = spec[1];
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id value = [self performSelector:NSSelectorFromString(name)];
        #pragma clang diagnostic pop
        [data appendData:[value data]];
    }
    return data;
}

@end

@implementation PollPacket
-(void) initSchema {
    self.schema = @[
        @[@"header", @"bytes:8"],
        @[@"opcode", @"int:16"],
        @[@"protocol_version", @"uintbe:16"],
        @[@"talktome", @"int:8"],
        @[@"priority", @"int:8"]
    ];
}
@end

@implementation PollReplyPacket
-(void) initSchema {
    self.schema = @[
        @[@"header", @"bytes:8"],
        @[@"opcode", @"int:16"],
        @[@"ip_address", @"bytes:4"],
        @[@"port", @"int:16"],
        @[@"version", @"uintbe:16"],
        @[@"net_switch", @"int:8"],
        @[@"sub_switch", @"int:8"],
        @[@"oem", @"uintbe:16"],
        @[@"ubea_version", @"int:8"],
        @[@"status1", @"int:8"],
        @[@"esta_manufacturer", @"bytes:2"],
        @[@"short_name", @"bytes:18"],
        @[@"long_name", @"bytes:64"],
        @[@"node_report", @"bytes:64"],
        @[@"num_ports", @"uintbe:16"],
        @[@"port_types", @"bytes:4"],
        @[@"good_input", @"bytes:4"],
        @[@"good_output", @"bytes:4"],
        @[@"switch_in", @"int:8"],
        @[@"switch_out", @"int:8"],
        @[@"switch_video", @"int:8"],
        @[@"switch_macro", @"int:8"],
        @[@"switch_remote", @"int:8"],
        @[@"spare1", @"int:8"],
        @[@"spare2", @"int:8"],
        @[@"spare3", @"int:8"],
        @[@"style", @"int:8"],
        @[@"mac_address", @"uintle:48"],
        @[@"bind_ip", @"bytes:4"],
        @[@"bind_index", @"int:8"],
        @[@"status2", @"int:8"],
        @[@"filler", @"bytes"]
    ];
}
@end

@implementation DmxPacket
-(void) initSchema {
    self.schema = @[
        @[@"header", @"bytes:8"],
        @[@"opcode", @"int:16"],
        @[@"protocol_version", @"uintbe:16"],
        @[@"sequence", @"int:8"],
        @[@"physical", @"int:8"],
        @[@"universe", @"uintbe:16"],
        @[@"length", @"uintbe:16"],
        @[@"framedata", @"bytes:512"]
    ];
}
@end
