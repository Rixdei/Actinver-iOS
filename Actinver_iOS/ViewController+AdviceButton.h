//
//  ViewController+AdviceButton.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 17/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "LoadingView.h"
#import "RequestManager.h"

@interface UIViewController(AdviceButton){
    

    
}

-(void)registerForKeyboardNotifications;
-(IBAction)openAdviceModalView:(id)sender;

@property (nonatomic, weak)             UITextField     *active_txt;
@property (nonatomic, weak) IBOutlet    UIScrollView    *scrll_view;

@property BOOL hiddeView;



@end
