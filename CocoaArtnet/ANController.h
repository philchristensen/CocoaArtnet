//
//  ANController.h
//  CocoaArtnet
//
//  Created by Phil Christensen on 2/14/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

@interface ANController : NSObject
	@property NSString* interfaceAddress;
	@property float beatsPerMinute;
	@property int barLength;
	@property float framesPerSecond;
	@property float framesPerBeat;

    @property GCDAsyncUdpSocket* socket;
	@property NSMutableArray* latestFrame;
	@property NSMutableArray* generators;
	@property NSThread* thread;

	@property int beatClock;
	@property int secondFrameClock;
	@property int beatFrameClock;
    @property BOOL running;
    @property BOOL paused;

	-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats andFPS: (float) fps;
	-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm andBarLength:(int) beats;
	-(ANController*) initWithAddress: (NSString*) address andBPM:(float) bpm;

	-(NSMutableArray*) createFrame;
	-(void) start;
	-(void) run;
	-(void) wait;
    -(void) stop;
    -(void) pause;
    -(void) resume;
	-(void) iterate;
	-(void) add: (NSString*) selector onTarget: (id) target;
	-(void) send: (NSArray*) frame;
@end
