//
//  Session.m
//  Actinver-IOS
//
//  Created by Josue de Jesus Maqueda Flores on 2/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "Session.h"

static Session *sharedManager = nil;

@implementation Session

+(Session*)sharedManager
{
    @synchronized(self)
    {
        if(sharedManager == nil)
        {
            sharedManager = [[self alloc] init];
            
            [sharedManager setUser:@""];
            [sharedManager setToken:@""];
            [sharedManager setStatus:CLOSE_SESSION];
            [sharedManager setPre_session_info:[[NSMutableDictionary alloc] init]];
        }
        else
        {
            return sharedManager;
        }
    }
    //
    return sharedManager;
}

#pragma mark - Clear actual session
- (void)clearSession
{
    self.status = CLOSE_SESSION;
    self.user = @"";
    self.token = @"";
}

@end
