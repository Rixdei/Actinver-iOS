//
//  ChangeContractAliasEmbebedViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 04/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbebedViewController.h"

@interface ChangeContractAliasEmbebedViewController : EmbebedViewController{

    NSString *key;
    NSString*contracts;
    NSString * tippServicio;
    NSString * empresa;

}

@property (nonatomic, strong) NSMutableDictionary  *contract_info;


@end
