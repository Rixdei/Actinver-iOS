//
//  UsersDataSource.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 11.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

@interface UsersDataSource : NSObject

@property (strong, nonatomic, readonly) NSArray *users;

+ (instancetype)instance;
//- (UIColor *)colorAtUser:(QBUUser *)user;

@end
