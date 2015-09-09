//
//  ShowChallengeViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 25/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ShowChallengeViewController.h"
#import "CustomizeControl.h"
#import "Utility.h"
#import "RequestManager.h"

@interface ShowChallengeViewController ()

@property (nonatomic, weak) IBOutlet UILabel        *lbl_challenge;
@property (nonatomic, weak) IBOutlet UILabel        *lbl_folio;
@property (nonatomic, weak) IBOutlet UITextField    *txt_token;
@property (weak, nonatomic) IBOutlet UIImageView *imageConfirmation;
@property (weak, nonatomic) IBOutlet UITextView *legenLabel;
@property (weak, nonatomic) IBOutlet UIView *bgnd_Label;
@property (weak, nonatomic) IBOutlet UILabel *numberFolioLabel;

@end

@implementation ShowChallengeViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{

    // Challenge functionality
    


    
    NSString *challenge = [[_challenge_info objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"];
    _lbl_challenge.text = [challenge substringFromIndex:2];
    
   // [_lbl_challenge setText:[[_challenge_info objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"]];
        
    [CustomizeControl setPlaceHolderForUITextFieldInEnrollment:_txt_token
                                                          WithText:@"Ingrese nuevo token"];
    // Transaction confirmation view

    if ([[_challenge_info objectForKey:@"method_code"] intValue] == kRequestSendPayService) {  // kRequestSendPayService   kRequestSendTransfer
        
        [_lbl_folio setText:[[[_challenge_info objectForKey:@"outServicePaymentRequest"] objectForKey:@"transferResult"] objectForKey:@"transferReference"]];
    }
    if ([[_challenge_info objectForKey:@"method_code"] intValue] == kRequestSendTransfer) {
        
        [_lbl_folio setText:[[[_challenge_info objectForKey:@"outTransferRequest"] objectForKey:@"transferResult"] objectForKey:@"operationReference"]];
        
    }// KRequestSendPayCreditCard
    if ([[_challenge_info objectForKey:@"method_code"] intValue] == KRequestSendPayCreditCard) {
        
        [_lbl_folio setText:[[[[_challenge_info objectForKey:@"outCreditCardPayment"] objectForKey:@"outUBCreditCardPayment"] objectForKey:@"paymentResult"] objectForKey:@"paymentReference"]];
    }

    
    if ([_lbl_folio.text  isEqual:@"Label"]) {
        _legenLabel.text =@"La operación solicitada se a efectuado correctamente.";
        _lbl_folio.hidden =YES;
        _bgnd_Label.hidden= YES;
        _numberFolioLabel.hidden =YES;
        
        
    }
    
    [super viewWillAppear:YES];
//    UIImage * img;
//    img = [UIImage imageNamed:@"correct"];
//    _imageConfirmation.image = img;
    
    _imageConfirmation.image =[UIImage imageNamed:@"correct"];

}

- (IBAction)recoverData:(id)sender{
    #warning Validations for token (length, composition, etc)
    
    if ([[_txt_token.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]   isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                        message:@"El campo Ingrese nuevo token esta vacio."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (_txt_token.text.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                       message:@"El campo Ingrese nuevo token debe ser de 8 dígitos."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else if(_txt_token.text.length > 8){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                       message:@"El campo Ingrese nuevo token debe ser de 8 dígitos."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
   
    [_delegate notifyDataEntryEnteredInfo:[@{@"challenge_result":[_txt_token text]} mutableCopy]];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)finishTransaction:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 //[_delegate notifyReturnToMainViewWithMessage:kOpenTransactionSucceed];
                             }];
}

@end
