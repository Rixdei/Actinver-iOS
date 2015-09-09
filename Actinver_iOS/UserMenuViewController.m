//
//  UserMenuViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 22/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "UserMenuViewController.h"
#import "Utility.h"

@interface UserMenuViewController ()

@end

@implementation UserMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

-(IBAction)openUserMenuOption:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                     [_delegate openSubMenu:(int)sender.tag];
                             }];
//    if (sender.tag == 103) {
//        UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Módulo en Desarrollo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [Alert show];
//        return;
//    }

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
