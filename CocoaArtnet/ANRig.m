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
@synthesize cues;

- (id)initWithName:(NSString*)aName {
    self = [super init];
    self.name = aName;
    self.fixtures = [[NSMutableDictionary alloc] init];
    return self;
}

+(ANRig*)loadRigDefinition: (NSString*) rigPath {
    @autoreleasepool {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* resourcePath = [NSString stringWithFormat:@"RigDefinitions/%@", rigPath];
        NSString* savedPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.yaml", resourcePath]];
        NSString* rigPath;
        if([[NSFileManager defaultManager] fileExistsAtPath:savedPath]){
            rigPath = savedPath;
        }
        else {
            rigPath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:@"yaml"];
        }
        NSString* yaml = [[NSString alloc] initWithContentsOfFile:rigPath
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
        ANRig* result = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
        result.rigPath = resourcePath;
        return result;
    }
}

- (BOOL) saveRigDefinition {
    @autoreleasepool {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/RigDefinitions", documentsDirectory]
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];

        if (!success) {
            NSLog(@"Error creating rig directory: %@", [error localizedDescription]);
            return success;
        }
        
        NSString* basePath = [NSString stringWithFormat:@"%@.yaml", self.rigPath];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:basePath];
        NSMutableData *data = [[NSMutableData alloc] init];
        YACYAMLKeyedArchiver *archiver = [[YACYAMLKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self];
        [archiver finishEncoding];
        [data writeToFile:dataPath atomically:YES];
        
        return success;
    }
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
#define kCuesKey       @"cues"

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.fixtures = [decoder decodeObjectForKey:kFixturesKey];
    self.cues = [[NSMutableArray alloc] initWithArray:[decoder decodeObjectForKey:kCuesKey]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:kNameKey];
    [encoder encodeObject:self.fixtures forKey:kFixturesKey];
    [encoder encodeObject:self.cues forKey:kCuesKey];
}

@end
