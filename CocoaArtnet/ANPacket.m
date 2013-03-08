//
//  ANPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnet.h"

@implementation ANPacket

-(ANPacket*) initWithUniverse: (uint8_t) u physical: (uint8_t) p {
    self = [super init];
    self.physical = p;
    self.universe = u;
    self.sequence = 0;
    return self;
}

@end
