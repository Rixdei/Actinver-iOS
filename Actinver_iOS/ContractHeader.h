//
//  ContractHeader.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractHeader : UIViewController

@property                       int             header_type;
@property                       NSUInteger      pageIndex;
@property (nonatomic, strong)   NSDictionary    *contract_info;
@property (nonatomic, strong)   NSString        *contract_token;

@end
