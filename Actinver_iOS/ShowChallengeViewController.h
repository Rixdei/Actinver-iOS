//
//  ShowChallengeViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 25/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewController+CancelAction.h"

@interface ShowChallengeViewController : UIViewController{
    
}

@property (nonatomic, strong)   NSDictionary    *challenge_info;
@property (nonatomic, strong)   NSDictionary    *folio_info;
@property (nonatomic, strong)   NSMutableArray  *trans_array;
@property (nonatomic, assign)   id<NotifyModalEventsDelegate>   delegate;

@end
