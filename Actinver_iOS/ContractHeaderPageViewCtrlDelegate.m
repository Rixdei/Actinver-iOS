//
//  ContractHeaderPageViewCtrlDelegate.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ContractHeaderPageViewCtrlDelegate.h"
#import "Utility.h"

@interface ContractHeaderPageViewCtrlDelegate ()

@end

@implementation ContractHeaderPageViewCtrlDelegate

-(instancetype)initDelegateWithContracts:(NSMutableArray *)contracts{
    self = [super init];
    if (self) {
        _arr_contracts      = contracts;
        _arr_headers        = [[NSMutableArray alloc] init];
        _current_index      = 0;
        _contract_index     = 0;            // Global index (the master contract index)
        
        NSMutableArray *aux_headers = [[NSMutableArray alloc] init];
        for (NSObject *obj in [_arr_contracts objectAtIndex:_contract_index])   // The first master contract, requires n slots contracts
            [aux_headers   addObject:[NSNull null]];

        [_arr_headers addObject:aux_headers];                                   // First contract (_contract index 0)
    }
    return self;
}

- (void)updateToken:(NSString *)token inHeaderIndex:(int)index{
    ContractHeader *header      = [[_arr_headers objectAtIndex:_contract_index] objectAtIndex:index];
    header.contract_token       = token;
    
}

#pragma mark - Page View Controller Data Source

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    ContractHeader *currentHeader   = [pageViewController.viewControllers objectAtIndex:0];
    
    _current_index                  = (int)currentHeader.pageIndex;
    NSLog(@"Current Header index = %d", _current_index);
    
    if (_header_type == kMasterHeader) {
        NSLog(@"Update the current token in master");
        [_delegate getCurrentToken:currentHeader.contract_token inContractIndex:_current_index inPageViewCtrWithTag:(int)[pageViewController view].tag];
    }
    else{
        NSLog(@"Contract array: %@",_arr_contracts);
            [_delegate getCurrentToken:currentHeader.contract_token inContractIndex:_current_index inPageViewCtrWithTag:(int)[pageViewController view].tag];
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContractHeader*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
    
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContractHeader*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    NSLog(@"contract_index: %d",_contract_index);
    NSLog(@"index: %ld",index);

    index++;
    if (index == [[_arr_contracts objectAtIndex:_contract_index] count]) {
        return nil;

    }
    return [self viewControllerAtIndex:index];
}

- (ContractHeader *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"Contracts: %@",_arr_contracts);
    
//    if ((index >= [[_arr_contracts objectAtIndex:_contract_index] count]) || (index >= [[_arr_contracts objectAtIndex:_contract_index] count])) {
    if ((index >= [[_arr_contracts objectAtIndex:_contract_index] count])) {

        return nil;
    }


   if ([[_arr_headers objectAtIndex:0] objectAtIndex:index] == [NSNull null]) {  // Create a new header and add it to the header array

    // Create a new view controller and pass the contract data.
        ContractHeader *header  = [[ContractHeader alloc] init];
        
        header.contract_info    = [[_arr_contracts objectAtIndex:_contract_index] objectAtIndex:index];
        header.pageIndex        = index;
        header.header_type      = _header_type;
        [[_arr_headers objectAtIndex:0 ] insertObject:header atIndex:index];
    }
    return [[_arr_headers objectAtIndex:0 ] objectAtIndex: index];
}

- (ContractHeader *)getCurrentController{
    return [[_arr_headers objectAtIndex:_contract_index ] objectAtIndex: _current_index];
}

- (NSDictionary *)getCurrentContract{
    return [[_arr_contracts objectAtIndex:_contract_index ] objectAtIndex: _current_index];
}

- (void) updateTokenInCurrentIndex:(NSString *)token{
    [self updateToken:token inHeaderIndex:_current_index];
}
@end
