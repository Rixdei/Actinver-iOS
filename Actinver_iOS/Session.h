//
//  Session.h
//  Actinver-IOS
//
//  Created by Josue de Jesus Maqueda Flores on 2/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeDefs.h"

@interface Session : NSObject

// Properties
@property (nonatomic, assign) SessionStatus         status;
@property (nonatomic, strong) NSString              *user;
@property (nonatomic, strong) NSString              *token;

@property (nonatomic, strong) NSMutableDictionary   *pre_session_info;

+ (Session*)sharedManager;
- (void)clearSession;

@end
