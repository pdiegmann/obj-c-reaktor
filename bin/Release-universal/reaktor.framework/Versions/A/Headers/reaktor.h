//
//  reaktor.h
//  reaktor
//
//  Created by Phil Diegmann on 15.11.12.
//  Copyright (c) 2012 Phil Diegmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reaktorRequest.h"

/* test@test.de / test / Test */

@protocol reaktorDelegate <NSObject>

- (void) loggedIn:(BOOL)success withResult:(NSDictionary*)json;
- (void) calledTrigger:(BOOL)success withResult:(NSDictionary*)json;

@end

@interface reaktor : NSObject {
    id _delegate;
    
    BOOL isLoggedIn;
    
    BOOL loggingEnabled;
    
    NSString *_mail;
    NSString *_password;
    NSString *_token;
    
    NSString *_baseUrl;
    NSURLRequest *_connection;
    NSOperationQueue *_queue;
}

@property (nonatomic, retain) id<reaktorDelegate> delegate;
@property (nonatomic, retain) NSString *baseUrl;

- (id) initWithDelegate:(id)delegate andMail:(NSString*)mail andPassword:(NSString*)password;
- (id) initWithDelegate:(id)delegate andMail:(NSString*)mail andPassword:(NSString*)password andLogging:(BOOL)log;
- (void) login;
- (void) loginWithMail:(NSString*)mail andPassword:(NSString*)password;
- (void) trigger:(NSString*)trigger;
- (void) trigger:(NSString*)trigger withParams:(NSDictionary*)params;
- (void) trigger:(NSString*)trigger inSaveMode:(BOOL)saveMode;
- (void) trigger:(NSString*)trigger withParams:(NSDictionary*)params inSaveMode:(BOOL)saveMode;

@end
