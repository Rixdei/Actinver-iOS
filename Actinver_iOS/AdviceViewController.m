//
//  AdviceViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 17/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "AdviceViewController.h"
#import "LoginViewController.h"
#import "RequestManager.h"
#import "NCVideocallViewController.h"


#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>


@interface AdviceViewController ()<ResponseFromServicesDelegate>

@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeAdviceView:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)video_Call:(id)sender {
    
    NSString *session = [[Session sharedManager].pre_session_info objectForKey:@"username"];
        NSMutableDictionary *params = [@{ @"customerId": session,
                                         } mutableCopy];
    
        [RequestManager sharedInstance].delegate = self;
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kQuickBloxLogin isPost:NO];

    
    //  callVC
    
//            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UINavigationController *navigationController;
//    
//            NCVideocallViewController *homeVC = (NCVideocallViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"videocallnc"];
//            navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    
//          [self.navigationController pushViewController:homeVC animated:YES];
    
          [self dismissViewControllerAnimated:YES
                                   completion:nil];
    
}

-(void)responseFromService:(NSMutableDictionary *)response{
    NSLog(@"response qblox = %@",response);
    NSArray *usersVideocall = [response objectForKey:@"advisors"];
    NSLog(@"uservideocall = %@",usersVideocall);
    NSMutableArray * arrayusers = [[NSMutableArray alloc]init];
    
    for (NSDictionary * advisorname in usersVideocall) {
        NSString * users= [advisorname objectForKey:@"login"];
        
        [arrayusers addObject:users ];
        
    }
    NSLog(@"array users %@" ,arrayusers);
    
    NSArray * advisosrsName = arrayusers;
    [[RequestManager sharedInstance] setAdvisors:advisosrsName];
    
    if ([[response objectForKey:@"message"]isEqualToString:@"parametro 'customerId' no encontrado en la base de datos"]) {//error
        NSLog(@"parametro 'customerId' no encontrado en la base de datos");
        [self video_Call:nil];
        
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                       message:@"Lo Sentimos, no cuenta con este servicio"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [error show];
        
        return ;
        
    }else{
        NSString * login = [[response objectForKey:@"userkeys"] objectForKey:@"username"];
        NSString * passWord =[[response objectForKey:@"userkeys"] objectForKey:@"password"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
                //Your Quickblox session was created successfully
                
                NSLog(@"success = %@ ", response);
                NSLog(@" session success = %@ ", session);
                
                [self singUp:login :passWord];
                
                
            } errorBlock:^(QBResponse *response) {
                //Handle error here
                NSLog(@"success error = %@",response);
                
            }];
        });
    }
    
    //    [QBRequest usersWithLogins:@[@"luistinajero",@"Salvador",@"luis"] page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10]
    //                  successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
    //                      NSLog(@"resposne = %@ page = %@  users = %@",response, page , users);
    //
    //                      [[RequestManager sharedInstance ] setAdvisors:users];
    //                  } errorBlock:^(QBResponse *response) {
    //                      // Handle error
    //                  }];
    
}

-(void) singUp: (NSString * )login :(NSString*)passWord{
    QBUUser *user = [QBUUser user];
    user.password = passWord;
    user.login = login;
    
    // Registration/sign up of User
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        // Sign up was successful
        NSLog(@"response singin UP = %@",response);
        [self login:login :passWord];
    } errorBlock:^(QBResponse *response) {
        // Handle error here
        NSLog(@"response singin UP error = %@",response);
        [self login:login :passWord];
        
    }];
    
}




- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        // Login succeeded
        NSLog(@"session succeeded = %@ ", response);
        
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //       NCVideocallViewController  *initialVC = [storyboard instantiateViewControllerWithIdentifier:@"videocallnc"];
        //        [self presentViewController:initialVC animated:YES completion:NULL];
        
        
        
        
        
    };
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // Handle error
        NSLog(@"session error %@",response);
        
    };
}

- (void)login:(NSString * )login : (NSString * )passWord
{
    // Authenticate user
    [QBRequest logInWithUserLogin:login password:passWord
                     successBlock:[self successBlock] errorBlock:[self errorBlock]];
}




@end
