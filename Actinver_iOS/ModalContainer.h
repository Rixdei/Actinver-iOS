//
//  ModalContainer.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 03/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@protocol MessagesFromContainerToModalDelegate <NSObject>
    - (void)passToNextStep:(NSDictionary *)aditionalData;
    - (void)cancelDataEntry;
    - (void)passKeyboardShowEvent:(float)key_height txt_height:(CGRect)txt_frame;
@end

@interface ModalContainer : UIViewController{
    
}

@property                       int                                         current_position;
@property                       ContainerModalType                          kModalType;
@property (nonatomic, strong)   NSMutableDictionary                         *aditional_data;
@property (nonatomic, weak)     id<MessagesFromContainerToModalDelegate>    delegate;

@end
