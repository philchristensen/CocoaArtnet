//
//  ArtNetPacket.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 4/27/14.
//  Copyright (c) 2014 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtNetPacket : NSObject

@property NSUInteger opcode;
@property NSArray* schema;

+(ArtNetPacket*) decode:(NSData*)data from:(NSString*)address;

-(void) initSchema;
-(NSData*) encode;

@end

@interface PollPacket : ArtNetPacket

@end

@interface PollReplyPacket : ArtNetPacket

@end

@interface DmxPacket : ArtNetPacket

@end
