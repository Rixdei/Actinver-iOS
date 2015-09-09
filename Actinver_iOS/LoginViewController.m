//
//  LoginViewController.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 04.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsCallViewController.h"
#import "UserTableViewCell.h"
#import "SVProgressHUD.h"
#import "ConnectionManager.h"
#import "CallManager.h"
#import "PrefixHeader.pch"
#import "LoadingView.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

NSString *const kSettingsCallSegueIdentifier = @"SettingsCallSegue";
NSString *const kUserTableViewCellIdentifier =  @"UserTableViewCellIdentifier";

const CGFloat kInfoHeaderHeight = 44;

@interface LoginViewController()

<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *buildVersionLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //   [[LoadingView loadingViewWithMessage:@""] show];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 44;
    self.buildVersionLabel.text = [self version];
    [self automaticTansition];
   

}
- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Verison

- (NSString *)version {
    
    NSString *appVersion = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    NSString *appBuild = NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
    NSString *version = [NSString stringWithFormat:@"v:%@ %@\nbuild %@\nQBv%@:r%@",
                         appVersion, QB_VERSION_STR, appBuild, QuickbloxWebRTCFrameworkVersion, QuickbloxWebRTCRevision];
    
    return version;
}

#pragma makr - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return ConnectionManager.instance.users.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTableViewCellIdentifier];
    
    QBUUser *user = ConnectionManager.instance.users[indexPath.row];
    
    //[cell setColorMarkerText:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]
    //                andColor:nil];
    
   // cell.userDescription = [NSString stringWithFormat:@"Login as %@", user.fullName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = NSLocalizedString(@"Login as any user on this device and another(s) users on another device", nil);
        tableViewHeaderFooterView.hidden=YES;

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"header";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kInfoHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.0f;
}

#pragma makr - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    QBUUser *user = ConnectionManager.instance.users[indexPath.row];
    [self logInChatWithUser:user];
}

#pragma Login in chat

- (void)logInChatWithUser:(QBUUser *)user {
    
    [SVProgressHUD setBackgroundColor:nil];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Login chat", nil)];
    
    __weak __typeof(self)weakSelf = self;
    [[ConnectionManager instance] logInWithUser:user
                                     completion:^(BOOL error)
     {
         if (!error) {
             
             [SVProgressHUD dismiss];
             [weakSelf performSegueWithIdentifier:kSettingsCallSegueIdentifier
                                           sender:nil];
         }
         else {
             
             [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login chat error!", nil)];
         }
     }];
}
-(void)automaticTansition{

 //   [[LoadingView loadingViewWithMessage:@""] show];
    QBUUser *user = ConnectionManager.instance.users[0];
    [self logInChatWithUser:user];
//    [LoadingView close];
    

}

@end
