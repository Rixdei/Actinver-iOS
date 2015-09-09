//
//  RegistersViewController.h
//  Actinver_iOS
//
//  Created by David on 04/08/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWithContractHeader.h"

@interface RegistersViewController : ViewControllerWithContractHeader{
    
    NSMutableArray * PickerData;
    UIPickerView * PickerView;
    NSArray * arrayServices;
}

@property int contract_type;
@property (nonatomic, strong)   NSMutableDictionary *contract_info;

@end
