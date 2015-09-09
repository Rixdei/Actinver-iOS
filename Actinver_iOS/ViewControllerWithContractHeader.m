//
//  ViewControllerWithContractHeader.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ViewControllerWithContractHeader.h"

@interface ViewControllerWithContractHeader ()<ContractHeaderDelegate>

@end

@implementation ViewControllerWithContractHeader

@synthesize page_controller = _page_controller;

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr_contracts          = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ContractHeaderDelegate

-(void)getCurrentToken:(NSString *)token inContractIndex:(int)index inPageViewCtrWithTag:(int)tag{
    NSLog(@"Protocol Base");
}

-(void)getCurrentIndexInPageViewController:(int)index{
    
}

-(void)setUpContractHeaderWithPageCtrl: (UIPageViewController*)pageViewCtrl inView:(UIView*)view
                           andDelegate:(ContractHeaderPageViewCtrlDelegate*)delegate{
    
    [[pageViewCtrl view] setFrame:[view bounds]];
    [view addSubview:[pageViewCtrl view]];
    [pageViewCtrl didMoveToParentViewController:self];
    
    pageViewCtrl.delegate           = delegate;
    pageViewCtrl.dataSource         = delegate;
    
    ContractHeader *firstContract   = [delegate viewControllerAtIndex:0];
    NSArray *viewControllers        = @[firstContract];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)setUpBaseHeader{
    
    _page_controller = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                     options:nil];
    [[_page_controller view] setTag:kMasterHeader];
    _page_ctrl_delegate             = [[ContractHeaderPageViewCtrlDelegate alloc] initDelegateWithContracts:_arr_contracts];
    _page_ctrl_delegate.delegate    = self;
    
    [self setUpContractHeaderWithPageCtrl:_page_controller
                                   inView:_headerContainer
                              andDelegate:_page_ctrl_delegate];
    
    ContractHeader *firstContract = [_page_ctrl_delegate viewControllerAtIndex:0];
    NSArray *viewControllers = @[firstContract];
    [_page_controller setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

-(NSMutableDictionary *)updateTokenIncontractHeader:(NSString *)token{
    [_page_ctrl_delegate updateTokenInCurrentIndex:token];
    return [self getCurrentContract];
}

-(NSMutableDictionary *)getCurrentContract{
    return [[_arr_contracts objectAtIndex:[_page_ctrl_delegate contract_index]] objectAtIndex:[_page_ctrl_delegate current_index]];
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
