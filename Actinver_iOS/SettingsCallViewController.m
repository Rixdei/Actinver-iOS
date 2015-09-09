//
//  SettingsCallViewController.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 11.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "SettingsCallViewController.h"
#import "CheckUserTableViewCell.h"
#import "ConnectionManager.h"
#import "CallManager.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "LoadingView.h"
#import "InitialViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

NSString *const kCheckUserTableViewCellIdentifier = @"CheckUserTableViewCellIdentifier";
NSString *const kStunViewControllerIdentifier = @"StunViewController";

const CGFloat kSettingsInfoHeaderHeight = 25;

@interface SettingsCallViewController ()

<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedUsers;

@end

@implementation SettingsCallViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //[backButton release];
    
    
    
    
    // Do any additional setup after loading the view.
    

    [self getUsersByLogin];
        
   // [LoadingView close];

//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.rowHeight = 44;
//    self.selectedUsers = [NSMutableArray array];
//    self.users = ConnectionManager.instance.usersWithoutMe;
    
//    __weak __typeof(self)weakSelf = self;
//    [self setDefaultBackBarButtonItem:^{
//        
//        [ConnectionManager.instance logOut];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
//    
    self.title = [NSString stringWithFormat:@"%@", ConnectionManager.instance.me.fullName];
   
    UIBarButtonItem *anotherButton =
    [[UIBarButtonItem alloc] initWithTitle:@"logout"
                                     style:UIBarButtonItemStylePlain
                                    target:self action:@selector(pressSelectStun:)];
    
    self.navigationItem.rightBarButtonItem = anotherButton;
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:NO animated:NO];

 }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"TABLA: %lu",(unsigned long)[self.users count]);

    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCheckUserTableViewCellIdentifier];
    
    QBUUser *user = self.users[indexPath.row];
    
    cell.userDescription = [NSString stringWithFormat:@"%@", user.fullName];
    
    BOOL checkMark = [self.selectedUsers containsObject:user];
    [cell setCheckmark:checkMark];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    QBUUser *user = self.users[indexPath.row];
    [self procUser:user];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = NSLocalizedString(@"Seleccione un asesor y presione llamar", nil);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"header";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kSettingsInfoHeaderHeight;
}

#pragma mark Actions

- (void)pressSelectStun:(id)sender {
    
//    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:kStunViewControllerIdentifier];
//    [self presentViewController:navVC animated:YES completion:^{
//        
//    }];
    
        [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
            // Successful logout
            NSLog(@"Logout success");
            
        } errorBlock:^(QBResponse *response) {
            NSLog(@"Logout error");
            // Handle error
        }];
    
        //[self.navigationController popToRootViewControllerAnimated:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        InitialViewController *initialVC = [storyboard instantiateViewControllerWithIdentifier:@"inicio"];
    
        [self presentViewController:initialVC animated:YES completion:NULL];
}

- (IBAction)pressAudioCallBtn:(id)sender {
    
    [self callWithConferenceType:QBConferenceTypeAudio];
}

- (IBAction)pressVideoCallBtn:(id)sender {
    
    [self callWithConferenceType:QBConferenceTypeVideo];
}

- (void)callWithConferenceType:(QBConferenceType)conferenceType {
    
    if ([self usersToCall]) {
        
        [CallManager.instance callToUsers:self.selectedUsers
                       withConferenceType:conferenceType];
    }
}

#pragma mark - Selected users

- (BOOL)usersToCall {
    
   
    BOOL isOK = (self.selectedUsers.count > 0);
    
    if (!isOK) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please select one or more users", nil)];
    }
    
    return isOK;
}

- (void)procUser:(QBUUser *)user {
    
    if (![self.selectedUsers containsObject:user]) {
        
        [self.selectedUsers addObject:user];
    }
    else {
        
        [self.selectedUsers removeObject:user];
    }
}
-(void)getUsersByLogin{
   // dispatch_async(dispatch_get_main_queue(), ^{
 
    NSLog(@"array with users to video call = %@",[[RequestManager sharedInstance ] advisors]);
   
    
    [QBRequest usersWithLogins:[[RequestManager sharedInstance ] advisors] page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10]
                  successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                      // Successful response with page information and users array
                      
                      NSLog(@"UsersByLoginSuccess%@",response);
                      [self DisplayUserinTable:users];
                      
                  } errorBlock:^(QBResponse *response) {
                      // Handle error
                      
                      NSLog(@"UsersByLoginERROR%@",response);
                  }];
  //  });
}

-(void)DisplayUserinTable :(NSArray*)Users{
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 44;
    self.selectedUsers = [NSMutableArray array];
    self.users = Users;
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];

    NSLog(@"user Count = %lu", (unsigned long)[self.users count]);
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [LoadingView close];
//        
//    });
}

//-(void)backNavigationItem:(id)sender{
//
//    [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
//        // Successful logout
//    } errorBlock:^(QBResponse *response) {
//        // Handle error
//    }];
//    
//    //[self.navigationController popToRootViewControllerAnimated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    InitialViewController *initialVC = [storyboard instantiateViewControllerWithIdentifier:@"inicio"];
//    
//    [self presentViewController:initialVC animated:YES completion:NULL];
//    
//
//}

@end
