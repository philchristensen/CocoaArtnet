//
//  ANController.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANController.h"

@implementation ANController

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:fps];
    return self;
}


-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats {
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:40.0];
    return self;
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm {
    [self setupWithAddress:address andBPM:bpm andBarLength:4 andFPS:40.0];
    return self;
}

-(void) setupWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    interfaceAddress = address;
    beatsPerMinute = bpm;
    barLength = beats;
    framesPerSecond = fps;
    framesPerBeat = (fps * 60) / bpm;
}

-(NSDictionary*) getClock{
    return @{
         @"beatClock": @(beatClock),
         @"barLength": @(barLength),
         @"secondFrameClock": @(secondFrameClock),
         @"framesPerSecond": @(framesPerSecond),
         @"beatFrameClock": @(beatFrameClock),
         @"framesPerBeat": @(framesPerBeat),
         @"latestFrame": latestFrame,
         @"running": @YES,
    };
}

-(void) iterate {
    secondFrameClock = secondFrameClock < framesPerSecond - 1 ? secondFrameClock + 1 : 0;
    beatFrameClock = beatFrameClock < framesPerBeat - 1 ? beatFrameClock + 1 : 0;
    if(beatFrameClock < framesPerBeat - 1){
        beatFrameClock += 1;
    }
    else{
        beatFrameClock = 0;
        beatClock = beatClock < barLength -1 ? beatClock + 1 : 0;
    }
}

-(void) addGenerator: (SEL) name onTarget: (id) target {

}

-(void) sendFrame: (NSArray*) frame {

}


@end
