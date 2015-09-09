//
//  EmbebedViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 04/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagesFromControllerToContainerDelegate <NSObject>

    - (void)passKeyboardShowEvent:(float)key_height txt_height:(CGRect)txt_frame;

    - (void)passToNextStep:(NSDictionary *)aditionalData;
    - (void)backToPreviousStep:(NSDictionary *)aditionalData;
    - (void)cancelDataEntry;
@end

@interface EmbebedViewController : UIViewController{
    
}

@property (nonatomic, strong)   NSMutableDictionary                             *aditional_data;
@property (nonatomic, weak)     id<MessagesFromControllerToContainerDelegate>   delegate;

@end
