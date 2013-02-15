//
//  ANPacket.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANPacket.h"

@implementation ANPacket

-(ANPacket*) initWithSource: (NSString*) s physical: (int) p universe: (int) u {
    self = [super init];
    [self setSource:s physical:p universe:u];
    return self;
}

-(void) setSource:(NSString*) s physical: (int) p universe: (int) u {
    source = s;
    physical = p;
    universe = u;
}


@end
