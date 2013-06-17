//
//  ANFixtureTests.m
//  CocoaArtnet
//
//  Created by Phil Christensen on 6/16/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "ANFixtureTests.h"
#import "ANFixture.h"

@implementation ANFixtureTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_hex2RGBArray {
    NSArray *result, *expected;
    
    result = hex2RGBArray(@"ffffff");
    expected = @[@(255), @(255), @(255)];
    STAssertEqualObjects(result, expected, @"Did not parse white properly.");
    
    result = hex2RGBArray(@"ff0000");
    expected = @[@(255), @(0), @(0)];
    STAssertEqualObjects(result, expected, @"Did not parse red properly.");
    
    result = hex2RGBArray(@"00ff00");
    expected = @[@(0), @(255), @(0)];
    STAssertEqualObjects(result, expected, @"Did not parse green properly.");
    
    result = hex2RGBArray(@"0000ff");
    expected = @[@(0), @(0), @(255)];
    STAssertEqualObjects(result, expected, @"Did not parse blue properly.");
}

- (void) test_hex2UIColor {
    UIColor *result, *expected;
    
    result = hex2UIColor(@"ff0000", 1.0);
    expected = [UIColor redColor];
    STAssertEqualObjects(result, expected, @"Did not parse red properly.");
    
    result = hex2UIColor(@"00ff00", 1.0);
    expected = [UIColor greenColor];
    STAssertEqualObjects(result, expected, @"Did not parse green properly.");
    
    result = hex2UIColor(@"0000ff", 1.0);
    expected = [UIColor blueColor];
    STAssertEqualObjects(result, expected, @"Did not parse blue properly.");
}


@end
