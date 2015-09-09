//
//  EnrollmentViewController.m    CODIGO TOKEN
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "EnrollmentViewController.h"
#import "Container.h"
#import "CustomizeControl.h"
#import "RequestManager.h"
#import "IOConstants.h"
#import "Session.h"
#import "EnrollmentStepController.h"
#import "LoadingView.h"
#import "InitialViewController.h"

@interface EnrollmentViewController ()<ContainerEnrollmentDelegate,ResponseFromServicesDelegate>

@property (weak, nonatomic) IBOutlet UILabel        *lbl_header;
@property (weak, nonatomic) IBOutlet UIButton       *btn_back;
@property (weak, nonatomic) IBOutlet UIButton       *btn_forw;

@property (nonatomic, weak) Container *containerViewController;

@end

@implementation EnrollmentViewController

static EnrollmentViewController   *sharedManager    = nil;

@synthesize KEY         = KEY;
@synthesize KEY_USM06   = KEY_USM06;

+(EnrollmentViewController*)sharedInstance{
    if (sharedManager == nil) {
        sharedManager = [[EnrollmentViewController alloc] init];
        
        [sharedManager setPre_enrollment_info:[[NSMutableDictionary alloc] init]];
    }
    return sharedManager;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {//enrolment 3
        NSLog(@"Segue embed");
        _containerViewController                = segue.destinationViewController;
        _containerViewController.delegate       = self;
        _containerViewController.processFlow    = _processFlow;
        
    }//enrollment 10
    if ([segue.identifier isEqualToString:@"EnrollmentViewSegue"]) {
        NSLog(@"Enrollment segue");
        ((EnrollmentViewController *)segue.destinationViewController).processFlow    = EnrollmentProcess;
    }
}

- (IBAction)swapForward:(id)sender
{
    [_containerViewController swapViewControllers:YES];
    NSLog(@"Botón Continuar Presionado");
}

- (IBAction)swapBackward:(id)sender{
    [_containerViewController swapViewControllers:NO];

}

#pragma mark - ContainerEnrollmentDelegate

-(void) updateHeaderIndex:(NSString *) header_text{
    NSLog(@"Update header");
    [_lbl_header setText:header_text];
}

-(void) hideHeader{
    NSLog(@"Hide header");
    [_lbl_header setHidden:YES];
}

-(void) getBackMessageFromContainer{
    [self performSegueWithIdentifier:@"backToInitialView" sender:self];
}

-(void) getForwardMessageFromContainerWithMessage:(MessageFromEnrollmentStep)messageType{
    
    if (messageType == kSendLogin) {
        
        // Código correcto para login y parametros user=107400384&password=1234&language=SPA
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[[Session sharedManager].pre_session_info objectForKey:@"username"] forKey:@"user"];
        [params setObject:[[Session sharedManager].pre_session_info objectForKey:@"password"] forKey:@"password"];
        [params setObject:@"SPA"    forKey:@"language"];
        
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestLogin isPost:YES];
        [[LoadingView loadingViewWithMessage:@"validando Login"] show];

        
        
        // Código de pruebas (parámetros)
        /*
        [[RequestManager sharedInstance] setKeyToSend:@"token_usuario"];
        
        [self performSegueWithIdentifier:@"segueMainMenu" sender:nil];
         */
        
    }
    else
        if (messageType == kOpenConfirmation) {
        NSLog(@"Open Confirmation data view");
        NSLog(@"PreSession info: %@",[Session sharedManager].pre_session_info);
       // [self performSegueWithIdentifier:@"confirmationViewSegue" sender:nil]; //
        [self performSegueWithIdentifier:@"segueMainMenu" sender:nil]; //HOME
    }
    
    if (messageType == KTokenGenerate) {
        RadioButton *sender = [[RequestManager sharedInstance]sender];
        
        NSString * tokentype;
        
        sender.tag== 101? (tokentype=@"2"):(tokentype=@"1");
        
        // tokenType=2&actiPassDeviceModel=2&actiPassDeviceTypeId=2&enrollmentToken=AC232270&enrollmentOtpPin=0&language=SPA&enrollmentClientId=107399578
        NSMutableDictionary *params = [@{@"tokenType"            : tokentype,
                                        @"actiPassDeviceModel"   : @"2",
                                        @"actiPassDeviceTypeId"  : @"2",
                                        @"enrollmentToken"       : @"AC232270",
                                        @"enrollmentOtpPin"      : @"0",
                                        @"language"              : @"SPA",
                                        @"enrollmentClientId"    :[[Session sharedManager].pre_session_info objectForKey:@"username"],
                                        @"append_key"            :[[RequestManager sharedInstance] keyToSend]} mutableCopy];

        [RequestManager sharedInstance].delegate = self;
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KGenerateToken isPost:YES];  // SFT22

        
    }
    
    if (messageType == KEnrolmentQuestion) {

        NSString *keyUSM01 = [[RequestManager sharedInstance] keyToSend];
        NSString *language = @"language=SPA";
        NSMutableString *headerString = [NSMutableString string];
        [headerString appendString:[NSString stringWithFormat:@"%@%@", keyUSM01, language]];
        NSLog(@"headerString = %@",headerString);
        
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :headerString} mutableCopy ]  // PRA12.
                                                    toMethod:KSecretGetQuestion isPost:NO];
    }
    if (messageType == KImageQuestion) {

        NSString *keyUSM01 = [[RequestManager sharedInstance] keyToSend];
        NSString *language = @"language=SPA";
        NSMutableString *headerString = [NSMutableString string];
        [headerString appendString:[NSString stringWithFormat:@"%@%@", keyUSM01, language]];
        NSLog(@"headerString = %@",headerString);
        
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :headerString} mutableCopy ]  // PRA05
                                                    toMethod:KSecurityGetImage isPost:NO];

    }

    
    
    //if (messageType == KValidationChallenge) {
//        // sendingId=&newValueType=30189475&language=SPA&userId=107400384
//        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//        [params setObject:[[RequestManager sharedInstance] NewvalueType]                      forKey:@"newValueType"];
//        [params setObject:[[RequestManager sharedInstance] sendingid]                         forKey:@"sendingID"];
//        [params setObject:[[Session sharedManager].pre_session_info objectForKey:@"username"] forKey:@"userId"];
//        [params setObject:@"SPA"                                                              forKey:@"language"];
//        
       //[[RequestManager sharedInstance] setDelegate:self];
//        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KValidateChallenge isPost:YES];
       //[self performSegueWithIdentifier:@"segueMainMenu" sender:nil];
//        
  //  }
}

-(void)dismissAlertSuccesTransaction
{
    NSLog(@"Mostrar Inicio de Enrolamiento");
    [self performSegueWithIdentifier:@"confirmationViewSegue" sender:nil];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    [self registerForKeyboardNotifications];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self initSetup];
}

-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden   = YES;
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}

-(void)initSetup
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self registerForKeyboardNotifications];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Keyboard Notifications Methods

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = self.view.frame;
    
    CGFloat kbHeight = (keyboardSize.width>keyboardSize.height)? keyboardSize.height : keyboardSize.width;
    
    NSLog(@"%f",keyboardSize.width);
    NSLog(@"%f",keyboardSize.height);
    NSLog(@"%f",kbHeight);
    frame.origin.y = -250 + kbHeight;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    //
}
- (IBAction)modifyRegisterUser:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TouchNotification

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ResponseFromServicesDelegate

-(void)responseFromService:(NSMutableDictionary *)response{
    
    #warning Validate the result is nil (Network error)
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestLogin){
        [[RequestManager sharedInstance] setDicToSend:response];
        
        NSString *codeUSM01 = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"code"];
        NSLog(@"Codeusm01: %@",codeUSM01);
        
        
        KEY = [response objectForKey:@"key"];
        NSLog(@"KEY1: %@",KEY);
        [[RequestManager sharedInstance] setKeyToSend:KEY];         // User token saved!
        
    #warning Save the userID from response        
        [[RequestManager sharedInstance] setUserId:@"USER_ID"];     // User token saved!

        
        if ([codeUSM01  isEqual:@"BEADM0000001"]){ //BEADM0000001  // GAL00000001 para usar en el servicio real
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView close];
                [self performSegueWithIdentifier:@"segueMainMenu" sender:nil]; // HOME
                //[self performSegueWithIdentifier:@"EnrollmentViewSegue" sender:nil]; // Enrollment
              //[_containerViewController showTokenView]; // Token
            
            });
        }
        if ([[[response objectForKey:@"messages" ] objectAtIndex:0 ] isEqualToString:@"Ya existe una sesion activa."]){
            dispatch_async(dispatch_get_main_queue(), ^{
            NSString *messages =[[response objectForKey:@"messages" ] objectAtIndex:0 ] ;
            [LoadingView close];
            [self alertError:messages];
           });
        }
        if([[[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"] isEqualToString:@"Contraseña Invalida"]){
            // en este caso code = GAL0000100
            dispatch_async(dispatch_get_main_queue(), ^{
            NSString *messages = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"];
            [LoadingView close];
            [self alertError:messages];
            });
            
        }
        if([[[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"] isEqualToString:@"La cuenta esta bloqueada por exceso de intentos fallidos"]){  // en este caso code = GAL00000103
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *messages = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"];
                [LoadingView close];
                [self alertError:messages];
            });
            
        }
        
        if([[[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"] isEqualToString:@"USUARIO INEXISTENTE"]){  // en este caso code = GAL00000103
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *messages = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"];
                [LoadingView close];
                [self alertError:messages];
            });
            
        }
        if([[[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"] isEqualToString:@"El número de usuario es inválido"]){  // en este caso code = GAL0000100
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *messages = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"description"];
                [LoadingView close];
                [self alertError:messages];
            });
            
        }



        
        
        
        // codeUSM06 =[arUSM06 objectForKey:@"code"]
    }
    
   else if ([[response objectForKey:@"method"] isEqualToString:@"login"]) {
   //if ([[response objectForKey:@"method_code"] intValue] == kRequestLogin){
        NSString *code = [[[[response objectForKey:@"usrData"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"code"];
        NSLog(@"Code: %@",code);
        NSMutableDictionary    *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"0"                                                                   forKey:@"parameter"];
        [params setValue:@"0"                                                                   forKey:@"result"];
        [params setValue:@"SPA"                                                                 forKey:@"language"];
        [params setValue:[[Session sharedManager].pre_session_info objectForKey:@"username"]    forKey:@"customerId"];
        
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestEnrollmentStep isPost:YES];
       
       
       
       
    }
    else{
      
        NSLog(@"UMS06: %@",response);
    }
}

-(void)alertError :(NSString *)messages {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:messages delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
    [alert show];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InitialViewController *initialVC = [storyboard instantiateViewControllerWithIdentifier:@"inicio"];
    
    [self presentViewController:initialVC animated:YES completion:NULL];
    
}


@end
