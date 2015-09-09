//
//  InitialViewController.m
//  Actinver-IOS
//
//  Created by Raul Galindo Hernandez on 3/24/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "InitialViewController.h"
#import "EnrollmentViewController.h"
#import "MainView.h"
#import "CustomizeControl.h"
#import "NavigationDrawer.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "RequestManager.h"
#import "NCVideocallViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

@interface InitialViewController ()<ResponseFromServicesDelegate>
- (IBAction)VideoCall:(id)sender;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self initSetup];
    
    if (![self connected]) {
        // not connected
        UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                        message:@"No estás conectado a internet, asegurate de estar conectado"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil , nil];
        [campo show];
       
        
        
    } else {
        // connected, do some internet stuff

    }
    
}

-(void)initSetup
{
    [[self navigationController]                setNavigationBarHidden:NO animated:YES];
    [[self.navigationController navigationBar]  setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar    setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar    setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //
    UILabel *label                  = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor           = [UIColor clearColor];
    label.font                      = [UIFont fontWithName:@"HelveticaNeue" size:20];
    label.shadowColor               = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment             = NSTextAlignmentCenter;
    label.textColor                 = [UIColor whiteColor];
    self.navigationItem.titleView   = label;
    label.text                      = NSLocalizedString(@"", @"");
    [label sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"LoginViewSegue"]) {
        ((EnrollmentViewController *)segue.destinationViewController).processFlow    = LoginProcess;
    
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"unwindExitApplication"]) {
        NSLog(@"From Logout");
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark - VideoCall Methods.

- (IBAction)VideoCall:(id)sender {
    
    
    NSString *phoneNumber = @"tel://018007055555"; // Cambiar por el número de teléfono al que llamar
    NSURL *cleanPhoneNumber = [NSURL URLWithString:[NSString stringWithFormat:@"%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:cleanPhoneNumber];
    
    
    NSMutableDictionary *params = [@{ @"customerId": @"107799068",
                                     } mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kQuickBloxLogin isPost:NO];
    });
    
    
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
    
    if ([response objectForKey:@"result"] ==2) {//error
        NSLog(@"error result 2");
        
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
