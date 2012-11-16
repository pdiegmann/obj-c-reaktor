//
//  reaktorRequest.m
//  reaktor
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import "reaktorRequest.h"

@implementation reaktorRequest

- (id) initWithUrl:(NSString*)url andData:(NSString*)requestData andMethodType:(NSString*)methodType andDelegate:(id)delegate andMethod:(SEL)method andQueue:(NSOperationQueue*)queue {

    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _method = method;
        _queue = queue;
    
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20.0f];
        [_request setHTTPMethod:methodType];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [_request setHTTPBody:[requestData dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    return self;
}

- (void) start {
    [NSURLConnection sendAsynchronousRequest:_request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             if ([_delegate respondsToSelector:_method]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_delegate performSelector:_method withObject:data];
                #pragma clang diagnostic pop
             }
         }
         
     }];

}

@end
