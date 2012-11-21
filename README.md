obj-c-reaktor
==========

Objective-C client (iOS and Mac OS X) for reaktor.io.

Builds a universal framework.

Installation
=========
Just drag'n'drop the 'folder' bin/Release-universal/reaktor.framework into your xCode-project. This project can be targeted for iOS (iPhone and / or iPad; tested minimum SDK-Version 6.0) or Mac OS X (tested on 10.8).

Usage
=========
- Import the reaktor-header in your header-file: #import <reaktor/reaktor.h>
- Add reaktorDelegate to your class' delegate-protocolls: @interface myClass : NSObject <reaktorDelegate>
- Implement the callbacks:
  - (void) loggedIn:(BOOL)success withResult:(NSDictionary *)json;
  - (void) calledTrigger:(BOOL)success withResult:(NSDictionary *)json;
- Create your reaktor: reaktor r = [[reaktor alloc] initWithDelegate:self andMail:@"me@host.com" andPassword:@"password"];
- Trigger a trigger: [r trigger:@"myTrigger" withParams:[NSDictionary dictionaryWithObject:@"My Name" forKey:@"name"]];

ATTENTION: You can only trigger a trigger AFTER you were logged in successfully. We recommend to take care of your status with a local variable.

Project-Structure
=========

The project contains a src and a bin folder. bin always contains the altest builds build with the universal reaktor target, whereas src contains all source files.
The targets are splitted into a basic reaktor-target which just builds the iOS- and the Mac-OS-X-targets, merges and copies the build into the project-folder. We always try to write code which can be executed on both, iOS and Mac OS X, so the subfolders ios-reaktor and mac-reaktor are empty - besides the prefix-file.