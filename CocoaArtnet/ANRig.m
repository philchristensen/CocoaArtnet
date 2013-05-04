//
//  ANRig.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/1/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANRig.h"
#import <YACYAML/YACYAML.h>

@implementation ANRig

@synthesize name;
@synthesize fixtures;

- (id)initWithName:(NSString*)aName {
    self = [super init];
    self.name = aName;
    self.fixtures = [[NSMutableDictionary alloc] init];
    return self;
}

+(ANRig*)loadRigDefinition: (NSString*) rigName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"RigDefinitions/%@", rigName]
                                                           ofType:@"yaml"];
    NSString* yaml = [[NSString alloc] initWithContentsOfFile:bundlePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    return [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
}

#pragma mark NSCoding

#define kNameKey       @"name"
#define kFixturesKey   @"fixtures"

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.fixtures = [decoder decodeObjectForKey:kFixturesKey];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:kNameKey];
    [encoder encodeObject:self.fixtures forKey:kFixturesKey];
}

@end
