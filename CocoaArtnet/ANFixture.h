//
//  ANFixture.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/25/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANFixture : NSObject{
    int address;
    NSMutableDictionary* controls;
}

-(ANFixture*) initWithAddress: (int) anAddress;

+(ANFixture*) createWithAddress: (int) anAddress andFixturePath: (NSString*) aPath;

-(void) loadFixtureDefinition: (NSString*) aPath;

@end
