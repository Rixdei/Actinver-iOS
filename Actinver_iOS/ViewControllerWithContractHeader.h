//
//  ViewControllerWithContractHeader.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController+AdviceButton.h"
#import "ContractHeaderPageViewCtrlDelegate.h"

@interface ViewControllerWithContractHeader : UIViewController{
    
}

-(void)setUpBaseHeader;
-(void)setUpContractHeaderWithPageCtrl: (UIPageViewController*)pageViewCtrl inView:(UIView*)view
                           andDelegate:(ContractHeaderPageViewCtrlDelegate*)delegate;
-(NSMutableDictionary *)updateTokenIncontractHeader:(NSString *)token;
-(NSMutableDictionary *)getCurrentContract;

@property int flow;
@property (nonatomic, weak)     IBOutlet    UIView                              *headerContainer;
@property (nonatomic, strong)               UIPageViewController                *page_controller;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate;
@property (nonatomic, strong)               NSMutableArray                      *arr_contracts;

@end
