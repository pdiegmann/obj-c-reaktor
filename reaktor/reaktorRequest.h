//
//  reaktorRequest.h
//  reaktor
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum reaktorMethodType { rmtPOST, rmtGET, rmtPUT, rmtDELETE } reaktorMethodType;

@interface reaktorRequest : NSObject<NSURLConnectionDataDelegate> {
    id _delegate;
    SEL _method;
    
    NSOperationQueue *_queue;
    NSMutableURLRequest *_request;
}

- (id) initWithUrl:(NSString*)url andData:(NSString*)requestData andMethodType:(NSString*)methodType andDelegate:(id)delegate andMethod:(SEL)method andQueue:(NSOperationQueue*)queue;
- (void) start;

@end
