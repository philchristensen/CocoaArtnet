//
//  ANCue.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/19/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANCue.h"

@implementation ANCue

@synthesize name;
@synthesize config;

#pragma mark NSCoding

#define kNameKey  @"name"
#define kConfigKey   @"state"

- (id)initWithCoder:(NSCoder *)decoder {
    ANCue* cue = [[ANCue alloc] init];
    cue.name = [decoder decodeObjectForKey:kNameKey];
    cue.config = [[NSMutableDictionary alloc] initWithDictionary:[decoder decodeObjectForKey:kConfigKey]];
    return cue;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:kNameKey];
    [encoder encodeObject:self.config forKey:kConfigKey];
}

@end
