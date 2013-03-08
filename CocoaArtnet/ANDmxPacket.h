//
//  ANDmxPacket.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnet.h"

@interface ANDmxPacket : ANPacket
    @property NSArray* frame;

    -(ANDmxPacket*) initWithFrame: (NSArray*) aFrame;
    -(NSData*) encode;
@end
