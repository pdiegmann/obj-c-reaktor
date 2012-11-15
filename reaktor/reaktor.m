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
        _delegate = delegate;
        
        _baseUrl = @"";
        _connection = nil;
        
        _mail = mail;
        _password = password;
        
        [self login];
    }
    
    return self;
}

- (BOOL) isLoggedIn {
    return [_mail length] > 0 && [_password length] > 0 && _connection;
}

- (void) login {
    if ([self isLoggedIn]) {
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
    NSString *data = [NSString stringWithFormat:@"mail=%@&pass=%@", mail, password];
    reaktorRequest *request = [[reaktorRequest alloc] initWithUrl:url andData:data andMethodType:@"POST" andDelegate:self andMethod:@selector(loginRequestResult:)];
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
        success = [[json objectForKey:@"ok"] isEqualToString:@"true"];
    }
    
    if ([_delegate respondsToSelector:@selector(loggedIn:)]) {
        [_delegate loggedIn:success]; //performSelector:@selector(loggedIn:) withObject:success];
    }
}

- (void) trigger:(NSString*)trigger {
    if ([self isLoggedIn]) {
        [self trigger:trigger inSaveMode:NO];
    }
    else {
        if ([_delegate respondsToSelector:@selector(calledTrigger:)]) {
            [_delegate calledTrigger:NO]; //performSelector:@selector(calledTrigger:) withObject:NO];
        }
    }
}
- (void) trigger:(NSString*)trigger inSaveMode:(BOOL)saveMode {
    NSString *url = [NSString stringWithFormat:@"%@/trigger", _baseUrl];
    NSString *data = [NSString stringWithFormat:@"name=%@&save=%@", trigger, saveMode ? @"true" : @"false"];
    reaktorRequest *request = [[reaktorRequest alloc] initWithUrl:url andData:data andMethodType:@"POST" andDelegate:self andMethod:@selector(triggerRequestResult:)];
    [request start];
}

- (void) triggerRequestResult:(NSData*)data {
    BOOL success = NO;
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if (!error) {
        success = [[json objectForKey:@"ok"] isEqualToString:@"true"];
    }
    
    if ([_delegate respondsToSelector:@selector(calledTrigger:)]) {
        [_delegate calledTrigger:success]; // delegate performSelector:@selector(calledTrigger:) withObject:success];
    }
}

@end
