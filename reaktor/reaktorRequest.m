//
//  reaktorRequest.m
//  reaktor
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import "reaktorRequest.h"

@implementation reaktorRequest

- (id) initWithUrl:(NSString*)url andData:(NSString*)requestData andMethodType:(NSString*)methodType andDelegate:(id)delegate andMethod:(SEL)method {

    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _method = method;
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20.0f];
        [request setHTTPMethod:methodType];
        NSData *data = [NSData dataWithBytes: [requestData UTF8String] length: [requestData length]];
        [request setHTTPBody:data];
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        //[_connection start];
    }
    
    return self;
}

- (void) start {
    if (_connection)
        [_connection start];
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _data = [[NSMutableData alloc] init];
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_data appendData:data];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    if ([_delegate respondsToSelector:_method]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_delegate performSelector:_method withObject:_data];
        #pragma clang diagnostic pop
    }
}

@end
