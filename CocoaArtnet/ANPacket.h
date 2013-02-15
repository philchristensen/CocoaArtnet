//
//  ANPacket.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPacket : NSObject {
    int opcode;
    int sequence;
    int physical;
    int universe;
    NSString* source;
}

-(ANPacket*) initWithSource: (NSString*) s physical: (int) p universe: (int) u;

@end
