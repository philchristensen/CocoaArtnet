//
//  ANRig.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 5/1/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANRig.h"
#import "ANFixture.h"
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

-(NSArray*) getState {
    return @[];
}

-(NSArray*) getFrame {
    @autoreleasepool {
        NSMutableArray* mergedFrame = [[NSMutableArray alloc] initWithCapacity:512];
        for(int i = 0; i < 512; i++){
            mergedFrame[i] = @-1;
        }
        for (NSString* fixtureName in [self.fixtures allKeys]) {
            ANFixture* fixture = self.fixtures[fixtureName];
            
            NSArray* fixtureFrame = [fixture getFrame];
            @try{
                for(int i = 0; i < 512; i++){
                    int value = -1;
                    int layerValue = [fixtureFrame[i] intValue];
                    if(layerValue == -1){
                        value = [mergedFrame[i] intValue];
                    }
                    else{
                        value = [fixtureFrame[i] intValue];
                    }
                    mergedFrame[i] = @(value);
                }
            }
            @catch(NSException *e){
                NSLog(@"Error %@", e);
            }
        }
        return mergedFrame;
    }
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
