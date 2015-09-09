//
//  EmbebedViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 04/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "EmbebedViewController.h"

@interface EmbebedViewController ()

@property (nonatomic, weak) UITextField *active_txt;

@end

@implementation EmbebedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)cancelDataEntry:(id)sender{
    [_delegate cancelDataEntry];
}

#pragma mark - UItextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.active_txt = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.active_txt = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}


#pragma mark - Keyboard Notifications

- (void)registerForKeyboardNotifications {
    NSLog(@"Registered");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info  = [aNotification userInfo];
    CGSize kbSize       = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.delegate passKeyboardShowEvent:kbSize.height
                              txt_height:_active_txt.frame];
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
