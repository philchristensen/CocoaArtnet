//
//  ANController.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANController : NSObject {
    NSString* interfaceAddress;
    float beatsPerMinute;
    int barLength;
    float framesPerSecond;
    float framesPerBeat;
    
    NSArray* latestFrame;
    NSArray* generators;
    
    int beatClock;
    int secondFrameClock;
    int beatFrameClock;
    
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps;
-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats;
-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm;

-(NSDictionary*) getClock;
-(void) iterate;
-(void) addGenerator: (SEL) name onTarget: (id) target;
-(void) sendFrame: (NSArray*) frame;

@end
