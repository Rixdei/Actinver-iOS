//
//  ModalViewController+CancelAction.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 25/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ModalViewController+CancelAction.h"

@implementation UIViewController(CancelAction)


@dynamic delegate;
@dynamic Cancel;


-(IBAction)cancelDataEntry:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self.delegate notifyDataEntryWasCancelled];
                             }];
}

@end
