//
//  Container.h
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 25/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@protocol ContainerEnrollmentDelegate <NSObject>

    -(void) updateHeaderIndex:(NSString *) header_text;
    -(void) hideHeader;
    -(void) getBackMessageFromContainer;
    -(void) getForwardMessageFromContainerWithMessage:(MessageFromEnrollmentStep)messageType;

@end

@interface Container : UIViewController

- (void)swapViewControllers:(BOOL) isForward;
@property                       int                                 current_position;
@property (weak, nonatomic)     id<ContainerEnrollmentDelegate>     delegate;
@property                       int                                 child_number;
@property ProcessFlow   processFlow;

@property (nonatomic, strong)   NSMutableDictionary                 *additionalData;
@property (nonatomic, strong)   NSMutableArray                      *additionalDataArray;


- (void)showTokenView;

@end
