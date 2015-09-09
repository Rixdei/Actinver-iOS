//
//  ChallengeViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 25/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewController+CancelAction.h"
#import "Container.h"

@interface ChallengeViewController : UIViewController{
    
}

@property (nonatomic, strong)   NSDictionary                    *challenge_info;
@property (nonatomic, strong)   NSMutableArray                  *trans_data;
@property BOOL Cancel;

@end
