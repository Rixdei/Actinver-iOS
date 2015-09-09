//
//  NavDrawerContainer.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "NavDrawerContainer.h"

@interface NavDrawerContainer ()

@property (strong, nonatomic)   NSMutableArray              *controllers_array;

@end

@implementation NavDrawerContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _child_number       = 4;
    _current_position   = 0;
    
    _controllers_array  = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++)
        [_controllers_array addObject:[NSNull null]];

    [self performSegueWithIdentifier:@"0"
                              sender:nil];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Container start //
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    _current_position = [segue.identifier intValue];
    
    [_controllers_array replaceObjectAtIndex:_current_position withObject:segue.destinationViewController];
    
    UIViewController    *viewCtrl    =  segue.destinationViewController;
    [self addChildViewController:viewCtrl];
    UIView  *destView           = ((UIViewController *)viewCtrl).view;
    destView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:destView];
    [segue.destinationViewController didMoveToParentViewController:self];
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
