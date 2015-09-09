//
//  TransAndPaymViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 23/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "TransAndPaymViewController.h"
#import "RadioButton.h"
#import "ModalEntryDataViewController.h"
#import "ConfirmDataViewController.h"
#import "RequestManager.h"
#import "CustomizeControl.h"

#define kActinverTagRadioButton     401
#define kOtherBanksTagRadioButton   402
#define kServicesTagRadioButton     401
#define kAirTimeTagRadioButton      402

#define AMOUNT_LENGTH               10

@interface TransAndPaymViewController ()<ResponseFromServicesDelegate,ContractHeaderDelegate,NotifyModalEventsDelegate,
                                         UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

// Transfers (Own contracts)
@property (nonatomic, weak)     IBOutlet    UIView                              *headerContainer_slave;
@property (nonatomic, strong)               UIPageViewController                *page_controller_slave;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate_slave;

// Transfers (Other banks)
@property (nonatomic, strong)               UIPageViewController                *page_controller_otherBanks;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate_otherBanks;

@property (nonatomic, strong)               UIPageViewController                *page_controller_PayCredit;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate_PayCredit;

@property (nonatomic, strong)   IBOutlet    UICollectionView                    *collection_services;

@property (nonatomic, strong)               NSMutableArray                      *arr_act_accounts;
@property (nonatomic, strong)               NSMutableArray                      *arr_other_banks;
@property (nonatomic, strong)               NSMutableArray                      *arr_user_services;
@property (nonatomic, strong)               NSMutableArray                      *arr_basic_services;
@property (nonatomic, strong)               NSMutableArray                      *arr_pay_credit;


@property                                   int master_index;
@property                                   int slave_index;

@property                                   int services_selected_index;

@property (nonatomic, weak)     IBOutlet    UISwitch                            *swi_notify_user;

@property (nonatomic, assign)               UITextField     *active_txt;
@property (nonatomic, assign) IBOutlet      UIScrollView    *scrll_view;

@property (weak, nonatomic) IBOutlet UIButton *Add_Service;

@property (weak, nonatomic) IBOutlet UIImageView *rigth_button;
@property (weak, nonatomic) IBOutlet UIImageView *left_button;

@property (weak, nonatomic) IBOutlet UIImageView *rigth_button_slave;
@property (weak, nonatomic) IBOutlet UIImageView *left_button_slave;


@end

@implementation TransAndPaymViewController{
    UITextField * Amount;
    UITextField * Concept;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initializeView];
    _left_button.hidden=YES;
    _left_button_slave .hidden = YES;
    
    [(UILabel*)[self.view viewWithTag:3004]setText:@"Detalles del Pago"];
    [(UILabel*)[self.view viewWithTag:3005] setHidden:YES];
    [(UITextField*)[self.view viewWithTag:3006] setHidden:YES];
    [[self.view viewWithTag:1004] setHidden: YES];
    
    NSAttributedString *verifDig = [[NSAttributedString alloc] initWithString:@"     Insertar Dígito" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:3006] setAttributedPlaceholder:verifDig];

}

- (void) initializeView{
    

    [self.arr_contracts removeAllObjects];
   

    _master_index               = _slave_index  = 0;
    
    _page_controller_slave      = nil;
    
    _arr_basic_services         = nil;
    
    _services_selected_index    = 0;
    
    
    [(RadioButton *)[self.view viewWithTag:kActinverTagRadioButton] setSelected:YES];
 
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [(UITextField*)[self.view viewWithTag:1001] setText:@""];
    [(UITextField*)[self.view viewWithTag:1002] setText:@""];
    [(UITextField*)[self.view viewWithTag:1003] setText:@""];
    [(UITextField*)[self.view viewWithTag:1004] setText:@""];
    [(UITextField*)[self.view viewWithTag:3006] setText:@""];
    

    
    
    [self registerForKeyboardNotifications];
    
    Amount = (UITextField*)[self.view viewWithTag:1001];
    [Amount setDelegate:self];
    
    UIBarButtonItem *btn_continue = [[UIBarButtonItem alloc] initWithTitle:@"Continuar"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(continueTransaction:)];
    NSArray *actionButtonItems = @[btn_continue];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    // Make the request for contracts info
    
    if (_page_controller_slave != nil || _arr_basic_services != nil || _arr_user_services != nil) {
        return;
    }

    if (_contract_type == UniContract) {                // Comming from contract detail
        [[self.view viewWithTag:345] setHidden: YES];
        [[self.view viewWithTag:346] setHidden: YES];
        [self.arr_contracts addObject:@[_contract_info]];
    }
    //else{
    [[LoadingView loadingViewWithMessage:nil] show];    // Comming from drawer option
        NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
        NSLog(@"Here: %@", username);
        
        NSString *params     = @"?language=SPA";
        NSString *key =[[RequestManager sharedInstance] keyToSend];
        
        NSMutableString *headerString = [NSMutableString string];
        
        [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,username, params]];
        NSLog(@"headerString = %@",headerString);
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :headerString} mutableCopy ]
                                                    toMethod:kRequestGetContracts isPost:NO];
        [[LoadingView loadingViewWithMessage:@"Obteniendo Información ... "] show];

//        [[RequestManager sharedInstance] setDelegate:self];
//        [[RequestManager sharedInstance] sendRequestWithData:[@{@"1" :username,
//                                                                @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy ]
//                                                    toMethod:kRequestGetContracts isPost:NO];
    //}
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpContractsHeader{
    
    if (self.page_controller == nil)
        [super setUpBaseHeader];
    
    if (_arr_user_services == nil || _arr_other_banks == nil) {
        
        _arr_act_accounts       = [[NSMutableArray alloc] initWithCapacity:[self.arr_contracts count]];
        _arr_user_services      = [[NSMutableArray alloc] initWithCapacity:[self.arr_contracts count]];
        _arr_other_banks        = [[NSMutableArray alloc] initWithCapacity:[self.arr_contracts count]];
        _arr_pay_credit         = [[NSMutableArray alloc] initWithCapacity:[self.arr_contracts count]];

        
        for (NSObject *obj in [self.arr_contracts objectAtIndex:0]){        // Preparing slots for other_banks and services for each contract
            [_arr_user_services     addObject:[NSNull null]];
            [_arr_other_banks       addObject:[NSNull null]];
            [_arr_act_accounts      addObject:[NSNull null]];
            [_arr_pay_credit        addObject:[NSNull null]];

        }

        [_collection_services setDelegate:self];
        [_collection_services setDataSource:self];
    }
    
    if (super.flow == Transfers) {
    /*    _page_controller_slave = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                               options:nil];
        [[_page_controller_slave view] setTag:kSlaveHeader];
        _page_ctrl_delegate_slave             = [[ContractHeaderPageViewCtrlDelegate alloc] initDelegateWithContracts:self.arr_contracts];
        _page_ctrl_delegate_slave.delegate    = self;
        _page_ctrl_delegate_slave.header_type = kSlaveHeader;
        
     
        [super setUpContractHeaderWithPageCtrl:_page_controller_slave
                                        inView:_headerContainer_slave
                                   andDelegate:_page_ctrl_delegate_slave];
     */
    }
    
    NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
    
    NSMutableDictionary *params = [@{ @"tipoServicio": [contractInfo objectForKey:@"tipoServicio"],
                                      @"contract"  : [[contractInfo objectForKey:@"idContrato"] stringValue],
                                      @"empresa"     : [contractInfo objectForKey:@"empresa"],
                                      @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
    //[[LoadingView loadingViewWithMessage:nil] show];
}

-(void)setUpOtherBanksContractHeader{

    [[_page_controller_slave view] removeFromSuperview];
    
    _page_controller_otherBanks = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
    [[_page_controller_otherBanks view] setTag:kOtherBanksHeader];
    _page_ctrl_delegate_otherBanks             = [[ContractHeaderPageViewCtrlDelegate alloc] initDelegateWithContracts:_arr_other_banks];
    _page_ctrl_delegate_otherBanks.header_type = kOtherBanksHeader;
    _page_ctrl_delegate_otherBanks.delegate    = self;
    
    [super setUpContractHeaderWithPageCtrl:_page_controller_otherBanks
                                    inView:_headerContainer_slave
                               andDelegate:_page_ctrl_delegate_otherBanks];
}

-(void)getCurrentToken:(NSString *)currentToken inContract:(NSDictionary *)contractInfo{
    
    NSLog(@"Index: %d",(int)self.page_ctrl_delegate.current_index);
    NSLog(@"Last pos: %d",[(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    
    int index =(int)self.page_ctrl_delegate.current_index ;
    int last_pos = ([(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    if (index == 0) {
        _left_button.hidden =YES;
        _rigth_button.hidden =NO;
        
    }else if (index == last_pos )
    {
        _left_button.hidden =NO;
        _rigth_button.hidden =YES;
        
        
    }else{
        _left_button.hidden =NO;
        _rigth_button.hidden =NO;
        
    }
    if (currentToken == NULL) { // Request the token for the contract
        
        
        NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
        NSMutableDictionary *params = [@{ @"tipoServicio": [contractInfo objectForKey:@"tipoServicio"],
                                          @"contract"  : [[contractInfo objectForKey:@"idContrato"] stringValue],
                                          @"empresa"     : [contractInfo objectForKey:@"empresa"],
                                          @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
         [[LoadingView loadingViewWithMessage:nil] show];
        [RequestManager sharedInstance].delegate = self;
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
       // [[LoadingView loadingViewWithMessage:@"Cargando ... "] show];
    }
    else{   // The contract has a token, in this flow, nothing to do

    }
}

-(IBAction)updateViewIfNotifyChange:(UISwitch *)sender{
    [self performSegueWithIdentifier:@"segueNotifyTransDataEntry"
                              sender:nil];
}
- (IBAction)addService:(UIButton *)sender {
    
}

-(IBAction)contractTypeSelector:(RadioButton*)sender{
    if (super.flow == Transfers) {
        if (sender.tag == kActinverTagRadioButton) {    // Actinver contracts
            [[_page_controller_otherBanks view] removeFromSuperview];
            [_headerContainer_slave addSubview:[_page_controller_slave view]];
        }
        else if (sender.tag == kOtherBanksTagRadioButton){
            if ([_arr_other_banks objectAtIndex:_master_index] == [NSNull null]){
                
                
                NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
//                NSMutableDictionary     *contract          = [super updateTokenIncontractHeader:token];
                [contractInfo objectForKey:@"contract_token"];  // Update the contract token
                
                // key/01/user/contract?language=SPA
                //   parameters:  keyUSM02/7156896?accountStatus=1&language=SPA  -->  PRD01
                
                NSString *key = [contractInfo objectForKey:@"contract_token"];
                NSString *user = [[Session sharedManager].pre_session_info objectForKey:@"username"];
                NSString *contract   = [contractInfo objectForKey:@"idContrato"];
                NSString *params     = @"?language=SPA";
                
                NSMutableString *headerString = [NSMutableString string];
                [headerString appendString:[NSString stringWithFormat:@"%@/01/%@/%@%@", key,user,contract,params]];
                NSLog(@"headerString = %@",headerString);
                [[RequestManager sharedInstance] setDelegate:self];
                [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                        @"append_key"  :headerString} mutableCopy ]
                                                            toMethod:kRequestGetTransfersOtherBanks isPost:NO];
               // [[LoadingView loadingViewWithMessage:nil] show];

                
//                NSMutableDictionary *params = [@{ @"tipoServicio": [contractInfo objectForKey:@"tipoServicio"],
//                                                  @"contract"  : [[contractInfo objectForKey:@"idContrato"] stringValue],
//                                                  @"empresa"     : [contractInfo objectForKey:@"empresa"],
//                                                  @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
//                [[RequestManager sharedInstance] sendRequestWithData:[[NSMutableDictionary alloc] init]
//                                                            toMethod:kRequestGetTransfersOtherBanks isPost:NO];
            }
            else{
                [[_page_controller_slave view] removeFromSuperview];
                [_headerContainer_slave addSubview:[_page_controller_otherBanks view]];
            }
        }
    }

    if (super.flow == Services) {
        NSDictionary *info = [self.page_ctrl_delegate getCurrentContract];
        if (sender.tag == kServicesTagRadioButton){
            
            [[self.view viewWithTag:1001] setHidden: NO];
            [[self.view viewWithTag:1004] setHidden: YES];
            [[self.view viewWithTag:1003] setHidden: NO];
            [[self.view viewWithTag:3000] setHidden: NO];
            [[self.view viewWithTag:3001] setHidden: NO];
            [[self.view viewWithTag:3003] setHidden: NO];
            [[self.view viewWithTag:1002] setHidden: NO];
            [[self.view viewWithTag:50] setHidden: NO];
            [[self.view viewWithTag:10] setHidden: NO];
            
            [[self.view viewWithTag:3005] setHidden: NO];
            [[self.view viewWithTag:3006] setHidden: NO];
            
            [(UILabel*)[self.view viewWithTag:3002] setText:@"Importe en (MXN)"];
            [(UILabel*)[self.view viewWithTag:3003] setText:@"Concepto"];
            [(UILabel*)[self.view viewWithTag:3004]setText:@"Detalles del Pago"];
            
            
            if ([_arr_user_services objectAtIndex:_master_index ] == [NSNull null]) {       // Request the air time services
                NSLog(@"Contract Key: %@",[info objectForKey:@"contract_token"]);
                //[[LoadingView loadingViewWithMessage:nil] show];
                
                // /7356637/107397861?language=SPA
                NSString * key = [info objectForKey:@"contract_token"];
                NSString * contract = [info objectForKey:@"idContrato"];
                NSString * user = [[Session sharedManager].pre_session_info objectForKey:@"username"];  //[[RequestManager sharedInstance] userId];
               
                NSMutableString *headerString = [NSMutableString string];
                [headerString appendString:[NSString stringWithFormat:@"%@/%@/%@?language=SPA", key,contract,user]];
                
                //[[RequestManager sharedInstance] setDelegate:self];
                [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                        @"append_key"  :headerString} mutableCopy ]
                                                                        toMethod:kRequestGetUSerServices isPost:NO];
                
                [[LoadingView loadingViewWithMessage:nil] show];
                
                
//                [[RequestManager sharedInstance] sendRequestWithData:[@{@"append_key"   :[info objectForKey:@"contract_token"],
//                                                                        @"1"            :[info objectForKey:@"idContrato"],
//                                                                        @"2"            :[[RequestManager sharedInstance] userId]} mutableCopy]
//                                                            toMethod:kRequestGetUSerServices isPost:NO];

                return;
            }
        }
        else{   // Request airtime services
            
            [[self.view viewWithTag:1004] setHidden: NO];
            [[self.view viewWithTag:1001] setHidden: YES];
            [[self.view viewWithTag:1003] setHidden: YES];
            [[self.view viewWithTag:3000] setHidden: YES];
            [[self.view viewWithTag:3001] setHidden: YES];
            [[self.view viewWithTag:3003] setHidden: YES];
            [[self.view viewWithTag:1002] setHidden: YES];
            [[self.view viewWithTag:50] setHidden: YES];
            [[self.view viewWithTag:10] setHidden: YES];
            
            [[self.view viewWithTag:3005] setHidden: YES];
            [[self.view viewWithTag:3006] setHidden: YES];
            
            [(UILabel*)[self.view viewWithTag:3002] setText:@"Número Celular o TAG"];
            [(UILabel*)[self.view viewWithTag:3003] setText:@"Confirmar"];
            [(UILabel*)[self.view viewWithTag:3004] setText:@"Detalles de Recarga"];
            
            // /1?language=SPA
            if (_arr_basic_services == nil) {
                NSLog(@"Contract Key: %@",[info objectForKey:@"contract_token"]);
                [[LoadingView loadingViewWithMessage:nil] show];
                
                NSString *key =[info objectForKey:@"contract_token"];
                NSMutableString *headerString = [NSMutableString string];
                [headerString appendString:[NSString stringWithFormat:@"%@/1?language=SPA", key]];
                NSLog(@"headerString = %@",headerString);
                
                [[RequestManager sharedInstance] setDelegate:self];
                [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                        @"append_key"  :headerString} mutableCopy ]
                                                            toMethod:kRequestGetAirtimeServices_1 isPost:NO];  // kRequestGetAirtimeServices_3
         

            }
        }
        [_collection_services reloadData];
    }
}

#pragma mark - ContractHeaderDelegate

-(void)getCurrentToken:(NSString *)token inContractIndex:(int)index inPageViewCtrWithTag:(int)tag{
    NSLog(@"Protocol final");
    
    if (tag == kMasterHeader)
        _master_index   = index;

    else{
        _slave_index    = index;
    }
    
    if (_slave_index == 0) {
        _left_button_slave.hidden = YES;
        _rigth_button_slave.hidden=NO;
        
    }else if (_slave_index ==[[_page_ctrl_delegate_slave.arr_contracts objectAtIndex:_page_ctrl_delegate_slave.contract_index] count]-1  ){
    
        _left_button_slave.hidden = NO;
        _rigth_button_slave.hidden=YES;
    }else{
        _left_button_slave.hidden = NO;
        _rigth_button_slave.hidden=NO;
    
    }
    @try {
         [self getCurrentToken:token inContract:[[self.arr_contracts objectAtIndex:0] objectAtIndex:index]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
   
    
}

-(void)responseFromService:(NSMutableDictionary *)response{
    #warning Validate the result is nil (Network error)
    
    
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetTransfersOtherBanks) {
        
        if ([[response objectForKey:@"array"] count] == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertArray = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                 message:@"Sin datos"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
            [alertArray show];
            });
            return;
        }
        NSLog(@"Array: %@",[response objectForKey:@"array"]);
        
        NSArray *contracts = [response objectForKey:@"array"];
        
        NSMutableArray *own = [[NSMutableArray alloc] init];
        NSMutableArray *oth = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in contracts) {
            if ([[dict objectForKey:@"accountType"] isEqualToString:@"CLABE"])
                [oth addObject:dict];
            else
                [own addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            
            [_arr_act_accounts replaceObjectAtIndex:_master_index withObject:own];
            [_arr_other_banks replaceObjectAtIndex:_master_index withObject:oth];
            
            NSLog(@"Banks Actinver: %@",_arr_act_accounts);
            NSLog(@"Other Banks : %@",_arr_other_banks);
            
            
            if (_page_controller_slave == nil) {
                _page_controller_slave = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                       options:nil];
                [[_page_controller_slave view] setTag:kSlaveHeader];
                _page_ctrl_delegate_slave             = [[ContractHeaderPageViewCtrlDelegate alloc] initDelegateWithContracts:_arr_act_accounts];
                _page_ctrl_delegate_slave.delegate    = self;
                _page_ctrl_delegate_slave.header_type = kSlaveHeader;
                
                
                [super setUpContractHeaderWithPageCtrl:_page_controller_slave
                                                inView:_headerContainer_slave
                                           andDelegate:_page_ctrl_delegate_slave];                                
            }
            
            if (_page_controller_otherBanks == nil) {
                [self setUpOtherBanksContractHeader];
            }
            else{
                _page_ctrl_delegate_otherBanks.contract_index       = _master_index;
                _page_controller_otherBanks.dataSource              = nil;
                _page_controller_otherBanks.dataSource              = _page_ctrl_delegate_otherBanks;
            }
            
            if ((RadioButton *)[self.view viewWithTag:kActinverTagRadioButton]) {    // Actinver contracts
                [[_page_controller_otherBanks view] removeFromSuperview];
                [_headerContainer_slave addSubview:[_page_controller_slave view]];
            }
            else{
                [[_page_controller_slave view] removeFromSuperview];
                [_headerContainer_slave addSubview:[_page_controller_otherBanks view]];
            }
        });

    }
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContracts) {
        NSMutableArray  *cont_array = [response objectForKey:@"contracts"];
        
        NSMutableArray  *aux_array  = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *dict in cont_array) {
            if ([[dict objectForKey:@"empresa"] isEqualToString:@"Banco"]){//cambiar por banco
                [aux_array addObject:[dict mutableCopy]];
                //[LoadingView close];

            }
        }
        [self.arr_contracts addObject:aux_array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            [self setUpContractsHeader];
        });
    }
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContractToken) {
        NSString *token = [[response objectForKey:@"result"] objectForKey:@"key"];
        if (token != NULL) {
            NSMutableDictionary     *contract          = [super updateTokenIncontractHeader:token];
            [contract setValue:token forKey:@"contract_token"];  // Update the contract token
            
            //if ([(RadioButton *)[self.view viewWithTag:kActinverTagRadioButton] isSelected]){
            if ([(RadioButton *)[self.view viewWithTag:kActinverTagRadioButton] isSelected] && super.flow == Transfers){   // Services
                if ([_arr_other_banks objectAtIndex:_master_index] == [NSNull null]) {  // Info not ready in delegate
                    NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
                    NSString *key = [[response objectForKey:@"result"] objectForKey:@"key"];
                    NSString *user = [[Session sharedManager].pre_session_info objectForKey:@"username"];
                    NSString *contract   = [contractInfo objectForKey:@"idContrato"];
                    NSString *params     = @"?language=SPA";
                    
                    NSMutableString *headerString = [NSMutableString string];
                    [headerString appendString:[NSString stringWithFormat:@"%@/01/%@/%@%@", key,user,contract,params]];
                    NSLog(@"headerString = %@",headerString);
                    [[RequestManager sharedInstance] setDelegate:self];
                    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                            @"append_key"  :headerString} mutableCopy ]
                                                                toMethod:kRequestGetTransfersOtherBanks isPost:NO];
                    
                //    [[LoadingView loadingViewWithMessage:nil] show];
                    
                    
                    //                    [[RequestManager sharedInstance] sendRequestWithData:[[NSMutableDictionary alloc] init]
                    //                                                                toMethod:kRequestGetTransfersOtherBanks isPost:NO];  //PRD01
                    return; // return to do not dismiss the Loading view from token request
                }
                else{   // info already in the delegate, refresh the view
                    _page_ctrl_delegate_slave.contract_index    = _master_index;
                    _page_controller_slave.dataSource           = nil;
                    _page_controller_slave.dataSource           = _page_ctrl_delegate_slave;
                }
            }
            
            if ([(RadioButton *)[self.view viewWithTag:kOtherBanksTagRadioButton] isSelected] && super.flow == Transfers){   // Other banks option selected
                if ([_arr_other_banks objectAtIndex:_master_index] == [NSNull null]) {  // Info not ready in delegate
                    
                    NSString *key = [[response objectForKey:@"result"] objectForKey:@"key"];
                    NSString *user = [[Session sharedManager].pre_session_info objectForKey:@"username"];
                    NSString *contract   = [response objectForKey:@"idContrato"];
                    NSString *params     = @"?language=SPA";
                    
                    NSMutableString *headerString = [NSMutableString string];
                    [headerString appendString:[NSString stringWithFormat:@"%@/01/%@/%@%@", key,user,contract,params]];
                    NSLog(@"headerString = %@",headerString);
                    [[RequestManager sharedInstance] setDelegate:self];
                    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                            @"append_key"  :headerString} mutableCopy ]
                                                                toMethod:kRequestGetTransfersOtherBanks isPost:NO];

                    
                    
                    
//                    [[RequestManager sharedInstance] sendRequestWithData:[[NSMutableDictionary alloc] init]
//                                                                toMethod:kRequestGetTransfersOtherBanks isPost:NO];  //PRD01
                    return; // return to do not dismiss the Loading view from token request
                }
                else{   // info already in the delegate, refresh the view
                    _page_ctrl_delegate_slave.contract_index    = _master_index;
                    _page_controller_slave.dataSource           = nil;
                    _page_controller_slave.dataSource           = _page_ctrl_delegate_slave;
                }
            }
            if ([(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected] && super.flow == Services){   // Services
                if ([_arr_user_services objectAtIndex:_master_index] == [NSNull null]) {  // Info not ready in delegate
                    
                    NSDictionary *info = [self.page_ctrl_delegate getCurrentContract];
                    
                    NSLog(@"Contract Key: %@",[info objectForKey:@"contract_token"]);
                    
//                    [[RequestManager sharedInstance] sendRequestWithData:[@{@"append_key"   :[info objectForKey:@"contract_token"],
//                                                                            @"1"            :[info objectForKey:@"idContrato"],
//                                                                            @"2"            :[[RequestManager sharedInstance] userId]} mutableCopy]
//                                                                toMethod:kRequestGetUSerServices isPost:NO];
                    NSString * key = [info objectForKey:@"contract_token"];
                    NSString * contract = [info objectForKey:@"idContrato"];
                    NSString * user = [[Session sharedManager].pre_session_info objectForKey:@"username"];//[[RequestManager sharedInstance] userId];
                    NSMutableString *headerString = [NSMutableString string];
                    [headerString appendString:[NSString stringWithFormat:@"%@/%@/%@?language=SPA", key,contract,user]];
                    
                    //[[RequestManager sharedInstance] setDelegate:self];
                    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                            @"append_key"  :headerString} mutableCopy ]
                                                                toMethod:kRequestGetUSerServices isPost:NO];
                    
                    
                    return; // return to do not dismiss the Loading view from token request
                }
                else{   // info already in the delegate, refresh the view
                    [_collection_services reloadData];
                }
            }
        }
        else{
            #warning Validate error getting the token from service

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
        });
    }
    


    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetUSerServices) {
        
        if ([[[[[[response objectForKey:@"outCommonHeader"] objectForKey:@"result"] objectForKey:@"messages"] objectAtIndex:0 ]objectForKey:@"responseSystemCode"] isEqualToString:@"ACTIB002"]) { // BEADM0000003   // ACTIB002

           dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [[[[[response objectForKey:@"outCommonHeader"] objectForKey:@"result"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"responseMessage"];
            
            
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
            [errorMessage show];
                });
            return;

        }
        
        
        if ([[[[[[response objectForKey:@"outCommonHeader"] objectForKey:@"result"] objectForKey:@"messages"] objectAtIndex:0 ]objectForKey:@"responseSystemCode"] isEqualToString:@"BEADM0000003"]) { // BEADM0000003   // ACTIB002
            [[RequestManager sharedInstance]setDic_PRP06:response];
            [_arr_user_services replaceObjectAtIndex:_master_index withObject:[[NSMutableArray alloc] init]];
        }else{
        NSArray *user_services = [[response objectForKey:@"outServicePaymentContractQuery"] objectForKey:@"registeredCompaniesList"];
             //NSArray *user_services = [response objectForKey:@"outServicePaymentContractQuery"];

        if (user_services.count != 0) {
            [_arr_user_services replaceObjectAtIndex:_master_index withObject:user_services];
            
        NSLog(@"User services: %@",_arr_user_services);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView close];
                [_collection_services reloadData];
             });
        }
        else{
            #warning Validate error empty list

          
                UIAlertView *alert_Empty_List = [[UIAlertView alloc] initWithTitle:@"Error" message:@"este contrato no tiene cuentas asignadas" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert_Empty_List show]  ;

          //  [_arr_user_services count] == 0? [alert_Empty_List show] : ;
            
            
            //            if ([response objectForKey:@"outServicePaymentContractQuery"] == NULL) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Erro al encontrar servicios" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
           }
        }
    }
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetAirtimeServices_1) { // kRequestGetAirtimeServices_3
        NSMutableArray *services = [[response objectForKey:@"outServiceCompanyQuery"] objectForKey:@"serviceInfo"];
        NSDictionary *info = [self.page_ctrl_delegate getCurrentContract];
        if (services.count != 0) {
            //if (services.count == 0) {
            if (_arr_basic_services == nil) {
                _arr_basic_services = [services mutableCopy];
                
                NSString *key =[info objectForKey:@"contract_token"];
                NSMutableString *headerString = [NSMutableString string];
                [headerString appendString:[NSString stringWithFormat:@"%@/3?language=SPA", key]];
                NSLog(@"headerString = %@",headerString);
                
                [[RequestManager sharedInstance] setDelegate:self];
                [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                        @"append_key"  :headerString} mutableCopy ]
                                                            toMethod:kRequestGetAirtimeServices_3 isPost:NO];          // telepeage  kRequestGetAirtimeServices_1
                
//                [[RequestManager sharedInstance] sendRequestWithData:[@{@"append_key"   :[info objectForKey:@"contract_token"],
//                                                                        @"1"            :@"3"} mutableCopy]
//                                                            toMethod:kRequestGetAirtimeServices isPost:NO];

                 return;
            }
            else{
                [_arr_basic_services addObjectsFromArray:services];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView close];
                    [_collection_services reloadData];
                    
                });
            }

        }
        else{
            #warning Validate error empty list            
        }
    }
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetAirtimeServices_3) { // kRequestGetAirtimeServices_1
        
        NSMutableArray *services = [[response objectForKey:@"outServiceCompanyQuery"] objectForKey:@"serviceInfo"];
        
        [_arr_basic_services addObjectsFromArray:services];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [LoadingView close];
            [_collection_services reloadData];
        });
    }
    
    if (super.flow == CreditCard) {
        
        //   keyusm02/6909659?language=SPA  , params for PayCreditCard
        
        if ([[response objectForKeyedSubscript:@"method_code"] intValue] == kRequestGetContractToken) {
            
            NSString *key = [[response objectForKey:@"result"] objectForKey:@"key"];
            NSString *valor = @"0";
            NSString *language     = @"?language=SPA";
            
            NSMutableString *PayCreditCar = [NSMutableString string];
            [PayCreditCar appendString:[NSString stringWithFormat:@"%@/%@%@", key,valor, language]];
            NSLog(@"headerString = %@",PayCreditCar);
            [[RequestManager sharedInstance] setDelegate:self];
            [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                    @"append_key"  :PayCreditCar} mutableCopy]
                                                        toMethod:KRequestGetPayCreditCard isPost:NO];
        }
        
        if ([[response objectForKeyedSubscript:@"method_code"] intValue] == KRequestGetPayCreditCard) {
            
            NSMutableArray *CreditCard = [[NSMutableArray alloc] init];
            CreditCard = [[response objectForKey:@"outUBCreditCardQuery"] objectForKey:@"tdclist"];
            
            [_arr_pay_credit replaceObjectAtIndex:_master_index withObject:CreditCard];
            
            NSLog(@"CARDS: %@",_arr_pay_credit);
            
            if (_page_controller_PayCredit == nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView close];
                    
                    _page_controller_PayCredit = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                  
                                                                                               options:nil];
                    // page_ctrl_delegate_PayCredit
                    [[_page_controller_PayCredit view] setTag:kPayCreditCard];
                    _page_ctrl_delegate_PayCredit             = [[ContractHeaderPageViewCtrlDelegate alloc] initDelegateWithContracts:_arr_pay_credit];
                    _page_ctrl_delegate_PayCredit.delegate    = self;
                    _page_ctrl_delegate_PayCredit.header_type = kPayCreditCard;
                    
                    
                    [super setUpContractHeaderWithPageCtrl:_page_controller_PayCredit
                                                    inView:_headerContainer_slave
                                               andDelegate:_page_ctrl_delegate_PayCredit];
                    
                });
            }
            
        }
        
    }

    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueNotifyTransDataEntry"]) {
        ModalEntryDataViewController *aux   = segue.destinationViewController;
        aux.delegate                        = self;
    }
    
    if ([segue.identifier isEqualToString:@"segueConfirmDataView"]) {
        ConfirmDataViewController *aux      = segue.destinationViewController;
        aux.trans_data                      = (NSMutableArray*)sender;
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"Segue: %@",segue.identifier);
}

- (IBAction)unwindToTransactionMainView:(UIStoryboardSegue *)unwindSegue{
    NSLog(@"Segue: %@",unwindSegue.identifier);
    [self initializeView];
    
    [[LoadingView loadingViewWithMessage:nil] show];
    NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
    NSLog(@"Here: %@", username);
    
    NSString *params     = @"?language=SPA";
    NSString *key =[[RequestManager sharedInstance] keyToSend];
    
    NSMutableString *headerString = [NSMutableString string];
    
    [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,username, params]];
    NSLog(@"headerString = %@",headerString);
    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                            @"append_key"  :headerString} mutableCopy ]
                                                toMethod:kRequestGetContracts isPost:NO];
    //[[LoadingView loadingViewWithMessage:@"Obteniendo Información ... "] show];
    
//    [[RequestManager sharedInstance] setDelegate:self];
//    [[RequestManager sharedInstance] sendRequestWithData:[@{@"1" :username,
//                                                            @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy ]
//                                                toMethod:kRequestGetContracts isPost:NO];
}

#pragma mark - Modal Data Entry Delegate

-(void) notifyDataEntryWasCancelled{
    [_swi_notify_user setOn:NO animated:YES];
    [self updateNotifyDataEstatus];
}

-(void) notifyDataEntryEnteredInfo:(NSMutableDictionary *)info{
    // 502 E-mail, 505 text_message
    [(UITextField *)[self.view viewWithTag:502] setText:[info valueForKey:@"key_1"]];
    [(UITextField *)[self.view viewWithTag:505] setText:[info valueForKey:@"key_2"]];
    
    [self updateNotifyDataEstatus];
}

-(void)updateNotifyDataEstatus{
    for (int i=1; i< 10; i++){
        [[self.view viewWithTag:500 + i] setHidden:![_swi_notify_user isOn]];
    }
}

-(IBAction)continueTransaction:(id)sender{
    
    #warning Validations same contract in master & slave
    
    // Recover the transaction data. Order:
    // 0. Origin Contract
    // 1. Destination Contract
    // 2. Transaction Details
    // 3. Notify user Info
    
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    // Contract Info
    [info addObject:[super getCurrentContract]];
    NSLog(@"priemro%@",info);
    
    NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
    
    

    // Destination contract info
    
    NSString *typeProcess;
    NSMutableDictionary *trans_info;
    
    if (self.flow == Transfers){
        typeProcess = @"transfer";
        
        BOOL actinver_operation =  [(RadioButton *)[self.view viewWithTag:kActinverTagRadioButton] isSelected];
    
        if (actinver_operation)                // Actinver Contracts
            [info addObject:[_page_ctrl_delegate_slave getCurrentContract ]];
        else
            [info addObject:[_page_ctrl_delegate_otherBanks getCurrentContract ]];  // Other banks Contracts
        
        
         // Default Transfer information
        trans_info = [@{@"amount":[Utility makeSafeString:[[[[(UITextField *)[self.view viewWithTag:1001]text] stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""]],
                        @"transferDetails":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1002] text]],
                        @"reference":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1003] text]]} mutableCopy];

        if (actinver_operation) {
            [trans_info setObject:@"02" forKey:@"businessType"];
            [trans_info setObject:@"2"  forKey:@"destinationAccountTypeID"];
        }
            else{
            [trans_info setObject:@"01" forKey:@"businessType"];
            [trans_info setObject:@"3"  forKey:@"destinationAccountTypeID"];
        }
        
        if([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@""]){
            
            UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"el campo Importe esta vacio."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil , nil];
            [campo show];
            return;
            
            
        }else if([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@"$0.00"]){
            
            UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"el campo Importe no puede ser de $0.00."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil , nil];
            [campo show];
            return;
            
        }

    }
    else if (self.flow == Services){
        typeProcess = @"payService";
        
        BOOL user_services =  [(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected];
        
        if (user_services) {        // Contract services option selected
            [info addObject:[[_arr_user_services objectAtIndex:_master_index] objectAtIndex:_services_selected_index]];
            
            trans_info = [@{@"amount":[Utility makeSafeString:[[[[(UITextField *)[self.view viewWithTag:1001]text] stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""]],
                            @"concept":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1002] text]],
                            @"paymentReference":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1003] text]],
                            @"checkDigit":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:3006] text]],
                            @"clientId":[[RequestManager sharedInstance] userId],
                            @"typePay":@"1",                // User Services
                            @"commissionReference":@" ",    // TODO: Validate this field
                            @"operationFeeId":@"?",         // TODO: Validate this field
                            @"operationId":@"-1"
                            } mutableCopy];
            
            
            if ([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@""]) {
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"El campo importe esta vacio."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil , nil];
                [campo show];
                return;
                
            }else if([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@"$0.00"]){
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"el campo Importe no puede ser de $0.00."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil , nil];
                [campo show];
                return;
                
            }
            if ([[(UITextField*)[self.view viewWithTag:1002] text] isEqualToString:@""]){
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"El campo Concepto esta vacio."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil , nil];
                [campo show];
                return;
                
            }
            
            
            NSLog(@"Trans info: %@",trans_info);

        }
        else{   ///  RECARGA y TELPEAGE
            [info addObject:[_arr_basic_services objectAtIndex:_services_selected_index]];
          
            trans_info = [@{@"numberAndTag":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1004] text]],
                            @"amount":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1002] text]],
                            @"paymentReference":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1003] text]],
                            @"clientId":[[RequestManager sharedInstance] userId],
                            @"typePay":@"2",                // Telepeaje
                            @"commissionReference":@" ",    // TODO: Validate this field
                            @"operationFeeId":@"?",         // TODO: Validate this field
                            @"operationId":@"-1"
                            } mutableCopy];

            if ([[(UITextField*)[self.view viewWithTag:1004] text] isEqualToString:@""]) {
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                     message:@"El campo número de celular o Tag esta vacio."
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil , nil];
                [campo show];
                return;
                
            }
//            else if ([[(UITextField*)[self.view viewWithTag:1002] text] isEqualToString:@""]){
//                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
//                                                                message:@"El campo confirmar esta vacio."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil , nil];
//                [campo show];
//                return;
//                
//            }
            
//            if ([(UITextField*)[self.view viewWithTag:1001] text] != [(UITextField*)[self.view viewWithTag:1002] text]) {
//                
//                UIAlertView *serviceTag = [[UIAlertView alloc] initWithTitle:@"Atención"
//                                                                     message:@"El número de celular o Tag no conciden"
//                                                                    delegate:self
//                                                           cancelButtonTitle:@"OK"
//                                                           otherButtonTitles:nil , nil];
//                [serviceTag show];
//                return;
//            }
        }
    }
    //
    if (self.flow == CreditCard) {
        typeProcess = @"payCreditCard";
        
        [info addObject:[_page_ctrl_delegate_PayCredit getCurrentContract]];
        
        trans_info = [@{@"amount":[Utility makeSafeString:[[[[(UITextField *)[self.view viewWithTag:1001]text] stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""]],
                        @"alias":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:1002] text]],
                        @"clientId":[[RequestManager sharedInstance] userId],
                        @"language":@"SPA",                // User Services
                        @"tokenContract":@"SE OBTIENE DE LA USM02 ",    // TODO: Validate this field
                        @"contractNumber":@"SE OBTIENE DE LA USM04",         // TODO: Validate this field
                        @"aliasCredictCard":@"ALIAS",
                        @"credictCardNumber":@"SE OBIENE DEL SERVICIO",
                        @"sendingID":@"SE OBTIENE DE LA SFT21",
                        @"newValueType":@"SE OBTIENE DE LA SFT21"
                        } mutableCopy];
        
        
        
        if ([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@""]) {
            
            UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"El campo importe esta vacio."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil , nil];
            [campo show];
            return;
            
        }else if([[(UITextField*)[self.view viewWithTag:1001] text] isEqualToString:@"$0.00"]){
            
            UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"el campo Importe no puede ser de $0.00."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil , nil];
            [campo show];
            return;
            
        }
        if ([[(UITextField*)[self.view viewWithTag:1002] text] isEqualToString:@""]){
            UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                            message:@"El campo Concepto esta vacio."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil , nil];
            [campo show];
            return;
            
        }
        
        NSLog(@"Trans info: %@",trans_info);
        
        
    }
    
    //
    
    [trans_info setObject:typeProcess forKey:@"typeProcess"];
    [info addObject:trans_info];
    
    // Notify info (if exists)
    if ([_swi_notify_user isOn]) {
        [info addObject:@{@"mail":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:502] text]],
                          @"sms":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:505] text]]}];
    }
    
    NSLog(@"Recovered info: %@",info);
    
    [self performSegueWithIdentifier:@"segueConfirmDataView" sender:info];
}

#pragma - mark Collection Services Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected]) {
       NSDictionary *response= [[RequestManager sharedInstance]dic_PRP06];
        if ([[[[[[response objectForKey:@"outCommonHeader"] objectForKey:@"result"] objectForKey:@"messages"] objectAtIndex:0 ]objectForKey:@"responseSystemCode"] isEqualToString:@"BEADM0000003"]) {
        return   false;
        }
        return [[_arr_user_services objectAtIndex:_master_index] count];
    }
    else{
        return [_arr_basic_services count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCellViewIdentifier"
                                                                         forIndexPath:indexPath];
    NSMutableArray  *services;
    
    if ([(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected])
        services   = [_arr_user_services objectAtIndex:_master_index];
    else
        services = _arr_basic_services;

    [CustomizeControl roundCornersInView:[cell viewWithTag:1401]];
    
    
    
    if (_services_selected_index == indexPath.row)
        [[cell viewWithTag:1401] setBackgroundColor:[CustomizeControl getYellowColor]];
    
    else
        [[cell viewWithTag:1401] setBackgroundColor:[CustomizeControl getDarkGrayColor]];

    NSDictionary    *info       = [services objectAtIndex:indexPath.row];
    
    [(UILabel *)[cell viewWithTag:101] setText:[info objectForKey:@"companyName"]];
    
     BOOL select_services =  [(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected];
    
    //if ( ([[info objectForKey:@"companyName"] isEqualToString:@"TELMEX (Pago Parcial)"]) && (_services_selected_index == 0)) {
    if ( _services_selected_index == 0 && select_services) {
        
        [(UILabel*)[self.view viewWithTag:3005] setHidden:NO];
        [(UITextField*)[self.view viewWithTag:3006] setHidden:NO];
    
    }else if ( _services_selected_index == 7  && select_services) {
            
        [(UILabel*)[self.view viewWithTag:3005] setHidden:NO];
        [(UITextField*)[self.view viewWithTag:3006] setHidden:NO];
    }

    else{
        [(UILabel*)[self.view viewWithTag:3005] setHidden:YES];
        [(UITextField*)[self.view viewWithTag:3006] setHidden:YES];
    }
    
    if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $50"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
   if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $100"] ) {
       UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
       imgView.frame = CGRectMake(0, 0, 100, 80);
       [(UIView *)[cell viewWithTag:301] addSubview:imgView];
   }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $150"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"IUSACELL $500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iusacell100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // MOVISTAR
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $20"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $30"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $50"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $120"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MOVISTAR $500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movistar100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // NEXTEL
    if ([[info objectForKey:@"companyName"] isEqualToString:@"NEXTEL $30"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"NEXTEL $50"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"NEXTEL $100"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"NEXTEL $200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"NEXTEL $500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // TELCEL
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $20"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $30"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $50"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $100"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELCEL $500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telcel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // UNEFON
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $50"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $100"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $150"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"UNEFON $500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unefon100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // OTROS SERVICIOS
    if ([[info objectForKey:@"companyName"] isEqualToString:@"AGUA Y DRENAJE MONTERREY"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aguamty100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"AGUAKAN (Agua Cancun)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aguakan100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"CABLEMAS"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cablemas100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"CFE"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cfe100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"CMAPAS (Agua Guanajuato)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cmaps100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELMEX (Pago Parcial)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telmex100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"AXTEL"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"axtel100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"ECOGAS"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ecogas100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"GAS NATURAL"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gas_natural100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"GOBIERNO CHIHUAHUA"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chihuahua100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"INFONAVIT"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infonavit100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MAXCOM"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maxcom100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MEGACABLE"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"megacable100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MULTIMEDIOS MONTERREY"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multimedios_mty100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"MULTIMEDIOS SALTILLO"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multimedios_saltillo100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"SIAPA (Agua Guadalajara)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"siapa100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"SKY ON LINE"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TESORERIA DEL GOB DF (92 servicios)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tesoreria100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELMEX (Pago Total)"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telmex100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"TELNOR "] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"telnor100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    //RECARGA I+D MEXICO
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 100"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 1000"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 400"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 600"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 700"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 800"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA I+D MEXICO 900"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"id100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // TELEVIA
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA TELEVIA 100"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"televia100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA TELEVIA 200"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"televia100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA TELEVIA 300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"televia100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    // VIAPASS
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA VIAPASS 150"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viapass100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA VIAPASS 300"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viapass100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    if ([[info objectForKey:@"companyName"] isEqualToString:@"RECARGA VIAPASS 500"] ) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viapass100.png"]];
        imgView.frame = CGRectMake(0, 0, 100, 80);
        [(UIView *)[cell viewWithTag:301] addSubview:imgView];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(cellTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:singleTap];
    [cell setUserInteractionEnabled:YES];
    
    return cell;
}

- (void)cellTapped:(UIGestureRecognizer *)gestureRecognizer {
    _services_selected_index    = (int)[gestureRecognizer view].tag;
    NSLog(@"Selected Tap: %d",_services_selected_index);
    [_collection_services reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _services_selected_index = (int)indexPath.row;
    NSLog(@"Selected Delegate: %d",_services_selected_index);
    [_collection_services reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, collectionView.frame.size.height*.85);
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
  
    
    Amount = (UITextField*)[self.view viewWithTag:1001];
    
    NSString *cleanCentString = [[Amount.text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSInteger centValue = [cleanCentString intValue];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber *myNumber = [f numberFromString:cleanCentString];
    NSNumber *result;

    
    if([Amount.text length] < 16){
        if (string.length > 0)
        {
            centValue = centValue * 10 + [string intValue];
            double intermediate = [myNumber doubleValue] * 10 +  [[f numberFromString:string] doubleValue];
            result = [[NSNumber alloc] initWithDouble:intermediate];
        }
        else
        {
            centValue = centValue / 10;
            double intermediate = [myNumber doubleValue]/10;
            result = [[NSNumber alloc] initWithDouble:intermediate];
        }
        
        myNumber = result;
       // NSLog(@"%ld ++++ %@", (long)centValue, myNumber);
        NSNumber *formatedValue;
        formatedValue = [[NSNumber alloc] initWithDouble:[myNumber doubleValue]/ 100.0f];
        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        Amount.text = [_currencyFormatter stringFromNumber:formatedValue];
        return NO;
    }else{
        
        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
       [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        Amount.text = [_currencyFormatter stringFromNumber:00];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Atención"
                                                       message: @"No se puede elegir más cantidad"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
        
        [alert show];
        return NO;
    }
    return string;
}



#pragma mark -> Disable "copy-paste"

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}





@end
