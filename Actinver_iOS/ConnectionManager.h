//
//  ConnectionManager.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 12.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>


@interface ConnectionManager : NSObject{

 NSArray * advisors;
}


@property (strong, nonatomic, readonly) NSArray *users;
@property (strong, nonatomic, readonly) NSArray *usersWithoutMe;
@property (strong, nonatomic, readonly) QBUUser *me;

+ (instancetype)instance;

- (void)logInWithUser:(QBUUser *)user completion:(void (^)(BOOL error))completion;
- (void)logOut;

- (NSArray *)idsWithUsers:(NSArray *)users;
- (NSArray *)usersWithIDS:(NSArray *)ids;
- (QBUUser *)userWithID:(NSNumber *)userID;

@end

@interface QBUUser (ConnectionManager)

- (NSUInteger)index;
- (UIColor *)color;

@end