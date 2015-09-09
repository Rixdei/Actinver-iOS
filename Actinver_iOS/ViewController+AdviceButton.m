//
//  ViewController+AdviceButton.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 17/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ViewController+AdviceButton.h"
#import "AdviceViewController.h"

@implementation UIViewController(AdviceButton)

@dynamic scrll_view;
@dynamic active_txt;
@dynamic hiddeView;


-(IBAction)openAdviceModalView:(id)sender{
    AdviceViewController    *aux = [[AdviceViewController alloc] init];
    [self presentViewController:aux
                       animated:YES
                     completion:nil];
    //self.hiddeView = YES;

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Keyboard Notifications Methods

- (void)registerForKeyboardNotifications {
    NSLog(@"Registered");
    
    [self addKeyboardOnTouchDismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info  = [aNotification userInfo];
    CGSize kbSize       = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets              = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrll_view.contentInset            = contentInsets;
    self.scrll_view.scrollIndicatorInsets   = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.active_txt.frame.origin) ) {
        [self.scrll_view scrollRectToVisible:self.active_txt.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"Hiding");
    //UIEdgeInsets contentInsets              = UIEdgeInsetsZero;
    
    UIEdgeInsets contentInsets              = UIEdgeInsetsMake(0.0,
                                                               0.0,
                                                               self.navigationController.navigationBar.frame.size.height,
                                                               0.0);
    self.scrll_view.contentInset            = contentInsets;
    self.scrll_view.scrollIndicatorInsets   = contentInsets;
}

- (void) addKeyboardOnTouchDismiss{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrll_view addGestureRecognizer:tap];
}

#pragma mark - TouchNotification

-(void) dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UItextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.active_txt = textField;
    NSLog(@"Text_field y: %f",textField.frame.origin.y);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.active_txt = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

@end
