//
//  ContractHeaderPageViewCtrlDelegate.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractHeader.h"

@protocol ContractHeaderDelegate <NSObject>

-(void)getCurrentToken:(NSString *)token inContractIndex:(int)index inPageViewCtrWithTag:(int)tag;

@end

@interface ContractHeaderPageViewCtrlDelegate : NSObject<UIPageViewControllerDataSource,UIPageViewControllerDelegate>{
    
}

- (instancetype)initDelegateWithContracts:(NSMutableArray *)contracts;
- (ContractHeader *)viewControllerAtIndex:(NSUInteger)index;
- (ContractHeader *)getCurrentController;
- (void)updateToken:(NSString *)token inHeaderIndex:(int)index;
- (void) updateTokenInCurrentIndex:(NSString *)token;
- (NSDictionary *)getCurrentContract;


@property                       int                         contract_index; // Global index for multiple contracts list
@property                       int                         current_index;
@property                       int                         header_type;
@property (nonatomic, weak)     id<ContractHeaderDelegate>  delegate;
@property (nonatomic, strong)   NSMutableArray              *arr_contracts;
@property (nonatomic, strong)   NSMutableArray              *arr_headers;

@property                       NSRange                     *range;

@end
