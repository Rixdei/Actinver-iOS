//
//  NavigationDrawer.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "NavigationDrawer.h"

@interface NavigationDrawer ()

@end

@implementation NavigationDrawer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitApplication{
    [self performSegueWithIdentifier:@"unwindExitApplication" sender:self];
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
