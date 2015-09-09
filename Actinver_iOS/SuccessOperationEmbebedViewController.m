//
//  SuccessOperationEmbebedViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 04/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "SuccessOperationEmbebedViewController.h"
#import "RequestManager.h"
#import "ChallengeViewController.h"
#import "ChangeContractAliasEmbebedViewController.h"
#import "SecurityImageSelector.h"
#import "Session.h"


@interface SuccessOperationEmbebedViewController ()<ResponseFromServicesDelegate,ImageSelectorResponse>
- (IBAction)save_changes:(id)sender;



- (IBAction)imageSecuritySelected:(id)sender;


//password txtfield

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPassWord_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *passNewWord_txtfield;

//notifications
@property (weak, nonatomic) IBOutlet UITextField *email_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *telephone_txtfield;


@end

@implementation SuccessOperationEmbebedViewController
@synthesize myImage;

- (void)viewDidLoad {
    [super viewDidLoad];


    [(UIButton *)[self.view viewWithTag:503] setBackgroundImage:[UIImage imageNamed:@"star"]
                                                       forState:UIControlStateNormal];
    
    NSString * alias = [[RequestManager sharedInstance] chang];
    [[RequestManager sharedInstance] setDelegate:self];
    _telephone_txtfield.textColor = [UIColor whiteColor];
    _confirmNewPassWord_txtfield.textColor = [UIColor whiteColor];
    _oldPassWord_txtfield.textColor = [UIColor whiteColor];
    _email_txtfield.textColor = [UIColor whiteColor];
    _passNewWord_txtfield.textColor =[UIColor whiteColor];

    
    NSAttributedString *textold = [[NSAttributedString alloc] initWithString:@"Contraseña anterior" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [ _oldPassWord_txtfield setAttributedPlaceholder:textold];
   
    NSAttributedString *textnew = [[NSAttributedString alloc] initWithString:@"Confirmar nueva Contraseña" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [ _confirmNewPassWord_txtfield setAttributedPlaceholder:textnew];
    
    NSAttributedString *textconfirm = [[NSAttributedString alloc] initWithString:@"Nueva contraseña" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [ _passNewWord_txtfield setAttributedPlaceholder:textconfirm];
    
    NSAttributedString *texemail = [[NSAttributedString alloc] initWithString:@"Email xxx@xx.com" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [ _email_txtfield setAttributedPlaceholder:texemail];
    
    NSAttributedString *textelephone = [[NSAttributedString alloc] initWithString:@"Telefono" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [ _telephone_txtfield setAttributedPlaceholder:textelephone];

    NSString * context = [NSString stringWithFormat:@"Cambio de alias para el contrato  \"%@\" exitoso",alias];
    _label_Alias.text = context;
    
   //send new password
    [[RequestManager sharedInstance] setN_password:_confirmNewPassWord_txtfield.text];
    
    //send email
    [[RequestManager sharedInstance] setEmail:_email_txtfield.text];
    
    //send cellphone
    [[RequestManager sharedInstance]setCellPhone:_telephone_txtfield.text];

    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save_changes:(id)sender {
    
    if ([sender tag] == 555) {
        if ([_oldPassWord_txtfield  isEqual:@""]||[_passNewWord_txtfield isEqual:@""]||[_confirmNewPassWord_txtfield isEqual:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Campos vacios" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        NSLog(@"newpass = %@",_passNewWord_txtfield.text);
        NSLog(@"newpass = %@",_confirmNewPassWord_txtfield.text);

        
        if (![_passNewWord_txtfield.text isEqualToString:_confirmNewPassWord_txtfield.text]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Contraseñas no coinciden" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        
        }
           
            if (![_oldPassWord_txtfield.text isEqualToString: [[Session sharedManager].pre_session_info objectForKey:@"password"]] ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Contraseña actual no conincide con la de sección" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return;
           
            }
            
            [self getChallenge];

        
        
        
        
     
    }else if([sender tag] == 666){
        if ([_telephone_txtfield  isEqual:@""]||[_email_txtfield isEqual:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Campos vacios" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        return;
        }else{
            [self getChallenge];
   
            
            
        }
            
    
    }else if([sender tag] == 777){
        [self getChallenge];

        [[RequestManager sharedInstance]setEmail:@"no hay email"];
    
    }
    
    

}

- (IBAction)imageSecuritySelected:(id)sender {
    
    NSLog(@"open image");
    [self performSegueWithIdentifier:@"imageSelectionSegue" sender:nil];
    
}

-(void) updateImage:(NSString *)imageName{
    [(UIButton *)[self.view viewWithTag:503] setBackgroundImage:[UIImage imageNamed:imageName]
                                                       forState:UIControlStateNormal];
  //  _dict_val   = imageName;
}
#pragma mark - responseFromService methods

-(void) responseFromService:(NSMutableDictionary *)response
{
    if ([[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"] == nil) { // Error info
#warning Show error challenge response
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
   //         [LoadingView close];
            [self performSegueWithIdentifier:@"segueShowChallengeView" sender:response];
            [[RequestManager sharedInstance ] setNewvalueType:[[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"]];
            [[RequestManager sharedInstance ] setSendingid:[[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"sendingID"]];

            

        });
    }



}

-(void)getChallenge
{
    //get challenge code ( SFT21 )
    
    NSMutableDictionary *params =[@{@"language"              : @"SPA",
                                    @"userId"    :[[Session sharedManager].pre_session_info objectForKey:@"username"],
                                    @"append_key"            :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
    
    //    [[LoadingView loadingViewWithMessage:nil] show];
    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:params
                                                toMethod:kRequestGetTransfersChallenge isPost:YES];



}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueShowChallengeView"]) {
        ChallengeViewController *aux = segue.destinationViewController;
        aux.challenge_info           = sender;
        aux.trans_data               = _trans_data;
    }
    if ([segue.identifier isEqualToString:@"imageSelectionSegue"]){
        SecurityImageSelector *aux  = (SecurityImageSelector *)segue.destinationViewController;
        aux.delegate                = self;
    }
}





@end
