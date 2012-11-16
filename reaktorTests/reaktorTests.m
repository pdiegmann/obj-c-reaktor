//
//  reaktorTests.m
//  reaktorTests
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import "reaktorTests.h"

@implementation reaktorTests

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
    //STFail(@"Unit tests are not implemented yet in reaktorTests");
    reaktor *r = [[reaktor alloc] initWithDelegate:self andMail:@"test@test.de" andPassword:@"test"];
    [r trigger:@"Test"];
}

- (void) loggedIn:(BOOL)success {
    NSLog(@"loggedIn: %i", success);
}
- (void) calledTrigger:(BOOL)success {
    NSLog(@"calledTrigger: %i", success);
}

@end
