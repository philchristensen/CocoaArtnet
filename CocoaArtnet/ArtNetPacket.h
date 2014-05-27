//
//  ArtNetPacket.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 4/27/14.
//  Copyright (c) 2014 Phil Christensen. All rights reserved.
//

#import "inttypes.h"

#import <Foundation/Foundation.h>

@interface ArtNetPacket : NSObject

@property NSUInteger opcode;
@property NSArray* schema;

+(ArtNetPacket*) decode:(NSData*)data from:(NSString*)address;
-(NSData*) encode;

@end

@interface PollPacket : ArtNetPacket

@end

@interface PollReplyPacket : ArtNetPacket

@end

@interface DmxPacket : ArtNetPacket

@end

// Using this to remind us which bytes need to be swapped.
typedef unsigned int uint16b_t;

typedef struct {
  char header[8];
  uint16_t opcode;
  uint16b_t protocol_version;
  uint8_t talktome;
  uint8_t priority;
} Poll;

typedef struct {
  char header[8];
  uint16_t opcode;
  uint8_t ip_address[4];
  uint16b_t port;
  uint16b_t version;
  uint8_t net_switch;
  uint8_t sub_switch;
  uint16b_t oem;
  uint8_t ubea_version;
  uint8_t status1;
  char esta_manufacturer[2];
  char short_name[18];
  char long_name[64];
  char node_report[64];
  uint16b_t num_ports;
  char port_types[4];
  char good_input[4];
  char good_output[4];
  uint8_t switch_in;
  uint8_t switch_out;
  uint8_t switch_video;
  uint8_t switch_macro;
  uint8_t switch_remote;
  uint8_t spare1;
  uint8_t spare2;
  uint8_t spare3;
  uint8_t style;
  uint8_t mac_address[6];
  uint8_t bind_ip[4];
  uint8_t bind_index;
  uint8_t status2;
//  bytes filler;
} PollReply;

typedef struct {
  char header[8];
  uint16_t opcode;
  uint16b_t protocol_version;
  uint8_t sequence;
  uint8_t physical;
  uint16b_t universe;
  uint16b_t length;
  char framedata[512];
} Dmx;