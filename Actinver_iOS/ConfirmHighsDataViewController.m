//
//  ConfirmHighsDataViewController.m
//  Actinver_iOS
//
//  Created by David fernando Guia Orduña on 06/08/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ConfirmHighsDataViewController.h"
#import "ChallengeViewController.h"
#import "LoadingView.h"
#import "Session.h"

@interface ConfirmHighsDataViewController () <ResponseFromServicesDelegate>

@end

@implementation ConfirmHighsDataViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [(UILabel*)[self.view viewWithTag:203] setHidden:YES];
//    [(UILabel*)[self.view viewWithTag:204] setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *btn_continue = [[UIBarButtonItem alloc] initWithTitle:@"Continuar"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(continueTransaction:)];
    NSArray *actionButtonItems = @[btn_continue];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    NSDictionary    *origin         = (NSMutableDictionary *)[_trans_data objectAtIndex:0];
    NSLog(@"ORIGIN: %@",origin);
    
    //[(UITextField *)[self.view viewWithTag:101] setText:[[origin objectForKey:@"idContrato"] stringValue]];
    
    NSDictionary    *destination    = (NSMutableDictionary *)[_trans_data objectAtIndex:1];
    NSLog(@"DESTINATION: %@",destination);
    
    
    if ([[destination objectForKey:@"typeProcess"] isEqualToString:@"RegisterCreditCard"]) {
        [(UIView*)[self.view viewWithTag:4000] setHidden:NO];
        [(UIView*)[self.view viewWithTag:4004] setHidden:YES];
        [(UIView*)[self.view viewWithTag:4011] setHidden:YES];
        
        [(UITextField*)[self.view viewWithTag:4001] setText:[destination objectForKey:@"creditCardNumber"]];
        [(UITextField*)[self.view viewWithTag:4002] setText:[destination objectForKey:@"alias"]];
        [(UITextField*)[self.view viewWithTag:4003] setText:[destination objectForKey:@"maxAmount"]];
    }

    
    if ([[destination objectForKey:@"typeProcess"] isEqualToString:@"RegisterCount"]) {
        [(UIView*)[self.view viewWithTag:4000] setHidden:YES];
        [(UIView*)[self.view viewWithTag:4004] setHidden:NO];
        [(UIView*)[self.view viewWithTag:4011] setHidden:YES];

        
        [(UITextField*)[self.view viewWithTag:4005] setText:[destination objectForKey:@"acount"]];
        [(UITextField*)[self.view viewWithTag:4006] setText:[destination objectForKey:@"bankName"]];
        [(UITextField*)[self.view viewWithTag:4007] setText:[destination objectForKey:@"beneficiaryName"]];
        [(UITextField*)[self.view viewWithTag:4008] setText:[destination objectForKey:@"acountNumber"]];
        [(UITextField*)[self.view viewWithTag:4009] setText:[destination objectForKey:@"alias"]];
        [(UITextField*)[self.view viewWithTag:4010] setText:[destination objectForKey:@"beneficiaryMail"]];
    }
    
    
    if ([[destination objectForKey:@"typeProcess"] isEqualToString:@"RegisterService"]) {
        [(UIView*)[self.view viewWithTag:4000] setHidden:YES];
        [(UIView*)[self.view viewWithTag:4004] setHidden:YES];
        [(UIView*)[self.view viewWithTag:4011] setHidden:NO];
        
        [(UITextField*)[self.view viewWithTag:4012] setText:[destination objectForKey:@"alias"]];
        [(UITextField*)[self.view viewWithTag:4013] setText:@"Servicios"];
        [(UITextField*)[self.view viewWithTag:4014] setText:[destination objectForKey:@"Service"]];
        [(UITextField*)[self.view viewWithTag:4015] setText:[destination objectForKey:@"amountLimit"]];
    }
    

//
//    NSDictionary    *details        = (NSMutableDictionary *)[_trans_data objectAtIndex:2];
//    NSLog(@"Details: %@", details);
//
//    [(UITextField*)[self.view viewWithTag:201]setText:[Utility stringWithMoneyFormat:[[details objectForKey:@"amount"] doubleValue]] ];
//    // [(UITextField *)[self.view viewWithTag:201] setText:[details objectForKey:@"amount"]];
//    //[(UITextField *)[self.view viewWithTag:202] setText:[details objectForKey:@"concept"]];
//    
//    if ([details objectForKey:@"concept"]) {
//        [(UITextField *)[self.view viewWithTag:202] setText:[details objectForKey:@"concept"]];
//    }else if ([details objectForKey:@"transferDetails"]) {
//        [(UITextField *)[self.view viewWithTag:202] setText:[details objectForKey:@"transferDetails"]];
//    }
    
//    if (_trans_data.count >3) {     // Notify beneficiary info available
//        NSDictionary    *notif_info        = (NSMutableDictionary *)[_trans_data objectAtIndex:3];
//        [(UITextField *)[self.view viewWithTag:303] setText:[notif_info objectForKey:@"mail"]];
//        [(UITextField *)[self.view viewWithTag:305] setText:[notif_info objectForKey:@"sms"]];
//    }
//    else{
//        for (int i= 301; i<306; i++)
//            [[self.view viewWithTag:i] setHidden:YES];
//    }
//    
    [super viewWillAppear:YES];
}

-(IBAction)continueTransaction:(id)sender{
    //key+language=SPA&userId=107399578
    
    //    NSMutableDictionary *params = [@{@"tokenType"            : tokentype,
    //                                     @"actiPassDeviceModel"   : @"2",
    //                                     @"actiPassDeviceTypeId"  : @"2",
    //                                     @"enrollmentToken"       : @"AC232270",
    //                                     @"enrollmentOtpPin"      : @"0",
    //                                     @"language"              : @"SPA",
    //                                     @"enrollmentClientId"    :[[Session sharedManager].pre_session_info objectForKey:@"username"],
    //                                     @"append_key"            :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    //
    //    [RequestManager sharedInstance].delegate = self;
    //    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KGenerateToken isPost:YES];  // SFT22
    
    
    NSMutableDictionary *params =[@{@"language"              : @"SPA",
                                    @"userId"    :[[Session sharedManager].pre_session_info objectForKey:@"username"],
                                    @"append_key"            :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
    
    [[LoadingView loadingViewWithMessage:nil] show];
    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:params
                                                toMethod:kRequestGetTransfersChallenge isPost:YES];
    //    [[RequestManager sharedInstance] sendRequestWithData:[@{@"append_key" :[[RequestManager sharedInstance] keyToSend]} mutableCopy]
    //                                                toMethod:kRequestGetTransfersChallenge isPost:YES];
}

-(void)responseFromService:(NSMutableDictionary *)response{
#warning Validate the result is nil (Network error)
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
    
    NSLog(@"Response: %@",response);
    
    if ([[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"] == nil) { // Error info
#warning Show error challenge response
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            [self performSegueWithIdentifier:@"segueShowChallengeView" sender:response];
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueShowChallengeView"]) {
        ChallengeViewController *aux = segue.destinationViewController;
        aux.challenge_info           = sender;
        aux.trans_data               = _trans_data;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 
 }
 */

@end
