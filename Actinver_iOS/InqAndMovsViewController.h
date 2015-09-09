//
//  InqAndMovsViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 17/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWithContractHeader.h"
#import "Utility.h"

@interface InqAndMovsViewController : ViewControllerWithContractHeader{
    
}
@property BOOL hiddeView;
@property int flow;
@property int contract_type;
@property (nonatomic, strong)   NSMutableDictionary *contract_info;

@property (nonatomic , strong) NSString * Month;
@property (nonatomic , strong) NSDateFormatter *todate;


@end
