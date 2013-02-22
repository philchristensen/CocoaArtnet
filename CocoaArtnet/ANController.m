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

-(void) start {
    running = YES;
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(run:)
                                                   object:nil];
    [myThread start];
}

-(void) run: (id) arg {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    while(running){
        NSTimeInterval drift = now - [[NSDate date] timeIntervalSince1970];
        [self iterate];
        [self sendFrame:latestFrame];
        
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSince1970] - now;
        NSTimeInterval excess = (1.0 / framesPerSecond) - elapsed;
        if(excess > 0){
            if(running){
                [NSThread sleepForTimeInterval:(excess - drift)];
            }
        }
        else{
            NSLog(@"Frame rate loss; generators took too long");
        }
        now = [[NSDate date] timeIntervalSince1970];
    }
}

-(void) iterate {
    
    
    secondFrameClock = secondFrameClock < framesPerSecond - 1 ? secondFrameClock + 1 : 0;
    beatFrameClock = beatFrameClock < framesPerBeat - 1 ? beatFrameClock + 1 : 0;
    if(beatFrameClock < framesPerBeat - 1){
        beatFrameClock += 1;
    }
    else{
        beatFrameClock = 0;
        beatClock = beatClock < barLength - 1 ? beatClock + 1 : 0;
    }
}

// NSSelectorFromString(@"methodName");
-(void) addGenerator: (NSString*) selector onTarget: (id) target {
    // [target performSelector:NSSelectorFromString(@"methodName")];
    [generators addObject:@[target, selector]];
}

-(void) sendFrame: (NSArray*) frame {

}

@end
