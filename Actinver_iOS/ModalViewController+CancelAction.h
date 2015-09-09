//
//  ModalViewController+CancelAction.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 25/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@protocol NotifyModalEventsDelegate <NSObject>

-(void) notifyDataEntryWasCancelled;
-(void) notifyDataEntryEnteredInfo:(NSMutableDictionary *)info;

@optional
-(void) notifyReturnToMainViewWithMessage:(MessageFromEnrollmentStep)messageType;

@end

@interface UIViewController(CancelAction){
    
}
@property BOOL Cancel;
@property (nonatomic, weak) id<NotifyModalEventsDelegate> delegate;

@end
