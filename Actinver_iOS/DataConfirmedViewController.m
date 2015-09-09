//
//  DataConfirmedViewController.m
//  Actinver-IOS
//
//  Created by Raul Galindo Hernandez on 4/1/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "DataConfirmedViewController.h"
#import "Session.h"
#import "RequestManager.h"

@interface DataConfirmedViewController ()

@property (nonatomic, weak) IBOutlet    UIScrollView    *scrollView;
@property (nonatomic, weak) IBOutlet    UIView          *base_txt_token;

@property (weak, nonatomic) IBOutlet UILabel *nameuser;
@property (weak, nonatomic) IBOutlet UILabel *typeToken;
@property (weak, nonatomic) IBOutlet UILabel *serial_number;      // numero_serie
@property (weak, nonatomic) IBOutlet UILabel *password;           // new_password
@property (weak, nonatomic) IBOutlet UILabel *secret_question;    // secret_question
@property (weak, nonatomic) IBOutlet UILabel *answer_question;    // answer_secret_question
@property (weak, nonatomic) IBOutlet UILabel *hint_question;      // hint_secret_question
@property (weak, nonatomic) IBOutlet UIImageView *sec_Image;      // sec_image
@property (weak, nonatomic) IBOutlet UILabel *email;              // email
@property (weak, nonatomic) IBOutlet UILabel *phone_Number;       // phone_number


@end

@implementation DataConfirmedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    
    NSString  *typeToken, *serialNumber, *newPass, *secretQuestion,  *answerQuestion, *hintQuestion, *secImage, *Email, *phoneNumber;
    
    
    [[RequestManager sharedInstance] dicToSend];
    NSLog(@" diccionario confrimacion %@",[[RequestManager sharedInstance] dicToSend]);
    
    
    NSLog(@"PreSession info: %@",[Session sharedManager].pre_session_info);
    NSDictionary * dic =[Session sharedManager].pre_session_info;
    
    NSString *nombre =[[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"nombre"];
    //NSLog(@"nombre: %@",nombre);
    NSString *apaterno =[[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"apaterno"];
    //NSLog(@"aparteno: %@",apaterno);
    NSString *amaterno =[[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"amaterno"];
    //NSLog(@"aparteno: %@",amaterno);
    NSMutableString* user = [[NSMutableString alloc] initWithFormat:@"%@ %@ %@",nombre,apaterno,amaterno];
    //NSLog(@"User: %@", user);
    
    serialNumber   = [dic objectForKey:@"numero_serie"];
    newPass        = [dic objectForKey:@"new_password"];
    secretQuestion = [dic objectForKey:@"secret_question"];
    answerQuestion = [dic objectForKey:@"answer_secret_question"];
    hintQuestion   = [dic objectForKey:@"hint_secret_question"];
    secImage       = [dic objectForKey:@"sec_image"];
    Email          = [dic objectForKey:@"email"];
    phoneNumber    = [dic objectForKey:@"phone_number"];
    
    _nameuser.text= user;
    _serial_number.text   = serialNumber;
    _password.text        = newPass;
    _secret_question.text = secretQuestion;
    _answer_question.text = answerQuestion;
    _hint_question.text   = hintQuestion;
    _email.text           = Email;
    _phone_Number.text    = phoneNumber;
    _sec_Image.image      =[UIImage imageNamed:secImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Keyboard Notifications Methods

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
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
    
    [_scrollView setContentOffset:CGPointMake(0, kbHeight*.5) animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //
}

#pragma mark - TouchNotification

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
