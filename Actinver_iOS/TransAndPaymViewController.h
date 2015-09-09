//
//  TransAndPaymViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWithContractHeader.h"

@interface TransAndPaymViewController : ViewControllerWithContractHeader

@property int contract_type;
@property (nonatomic, strong)   NSMutableDictionary *contract_info;


@end
