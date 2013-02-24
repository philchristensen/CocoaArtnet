//
//  ANController.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnet.h"

#import "GCDAsyncUdpSocket.h"

@implementation ANController

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:fps];
    latestFrame = nil;
    generators = [[NSMutableArray alloc] init];
    return self;
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:40.0];
    latestFrame = nil;
    generators = [[NSMutableArray alloc] init];
    return self;
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:4 andFPS:40.0];
    latestFrame = nil;
    generators = [[NSMutableArray alloc] init];
    return self;
}

-(void) setupWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    interfaceAddress = address;
    beatsPerMinute = bpm;
    barLength = beats;
    framesPerSecond = fps;
    framesPerBeat = (fps * 60) / bpm;
}

-(NSMutableArray*) createFrame {
    NSMutableArray* frame = [[NSMutableArray alloc] initWithCapacity:512];
    for(int i = 0; i < 512; i++){
        frame[i] = @-1;
    }
    return frame;
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
    thread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(run:)
                                                   object:nil];
    [thread start];
}

-(void) run: (id) arg {
    running = YES;
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

-(void) wait {
    while ([thread isFinished] == NO) {
        usleep(1000);
    }
}

-(void) iterate {
    NSMutableArray* mergedFrame = [self createFrame];
    for(NSArray* pair in generators){
        @try{
            NSMutableArray* layerFrame = [pair[0] performSelector:NSSelectorFromString(pair[1])];
            for(int i = 0; i < 512; i++){
                int value = -1;
                int layerValue = [layerFrame[i] intValue];
                if(layerValue == -1){
                    value = [mergedFrame[i] intValue];
                }
                else{
                    value = [layerFrame[i] intValue];
                }
                mergedFrame[i] = @(value);
            }
        }
        @catch(NSException *e){
            NSLog(@"Error %@", e);
        }
    }
    latestFrame = mergedFrame;
    
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

-(void) addGenerator: (NSString*) selector onTarget: (id) target {
    [generators addObject:@[target, selector]];
}

-(void) sendFrame: (NSArray*) frame {
    ANDmxPacket* packet = [[ANDmxPacket alloc] initWithFrame:frame];
    NSData* data = [packet encode];

    GCDAsyncUdpSocket* socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [socket bindToPort:6454 error:nil ];
    [socket enableBroadcast:YES error:nil];
    
    [socket sendData:data toHost:interfaceAddress port:AN_PORT withTimeout:-1 tag:0];
}

@end
