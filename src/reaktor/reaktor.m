//
//  reaktor.m
//  reaktor
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import "reaktor.h"

@implementation reaktor

@synthesize delegate = _delegate, baseUrl = _baseUrl;

- (id) initWithDelegate:(id)delegate andMail:(NSString*)mail andPassword:(NSString*)password {
    self = [super init];
    
    if (self) {
        isLoggedIn = NO;
        
        _delegate = delegate;
        
        _baseUrl = @"http://api.reaktor.io";
        _connection = nil;
        _token = nil;
        
        _mail = mail;
        _password = password;
        
        [self login];
    }
    
    return self;
}

- (NSOperationQueue*)getQueue {
    if (!_queue)
        _queue = [[NSOperationQueue alloc] init];
    return _queue;
}

- (BOOL) canConnect {
    return [_mail length] > 0 && [_password length] > 0 && [_token length] > 0; // && _connection
}

- (void) login {
    if ([_mail length] > 0 && [_password length] > 0) {
        [self loginWithMail:_mail andPassword:_password];
    }
    else {
        if ([_delegate respondsToSelector:@selector(loggedIn:)]) {
            [_delegate loggedIn:NO]; //performSelector:@selector(loggedIn:) withObject:NO];
        }
    }
}

- (void) loginWithMail:(NSString*)mail andPassword:(NSString*)password {
    NSString *url = [NSString stringWithFormat:@"%@/login", _baseUrl];
    NSString *jsonData = [NSString stringWithFormat:@"{ \"mail\": \"%@\", \"pass\": \"%@\" }", mail, password];
    reaktorRequest *request = [[reaktorRequest alloc] initWithUrl:url andData:jsonData andMethodType:@"POST" andDelegate:self andMethod:@selector(loginRequestResult:) andQueue:[self getQueue]];
    [request start];
}

- (void) loginRequestResult:(NSData*)data {
    BOOL success = NO;
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if (!error) {
        success = (BOOL)[json objectForKey:@"ok"];
        _token = (NSString*)[json objectForKey:@"token"];
    }
    
    isLoggedIn = success;
    
    if ([_delegate respondsToSelector:@selector(loggedIn:)]) {
        [_delegate loggedIn:success];
    }
}

- (void) trigger:(NSString*)trigger {
    if ([self canConnect] && isLoggedIn) {
        [self trigger:trigger inSaveMode:NO];
    }
    else {
        if ([_delegate respondsToSelector:@selector(calledTrigger:)]) {
            [_delegate calledTrigger:NO];
        }
    }
}
- (void) trigger:(NSString*)trigger withParams:(NSDictionary*)params {
    [self trigger:trigger withParams:params inSaveMode:NO];
}
- (void) trigger:(NSString*)trigger inSaveMode:(BOOL)saveMode {
    [self trigger:trigger withParams:nil inSaveMode:saveMode];
}
- (void) trigger:(NSString*)trigger withParams:(NSDictionary*)params inSaveMode:(BOOL)saveMode {
    NSString *url = [NSString stringWithFormat:@"%@/trigger", _baseUrl];
    NSMutableString *paramsJSON = [[NSMutableString alloc] init];
    
    if (params) {
        [paramsJSON appendString:@"{ "];
        for (NSString *key in [params keyEnumerator]) {
            if ([paramsJSON length] > 2)
                [paramsJSON appendString:@", "];
            [paramsJSON appendFormat:@"\\\"%@\\\": \\\"%@\\\"", key, [params valueForKey:key]];
        }
        [paramsJSON appendString:@" }"];
    }
    
    NSString *data = [NSString stringWithFormat:@"{ \"token\": \"%@\", \"name\": \"%@\", \"data\": \"%@\", \"save\": \"%@\" }", _token, trigger, paramsJSON, saveMode ? @"true" : @"false"];
    
    reaktorRequest *request = [[reaktorRequest alloc] initWithUrl:url andData:data andMethodType:@"POST" andDelegate:self andMethod:@selector(triggerRequestResult:) andQueue:[self getQueue]];
    [request start];
}

- (void) triggerRequestResult:(NSData*)data {
    BOOL success = NO;
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSString *reason = @"";
    
    if (!error) {
        success = (BOOL)[json objectForKey:@"ok"];
    }
    
    if (!success) {
        reason = (NSString*)[json objectForKey:@"reason"];
        NSLog(@"reason: " + reason);
    }
    
    if ([_delegate respondsToSelector:@selector(calledTrigger:)]) {
        [_delegate calledTrigger:success];
    }
}

@end
