//
//  ANController.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "CocoaArtnet.h"

@implementation ANController
@synthesize interfaceAddress;
@synthesize beatsPerMinute;
@synthesize barLength;
@synthesize framesPerSecond;
@synthesize framesPerBeat;
@synthesize latestFrame;
@synthesize generators;
@synthesize socket;
@synthesize thread;
@synthesize beatClock;
@synthesize secondFrameClock;
@synthesize beatFrameClock;
@synthesize running;

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:fps];
    self.latestFrame = [self createFrame];
    self.generators = [[NSMutableArray alloc] init];
    return self;
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:beats andFPS:40.0];
    self.latestFrame = [self createFrame];
    self.generators = [[NSMutableArray alloc] init];
    return self;
}

-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm {
    self = [super init];
    [self setupWithAddress:address andBPM:bpm andBarLength:4 andFPS:40.0];
    self.latestFrame = [self createFrame];
    self.generators = [[NSMutableArray alloc] init];
    return self;
}

-(void) setupWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps {
    self.interfaceAddress = address;
    self.beatsPerMinute = bpm;
    self.barLength = beats;
    self.framesPerSecond = fps;
    self.framesPerBeat = (fps * 60) / bpm;
    
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket bindToPort:6454 error:nil ];
    [self.socket enableBroadcast:YES error:nil];
    
}

-(NSMutableArray*) createFrame {
    NSMutableArray* frame = [[NSMutableArray alloc] initWithCapacity:512];
    for(int i = 0; i < 512; i++){
        frame[i] = @-1;
    }
    return frame;
}

-(void) start {
    self.thread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(run)
                                            object:nil];
    [self.thread start];
}

-(void) stop {
    self.running = NO;
}

-(void) run {
    self.running = YES;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    while(self.running){
        NSTimeInterval drift = now - [[NSDate date] timeIntervalSince1970];
        [self iterate];
        [self send:self.latestFrame];
        
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSince1970] - now;
        NSTimeInterval excess = (1.0 / self.framesPerSecond) - elapsed;
        if(excess > 0){
            if(self.running){
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
    while ([self.thread isFinished] == NO) {
        usleep(1000);
    }
}

-(void) iterate {
    NSMutableArray* mergedFrame = [self createFrame];
    for(NSArray* pair in self.generators){
        @try{
            NSMutableArray* layerFrame = [pair[0] performSelector:NSSelectorFromString(pair[1]) withObject:self];
            if(layerFrame == nil){
                mergedFrame = self.latestFrame;
            }
            else{
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
        }
        @catch(NSException *e){
            NSLog(@"Error %@", e);
        }
    }
    self.latestFrame = mergedFrame;
    
    self.secondFrameClock = self.secondFrameClock < self.framesPerSecond - 1 ? self.secondFrameClock + 1 : 0;
    self.beatFrameClock = self.beatFrameClock < self.framesPerBeat - 1 ? self.beatFrameClock + 1 : 0;
    if(self.beatFrameClock < self.framesPerBeat - 1){
        self.beatFrameClock += 1;
    }
    else{
        self.beatFrameClock = 0;
        self.beatClock = self.beatClock < self.barLength - 1 ? self.beatClock + 1 : 0;
    }
}

-(void) add: (NSString*) selector onTarget: (id) target {
    [self.generators addObject:@[target, selector]];
}

-(void) send: (NSArray*) frame {
    ANDmxPacket* packet = [[ANDmxPacket alloc] initWithFrame:frame];
    NSData* data = [packet encode];
    
    [self.socket sendData:data toHost:self.interfaceAddress port:AN_PORT withTimeout:-1 tag:0];
}

@end
