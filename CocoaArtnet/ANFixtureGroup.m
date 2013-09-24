//
//  ANFixtureGroup.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 3/16/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANFixtureGroup.h"
#import "ANFixture.h"

@implementation ANFixtureGroup

-(ANFixtureGroup*) initWithFixtures: (NSArray*) someFixtures {
    self = [super init];
    self.fixtures = [[NSMutableArray alloc] initWithArray:someFixtures];
    return self;
}

-(NSArray*) getFrame {
    NSMutableArray* frame = [[NSMutableArray alloc] init];
    for(int i = 0; i < 512; i++){
        frame[i] = @0;
    }
    for(ANFixture* fixture in self.fixtures){
        for(NSArray* channelSet in [fixture getState]){
            frame[[channelSet[0] integerValue] + fixture.address - 1] = channelSet[1];
        }
    }
    return frame;
}


-(void) forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    
    for (ANFixture* fixture in self.fixtures) {
        if([fixture respondsToSelector:aSelector]){
            [anInvocation invokeWithTarget:fixture];
            return;
        }
    }
    [super forwardInvocation:anInvocation];
}

-(NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if(signature) {
        return signature;
    }
    for (ANFixture* fixture in self.fixtures) {
        if([fixture respondsToSelector:aSelector]){
            return [[fixture class] instanceMethodSignatureForSelector:aSelector];
        }
    }
    return nil;
}

@end
