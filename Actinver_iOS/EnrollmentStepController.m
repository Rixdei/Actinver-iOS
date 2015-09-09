//
//  EnrollmentStepController.m
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "EnrollmentStepController.h"
#import "CustomizeControl.h"
#import "Session.h"
#import "LoginImageElement.h"
#import "RadioButton.h"
#import "SecurityImageSelector.h"
#import "RequestManager.h"
#import "LoadingView.h"

@interface EnrollmentStepController () <UITextFieldDelegate,ImageSelectorResponse,UIPickerViewDelegate, UIPickerViewDataSource,ResponseFromServicesDelegate>
@property (nonatomic, weak) IBOutlet    UITextField *generic_txt;
@property (nonatomic, strong)           NSString    *dict_key;
@property (nonatomic, strong)           NSString    *dict_val;

@property (nonatomic, strong)           UIPickerView * pickerViewQuestions;


@end

@implementation EnrollmentStepController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Step controller: %d",_enrollment_step);
    
    [self initSetup];
    arrayOfPicker = [[NSMutableArray alloc] init];
    [self arrayQuestionList:nil];
    [self addElementsOfPicker];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self initSetup];
//    arrayOfPicker = [[NSMutableArray alloc] init];
//    [self addElementsOfPicker];
    
    NSString *hint;
    
    if (_processFlow == EnrollmentProcess) {
        
        if (_enrollment_step == 7) {
            _dict_key   = @"sec_image";
        }
        else{
            _generic_txt   = (UITextField *)[self.view viewWithTag:1];
            NSMutableArray *quest = [[NSMutableArray alloc] init];
            switch (_enrollment_step) {
                    
                case 0:
                    _dict_key   = @"numero_serie";
                    hint        = @"Ej. AE90XXX";
                    [(RadioButton *)[self.view viewWithTag:101] setSelected:YES];
                    break;

                case 1:
                    _dict_key   = @"old_password";
                    hint        = @"contraseña actual";
                    break;

                case 2:
                    _dict_key   = @"new_password";
                    hint        = @"contraseña nueva";
                    break;

                case 3:
                    _dict_key   = @"new_password_1";
                    hint        = @"contraseña nueva";
                    break;
                    
                case 4:
                    _dict_key   = @"secret_question";
                    hint        = @"pregunta secreta";
                    
                    quest=[[RequestManager sharedInstance] questionList];
                    _generic_txt.text = [quest  objectAtIndex:0];
                   // [_generic_txt setDelegate:self];
                    break;
                    
                case 5:
                    _dict_key   = @"answer_secret_question";
                    hint        = @"respuesta a pregunta secreta";
                    break;

                case 6:
                    _dict_key   = @"hint_secret_question";
                    hint        = @"pista para pregunta secreta";
                    break;

                case 8:
                    _dict_key   = @"email";
                    hint        = @"correo electrónico";
                    break;

                case 9:
                    _dict_key   = @"phone_number";
                    hint        = @"10 dígitos";
                    //[_generic_txt setDelegate:self];
                    break;
                    
//                case 9:
//                    _dict_key   = @"phone_numbersss";
//                    hint        = @"10 dígitos";
//                    [_generic_txt setDelegate:self];
//                    break;
                default:
                    break;
            }
            [CustomizeControl setPlaceHolderForUITextFieldInEnrollment:_generic_txt
                                                              WithText:hint];
        }
    }
    else{
        switch (_enrollment_step) {
            case 0:
                
                _dict_key   = @"username";
                hint        = @"Ingrese Cliente Único";
                [_generic_txt setDelegate:self];
                //return false;
    
                break;
        
            case 1:
                _dict_key   = @"password";
                hint        = @"Ingrese contraseña";
                break;
                
            case 2:
                [[RequestManager sharedInstance] setDelegate:self];
                _dict_key   = @"token";
                hint        = @"Introduzca Token";
                break;
                
            default:
                break;
        }
        _generic_txt            = (UITextField *)[self.view viewWithTag:1];
        [CustomizeControl setPlaceHolderForUITextFieldInEnrollment:_generic_txt
                                                          WithText:hint];
    }
}

- (void) initSetup
{
    _pickerViewQuestions = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, 320, 250)];
    _pickerViewQuestions.dataSource = self;
    _pickerViewQuestions.delegate = self;
  [_pickerViewQuestions setShowsSelectionIndicator:YES];
    [self.questionSecurityTextField setInputView:_pickerViewQuestions];
    
}

- (void) addElementsOfPicker
{
    arrayOfPicker =[[RequestManager sharedInstance] questionList];
    
/*    [arrayOfPicker addObject:@"¿Primer equipo de futbol?"];
    [arrayOfPicker addObject:@"¿Mi color favorito?"];
    [arrayOfPicker addObject:@"¿Nombre de mi mascota?"];
    [arrayOfPicker addObject:@"¿Mi deporte preferido?"];
    [arrayOfPicker addObject:@"¿Mi primer escuela?"];
 */
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    arrayOfPicker =[[RequestManager sharedInstance]questionList];
    return [arrayOfPicker count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    arrayOfPicker =[[RequestManager sharedInstance]questionList];
    return [arrayOfPicker objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{   arrayOfPicker =[[RequestManager sharedInstance]questionList];
    self.questionSecurityTextField.text = [arrayOfPicker objectAtIndex:row];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) validateStepFields{
    
    if (_processFlow == LoginProcess) {
        if (_enrollment_step == 0) {
            
            if (_generic_txt.text.length < 7) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                           message:@"El número de usuario debe ser de 7 a 11 dígitos."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            return false;
            
        }else if(_generic_txt.text.length > 11){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                           message:@"El número usuario debe ser de 7 a 11 dígitos."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            return false ;
            
        }
    }

        
        if ([[_generic_txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]   isEqualToString:@""]) {
            NSLog(@"Empty user field");
            if (_enrollment_step == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"El campo de usuario esta vacio."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                NSLog(@"EL CAMPO DE USUARIO ESTA VACIO");
                
            }else if (_enrollment_step == 1){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"El campo de contraseña esta vacio."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"Campo vacio, ingrese token por favor."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }

            return false;
        }

        else{
            _dict_val   = _generic_txt.text;
            [[Session sharedManager].pre_session_info setObject:_dict_val
                                                         forKey:_dict_key];
        }
    }
    else{
        if ([[_generic_txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            
            NSLog(@"Empty field");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"El campo está vacio"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            return false;
            
            
        }
        else{
            NSString    *aux = _dict_val;
            _dict_val        = _generic_txt.text;
            
            switch (_enrollment_step) {
                case 0:
                    _dict_val   = @"semilla";
                    break;
                    
                case 1:
                    if (![_generic_txt.text isEqualToString:[[Session sharedManager].pre_session_info objectForKey:@"password"]]){
                        NSLog(@"Old Password confirmation failed");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                                       message:@"La contraseña actual no coincide con la contraseña de sesión"
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                        return false;
                    }
                    break;
                    
                case 2:
                    
                    if ((_generic_txt.text.length <8) ) {
                        [self uialert];
                        return false;
                        
                    }else if(_generic_txt.text.length>11){
                        [self uialert];
                        return false;
                        
                    }
                    break;

                case 3:
                    if (![_generic_txt.text isEqualToString:[[Session sharedManager].pre_session_info objectForKey:@"new_password"]]){
                        NSLog(@"New Password confirmation failed");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                                       message:@"La nueva contraseña y la validación no coinciden, por favor validar la contraseña introducida."
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                        return false;
                    }
                    break;
                case 7 :
                    _dict_val   = aux;
                    break;
                case 8 :
                    if(![self isValidEmail:_generic_txt.text])
                    {
                        NSLog(@"Email Invalid");
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                                       message:@"Email invalido."
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                        return false;
                    }
                    break;
                case 9 :
                    if ([_generic_txt.text length] != 10){
                        NSLog(@"Incorrect phone number");
                        
                        if ((_generic_txt.text.length <10) ) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                                           message:@"El número telefónico debe ser de 10 digitos."
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];                            return false;
                            
                        }else if(_generic_txt.text.length>10){
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención"
                                                                           message:@"El número telefónico debe ser de 10 digitos."
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];                            return false;
                            
                        }

                        
                        //return false;
                    }
                    break;
                    
                default:
                    break;
            }
            
            [[Session sharedManager].pre_session_info setObject:_dict_val
                                                         forKey:_dict_key];
        }
    }

    return true;
}

-(IBAction)onRadioButtonValueChanged:(RadioButton*)sender
{
    NSLog(@"Radio group changed");
    
    for (int i=201; i<1001; i+=100)
        [self.view viewWithTag:i].hidden = (sender.tag != 101);
    
    for (int i=202; i<1002; i+=100)
        [self.view viewWithTag:i].hidden = (sender.tag != 102);
    
    [[RequestManager sharedInstance]setSender:sender];
    
    if (sender.tag ==102) {//softToken

        NSMutableDictionary *params = [@{@"languaje"    : @"SPA",
                                         @"clientId"    : [[Session sharedManager].pre_session_info objectForKey:@"username"],
                                         @"append_key"  : [[RequestManager sharedInstance] keyToSend]}mutableCopy];
        
        [[LoadingView loadingViewWithMessage:@"Generando Clave"]show ];
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KSemillaToken isPost:YES];  // SFT19
    }
}

-(IBAction)openImageSelector:(id)sender{
    NSLog(@"Opening");
    [self performSegueWithIdentifier:@"imageSelectionSegue"
                              sender:nil];
}

-(void) updateImage:(NSString *)imageName{
    [(UIButton *)[self.view viewWithTag:403] setBackgroundImage:[UIImage imageNamed:imageName]
                                                       forState:UIControlStateNormal];
    _dict_val   = imageName;
}

-(BOOL) isValidEmail:(NSString *)email
{
    BOOL filter = NO;
    NSString *stringAccepted = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? stringAccepted : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"Length: %lu",(unsigned long)newString.length);
//    return (newString.length<=11);
//    
//
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if([textField.text length]<=4){
        [textField resignFirstResponder];
        return YES;
    }
    else
        return NO;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.view endEditing:YES];
//    return YES;
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"imageSelectionSegue"]){
        SecurityImageSelector *aux  = (SecurityImageSelector *)segue.destinationViewController;
        aux.delegate                = self;
    }
}
-(void)responseFromService:(NSMutableDictionary *)response{
    
    NSLog(@"si esta entrando a token %@",response);
    
    dispatch_async(dispatch_get_main_queue(), ^{
         _softTokenLabel.text=[[response objectForKey:@"outPolicyMobilePassCreation"] objectForKey:@"policyMobilePass"];
        [LoadingView close];
     });
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *sft23 =[[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"];
        _tokenTextField.text= [sft23 substringFromIndex:2];
    });
    
    
    NSMutableDictionary *newvalueType =[[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"newValueType"];
    [[RequestManager sharedInstance] setNewvalueType:newvalueType];
    NSMutableDictionary *sendingid =[[response objectForKey:@"outTokenChallengeByClientRequest"] objectForKey:@"sendingID"];
    [[RequestManager sharedInstance] setSendingid:sendingid];
    
    NSDictionary * quetinList =  [response objectForKey:@"outSecretQuestionListQuery"];
    NSLog(@"quetinList %@",quetinList);
    
    //[[RequestManager sharedInstance]setQuestionList:response];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self arrayQuestionList:quetinList];
    });
    
    
    [LoadingView close];


}
-(void)uialert{
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Atención"
                                                   message:@"La contraseña debe tener una longitud entre 8 y 11 caracteres"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"ok", nil];
    [alert show];
}

-(void)arrayQuestionList: (NSDictionary *) questionList{
    
    for (int i=0; i<[[questionList objectForKey:@"secretQuestionList" ] count] ; i++) {
        NSString *arrayQuestionList = [[[questionList objectForKey:@"secretQuestionList" ] objectAtIndex:i] objectForKey:@"secretQuestion"];
        NSLog(@"arrayQuestion list : %@",arrayQuestionList);
        [arrayOfPicker addObject:arrayQuestionList];
        [[RequestManager sharedInstance ] setQuestionList:arrayOfPicker];
        [_pickerViewQuestions reloadAllComponents];
        
    }
}

#pragma mark -> Disable "copy-paste"
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}



@end
