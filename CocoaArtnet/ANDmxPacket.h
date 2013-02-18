//
//  ANDmxPacket.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANPacket.h"

@interface ANDmxPacket : ANPacket{
    NSArray* frame;
}

-(ANDmxPacket*) initWithFrame: (NSArray*) f;

-(NSData*) encode;

@end
