//
//  ios_reaktorTests.m
//  ios-reaktorTests
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import "ios_reaktorTests.h"

@implementation ios_reaktorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    r = [[reaktor alloc] initWithDelegate:self andMail:@"test@test.de" andPassword:@"test"];
    [NSThread sleepForTimeInterval:20.0f];
    NSLog(@"end");
}

- (void) loggedIn:(BOOL)success {
    if (success)
        [r trigger:@"Test"];
}
- (void) calledTrigger:(BOOL)success {
    
}

@end
