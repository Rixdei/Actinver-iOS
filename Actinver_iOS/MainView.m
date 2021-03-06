//
//  MainView.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "MainView.h"
#import "NavDrawerContainer.h"

#import <MMDrawerController/UIViewController+MMDrawerController.h>

@interface MainView ()

@property (nonatomic, weak) NavDrawerContainer *containerViewController;

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"embebedContainer"]) {
        _containerViewController    = segue.destinationViewController;
    }
}

-(IBAction)toggleDrawer:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)enterSectionWithIdentifier:(int)identifier{
    [_containerViewController performSegueWithIdentifier:[NSString stringWithFormat:@"%d",identifier]
                                                  sender:nil];
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
