//
//  UsersDataSource.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 11.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "UsersDataSource.h"
#import "PrefixHeader.pch"
#import "RequestManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

@interface UsersDataSource()<ResponseFromServicesDelegate>

@property (strong, nonatomic, readonly) NSArray *colors;
@property (strong, nonatomic) NSMutableArray *testUsers;

@end

@implementation UsersDataSource

@dynamic users;

//NSString *const kDefaultPassword = @"x6Bt0VDy5";
NSString *const kDefaultPassword = @"12345678";

NSString *const kUsersKey = @"users";
NSString *const kUserIDKey = @"ID";
NSString *const kFullNameKey = @"fullName";
NSString *const kLoginKey = @"login";
NSString *const kPasswordKey = @"password";

+ (instancetype)instance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self loadUsers];
        
        _colors =
        @[[UIColor colorWithRed:0.992 green:0.510 blue:0.035 alpha:1.000],
          [UIColor colorWithRed:0.039 green:0.376 blue:1.000 alpha:1.000],
          ];
    }
    
    return self;
}

- (void)loadUsers {


    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Users", QB_VERSION_STR]
                                                          ofType:@"plist"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray *users = dictionary[kUsersKey];
    self.testUsers = [NSMutableArray arrayWithCapacity:users.count];
    [users enumerateObjectsUsingBlock:^(NSDictionary *user,
                                        NSUInteger idx,
                                        BOOL *stop) {
        QBUUser *testUser =
        [self userWithID:user[kUserIDKey]
                   login:user[kLoginKey]
                fullName:user[kFullNameKey]
                passowrd:user[kPasswordKey]];
        
        [self.testUsers addObject:testUser];
       

    
    }];
}

- (NSArray *)users{
    
 
    
    return _testUsers.copy;
}

- (QBUUser *)userWithID:(NSNumber *)userID
                  login:(NSString *)login
               fullName:(NSString *)fullName
               passowrd:(NSString *)password {
    
    QBUUser *user = [QBUUser user];
    user.ID = userID.integerValue;
    user.login = login;
    user.fullName = fullName;
    user.password = password ?:kDefaultPassword;
    
    return user;
}

//- (UIColor *)colorAtUser:(QBUUser *)user {
//    
//    NSUInteger idx = [self.testUsers indexOfObject:user];
//    return self.colors[idx];
//}



@end
