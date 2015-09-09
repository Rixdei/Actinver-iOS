//
//  InqAndMovsViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 17/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "InqAndMovsViewController.h"
#import "ContractHeader.h"
#import "MovementsListViewController.h"
#import "ContractHeaderPageViewCtrlDelegate.h"
#import "Utility.h"
#import "RequestManager.h"

@interface InqAndMovsViewController ()<ContractHeaderDelegate,ResponseFromServicesDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)     IBOutlet    UIView                              *headerContainer;
@property (nonatomic, strong)               UIPageViewController                *page_controller;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate;
@property (nonatomic, strong)               NSMutableArray                      *arr_contracts;

@property (nonatomic, strong)               NSMutableArray          *arr_investment;
@property (nonatomic, strong)               NSMutableArray          *arr_investment_headers;

// Investments
@property (nonatomic, weak)     IBOutlet    UILabel                 *txt_cont_number;
@property (nonatomic, weak)     IBOutlet    UILabel                 *txt_cont_name;
@property (nonatomic, weak)     IBOutlet    UILabel                 *txt_cont_balance;
@property (nonatomic, weak)     IBOutlet    UILabel                 *txt_cont_inv_balance;

@property (nonatomic, weak)     IBOutlet    UITableView             *tbv_investment_data;

// Movements

@property (nonatomic, weak)     IBOutlet    UITextField             *txt_initial_date;
@property (nonatomic, weak)     IBOutlet    UITextField             *txt_final_date;

@property                                   int                     current_index;
@property (weak, nonatomic) IBOutlet UIImageView *left_button;
@property (weak, nonatomic) IBOutlet UIImageView *rigth_buton;


@property (weak, nonatomic) IBOutlet UIImageView *rigth_invert;
@property (weak, nonatomic) IBOutlet UIImageView *left_invert;

@end

@implementation InqAndMovsViewController

@dynamic flow;
@dynamic headerContainer;
@dynamic page_controller;
@dynamic page_ctrl_delegate;
@dynamic arr_contracts;
@synthesize hiddeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[(UITextField*)[self.view viewWithTag:6001] setEnabled:YES];
    [_txt_initial_date setEnabled:YES];
    
    
    _arr_investment         = [[NSMutableArray alloc] init];
    _arr_investment_headers = [[NSMutableArray alloc] init];
    
    _left_button.hidden =YES;
    _left_invert.hidden = YES;
    
    _todate =[[NSDateFormatter alloc]init];
    [_todate setDateFormat:@"dd/MMM/yy"];
    
    NSString *to_Date =[_todate stringFromDate:[NSDate date]];
    
    
   
    [_txt_initial_date setText: to_Date] ;
    [_txt_final_date setText: to_Date];

    #warning Textfields must show the current date
            
    NSLog(@"Flow: %d",self.flow);
    [self LastMonth];
    //[self today] ;
}

- (void)viewWillAppear:(BOOL)animated{
   
   
    
    NSLog(@"View Will Appear, contract type: %d",_contract_type);
    [super viewWillAppear:YES];
    if (hiddeView) {


    }else{
    [self.arr_contracts         removeAllObjects];
    [_arr_investment            removeAllObjects];
    [_arr_investment_headers    removeAllObjects];
    
    _current_index  = 0;
    
    if (_contract_type == UniContract) {
        [[self.view viewWithTag:345] setHidden: YES];
        [[self.view viewWithTag:346] setHidden: YES];
        [self.arr_contracts addObject:@[_contract_info]];
        [self setUpContractsHeader];
    }
    else{
        // Make the request for contracts info
        [LoadingView loadingViewWithMessage:nil];
        
        NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
        NSString *language     = @"?language=SPA";
        NSString *key =[[RequestManager sharedInstance] keyToSend];
        
        NSMutableString *headerString = [NSMutableString string];
        
        [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key, username, language]];
        NSLog(@"headerString = %@",headerString);
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :headerString} mutableCopy ]
                                                    toMethod:kRequestGetContracts isPost:NO];
        [[LoadingView loadingViewWithMessage:@"Cargando..."] show];
        
//        NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
//        NSLog(@"Here: %@", username);
//        
//        [[RequestManager sharedInstance] setDelegate:self];
//        [[RequestManager sharedInstance] sendRequestWithData:[@{@"1" :username,
//                                                                @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy ]
//                                                    toMethod:kRequestGetContracts isPost:NO];
      }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDetailData:(id)info{

    NSDictionary    *info_dict  = [[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index];
    
    if (self.flow == Investments) {
        NSLog(@"Update in investments");
        [_txt_cont_number       setText:[[info_dict objectForKey:@"idContrato"] stringValue]];
        [_txt_cont_name         setText:[info_dict objectForKey:@"aliasContrato"]];
        [_txt_cont_balance      setText:[Utility stringWithMoneyFormat:[[info_dict objectForKey:@"cuentaEje"] doubleValue]]];
        [_txt_cont_inv_balance  setText:[Utility stringWithMoneyFormat:[[info_dict objectForKey:@"cuentaInversiones"] doubleValue]]];
    }
    else if (self.flow == Movements) {
        NSLog(@"Update in movements");
    }
    else if (self.flow == Balances) {
        NSLog(@"Update in balances");
    }
}

#pragma mark - Movements Outlets

-(IBAction)openDate:(id)sender{
    NSDateFormatter*Monthdate =[[NSDateFormatter alloc]init];
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSDate * toDate=[NSDate date];
    NSDateComponents *Months=[[NSDateComponents alloc]init];
    [Months setMonth:-3];
    //[nextDate setDay:-1];
    NSDate *next = [calendar dateByAddingComponents:Months toDate:toDate options:0];
    [Monthdate setDateFormat:@"dMMyyyy"];

    UIDatePicker    *datePicker = [[UIDatePicker alloc] init];
    datePicker.tag              = ((UITextField *)sender).tag - 10;
    datePicker.datePickerMode   = UIDatePickerModeDate ;
    datePicker.maximumDate=[NSDate date];
    [Monthdate setDateFormat:@"dMMyyyy"];
    datePicker.minimumDate=next;
    [(UITextField *)sender setInputView:datePicker];
    [datePicker addTarget:self
                   action:@selector(datePickerChanged:)
         forControlEvents:UIControlEventValueChanged];
}

-(IBAction)datePickerChanged:(UIDatePicker *)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    //formatter.dateStyle = kCFDateFormatterShortStyle;
    if (sender.tag == 1) {      // Initial date
       [_txt_initial_date setText: [formatter stringFromDate:sender.date]];

    }
    else if (sender.tag == 2) {      // Final date
        [_txt_final_date setText: [formatter stringFromDate:sender.date]];
    }
}

-(void)responseFromService:(NSMutableDictionary *)response{
    #warning Validate the result is nil (Network error)
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
    #warning Validations for each service (no value-key, fields in blank, etc)
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContracts) {
        NSMutableArray  *cont_array = [response objectForKey:@"contracts"];
        NSMutableArray  *aux_array  = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *dict in cont_array) {
            if ([[dict objectForKey:@"empresa"] isEqualToString:@"Banco"]){
                [aux_array addObject:dict];
            }
        }
        [self.arr_contracts addObject:aux_array];
        
        NSLog(@"Arr contracts: %@",self.arr_contracts);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpContractsHeader];
            [LoadingView close];
        });
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContractToken) {
       
        NSLog(@"Index: %d",(int)self.page_ctrl_delegate.current_index);
        NSLog(@"Last pos: %d",[(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
        
  

        
        ContractHeader  *curr_header    = (ContractHeader *)[self.page_ctrl_delegate getCurrentController];
        NSDictionary    *curr_contra    = [self.page_ctrl_delegate getCurrentContract];
        curr_header.contract_token      = [[response objectForKey:@"result"] objectForKey:@"key"];  // Update the contract token
        
        // Request the investment portfolio
        if (self.flow == Investments) {
            // /7362569?language=SPA

            NSString *contract   = [curr_contra objectForKey:@"idContrato"];
            NSString *language     = @"?language=SPA";
            NSString *key = curr_header.contract_token;
            
            NSMutableString *headerString = [NSMutableString string];
            [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,contract, language]];
            NSLog(@"headerString = %@",headerString);
            [[RequestManager sharedInstance] setDelegate:self];
            [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                    @"append_key"  :headerString} mutableCopy ]
                                                        toMethod:kRequestInvPortfolio isPost:NO];
           //[[LoadingView loadingViewWithMessage:@"Generando llave"] show];
            
//            
//            [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  : curr_header.contract_token,
//                                                                     @"1"           : [curr_contra objectForKey:@"idContrato"],
//                                                                     } mutableCopy]
//                                                        toMethod:kRequestInvPortfolio
//                                                          isPost:NO];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView close];
            });
        }
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestInvPortfolio) {
        NSArray *list_1 = [[[[response objectForKey:@"outFIXISSecuritiesPortfolioQuery"] objectForKey:@"fundsList"] objectAtIndex:0] objectForKey:@"fundPortfolioList"];
        
        if (list_1.count != 0) {
            ContractHeader  *curr_header    = (ContractHeader *)[self.page_ctrl_delegate getCurrentController];
            NSDictionary    *contract_info  = [self.page_ctrl_delegate getCurrentContract];
            [_arr_investment_headers    addObject:@"Sociedades de Inversión"];
            [_arr_investment            addObject:list_1];
           
            
            // Request the money maket list      /TODO/7362569?language=SPA
            NSString *key = curr_header.contract_token;
            NSString *contract   = [contract_info objectForKey:@"idContrato"];
            NSMutableString *headerString = [NSMutableString string];
            [headerString appendString:[NSString stringWithFormat:@"%@/TODO/%@?language=SPA", key,contract]];
            NSLog(@"headerString = %@",headerString);
            //[[LoadingView loadingViewWithMessage:@"Cargando"] show];
            [[RequestManager sharedInstance] setDelegate:self];
            [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                    @"append_key"  :headerString} mutableCopy ]
                                                        toMethod:kRequestMoneyMarket isPost:NO];
            //[[LoadingView loadingViewWithMessage:@"Cargando"] show];

            
            
//            [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  : curr_header.contract_token,
//                                                                     @"1"           :@"TODO",
//                                                                     @"2"           :[contract_info objectForKey:@"idContrato"],
//                                                                     } mutableCopy]
//                                                        toMethod:kRequestMoneyMarket
//                                                          isPost:NO];
            
        }
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestMoneyMarket) {
        NSArray *list_2 = [[response objectForKey:@"outFIXMMSecuritiesPortfolioQuery"] objectForKey:@"accountTypeList"];
        
        if (list_2.count != 0) {
            [_arr_investment_headers    addObject:@"Mercado de dinero"];
            NSMutableArray  *final_list = [[NSMutableArray alloc] init];
            for (NSDictionary *info in list_2) {
                for(id key in info)
                    [final_list addObjectsFromArray:[info objectForKey:key]];
            }
            
            [_arr_investment            addObject:final_list];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            [_tbv_investment_data reloadData];
        });
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestMovements) {        
        NSMutableArray *arr_movements = [[response objectForKey:@"outContractMovementsQuery"] objectForKey:@"movementsList"];
        if (arr_movements.count != 0)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"segueMovementsList" sender:arr_movements];
            });        
    }
}

-(void)setUpContractHeaderWithPageCtrl: (UIPageViewController*)pageViewCtrl inView:(UIView*)view
                           andDelegate:(ContractHeaderPageViewCtrlDelegate*)delegate{
    
    [[pageViewCtrl view] setFrame:[view bounds]];
    [view addSubview:[pageViewCtrl view]];
    [pageViewCtrl didMoveToParentViewController:self];
    
    pageViewCtrl.delegate           = delegate;
    pageViewCtrl.dataSource         = delegate;
    
    ContractHeader *firstContract   = [delegate viewControllerAtIndex:0];
    NSArray *viewControllers        = @[firstContract];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)setUpContractsHeader{
    
    if (self.page_controller == nil)
        [super setUpBaseHeader];
    
    //[super setUpBaseHeader];
    
    ContractHeader *firstContract = [self.page_ctrl_delegate viewControllerAtIndex:0];
    
    if (_contract_type == UniContract)
        firstContract.contract_token    = [_contract_info objectForKey:@"contract_token"];
    
    if (self.flow == Investments || self.flow == Movements) // Make the request for the first contract token
        [self getCurrentToken:firstContract.contract_token inContract:[[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index]];
}

-(void)getCurrentToken:(NSString *)currentToken inContract:(NSDictionary *)contractInfo{
    [self updateDetailData:[[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index]];
    
    
    NSLog(@"Index: %d",(int)self.page_ctrl_delegate.current_index);
    NSLog(@"Last pos: %d",[(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    
    int index =(int)self.page_ctrl_delegate.current_index ;
    int last_pos = ([(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    if (index == 0) {
        _left_button.hidden =YES;
        _rigth_buton.hidden =NO;
        
    }else if (index == last_pos )
    {
        _left_button.hidden =NO;
        _rigth_buton.hidden =YES;
        
        
    }else{
        _left_button.hidden =NO;
        _rigth_buton.hidden =NO;
        
    }
    if (currentToken == NULL) { // Request the token for the contract
//        [[LoadingView loadingViewWithMessage:nil] show];
        
        NSMutableDictionary    *info_dict  = [[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index];

        NSMutableDictionary *params = [@{ @"tipoServicio": [info_dict objectForKey:@"tipoServicio"],
                                          @"contract"  : [[info_dict objectForKey:@"idContrato"] stringValue],
                                          @"empresa"     : [info_dict objectForKey:@"empresa"],
                                          @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
        [RequestManager sharedInstance].delegate = self;
        [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
        [[LoadingView loadingViewWithMessage:@"Cargando..."] show];  // 31- julio

    }
    else{   // The contract has a token, make the investment requests
        if (self.flow == Investments) {
            NSString  *contract_token       = ((ContractHeader *)[self.page_ctrl_delegate getCurrentController]).contract_token;
            NSDictionary    *curr_contra    = [self.page_ctrl_delegate getCurrentContract];
            
            // /7362569?language=SPA
            NSString *contract   = [curr_contra objectForKey:@"idContrato"];
            NSString *language     = @"?language=SPA";
            NSString *key = contract_token;
            
            NSMutableString *headerString = [NSMutableString string];
            [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,contract, language]];
            NSLog(@"headerString = %@",headerString);
            //[[LoadingView loadingViewWithMessage:@"Cargando"] show];  // 13-julio

            [[RequestManager sharedInstance] setDelegate:self];
            [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                    @"append_key"  :headerString} mutableCopy ]
                                                        toMethod:kRequestInvPortfolio isPost:NO];
//            [RequestManager sharedInstance].delegate = self;
//            [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  : contract_token,
//                                                                     @"1"           : [curr_contra objectForKey:@"idContrato"],
//                                                                     } mutableCopy]
//                                                        toMethod:kRequestInvPortfolio
//                                                          isPost:NO];
        }
    }
}


#pragma mark - ContractHeaderDelegate

-(void)getCurrentToken:(NSString *)token inContractIndex:(int)index inPageViewCtrWithTag:(int)tag{
    NSLog(@"Protocol final");
    [_arr_investment            removeAllObjects];
    [_arr_investment_headers    removeAllObjects];
    _current_index              = index;
    
    if (self.flow == Investments || self.flow == Movements) // Make the request for the current contract token
        [self getCurrentToken:token inContract:[[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index]];
    
    
    int index_2 =(int)self.page_ctrl_delegate.current_index ;
    int last_pos_2 = ([(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    if (index_2 == 0) {
        _left_invert.hidden =YES;
        _rigth_invert.hidden =NO;
        
    }else if (index_2 == last_pos_2 )
    {
        _left_invert.hidden =NO;
        _rigth_invert.hidden =YES;
        
        
    }else{
        _left_invert.hidden =NO;
        _rigth_invert.hidden =NO;
        
    }

}

#pragma mark - Investments Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_arr_investment objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_investment_headers.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_arr_investment_headers objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCellIdentifier"
                                                                  forIndexPath:indexPath];
    
    if ([[_arr_investment_headers objectAtIndex:indexPath.section] isEqualToString:@"Sociedades de Inversión"]) {   // Investments
        NSDictionary    *info   =   [[_arr_investment objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
        
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[info objectForKey:@"issuerName"]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[[info objectForKey:@"securities"] stringValue]];
        //[aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"securities"] doubleValue]]];
        

        aux_lbl        =   (UILabel *)[cell viewWithTag:103];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[[info objectForKey:@"priceMXN"] objectForKey:@"price"] doubleValue]]];
       // [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"Price"] doubleValue]]];

        
        aux_lbl        =   (UILabel *)[cell viewWithTag:104];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[[info objectForKey:@"valuationMXN"] objectForKey:@"valuation" ] doubleValue]]];

    }
    
    else if ([[_arr_investment_headers objectAtIndex:indexPath.section] isEqualToString:@"Mercado de dinero"]) {   // Money Market
        NSDictionary    *info   =   [[_arr_investment objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
        
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[[info objectForKey:@"issuerName"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[info objectForKey:@"position"]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:103];
        [aux_lbl setText:[[info objectForKey:@"days"] stringValue]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:104];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"actualValue"] doubleValue]]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210.f;
}

#pragma mark - Movements Logic

-(IBAction)getMovementsForContract:(id)sender{
    
    #warning Validations for date fields (3 monts interval max)
    
    
    
//API_URL = WS_Actinver.BASE_ACTINVER_WS + WS_Actinver.PRC09 + json;// + key + "/" + 7156896 + "/01/" + 28022015 + "/" + 27052015 + "?language=SPA";

       ContractHeader  *curr_header    = (ContractHeader *)[self.page_ctrl_delegate getCurrentController];
       NSDictionary    *curr_contr     = (NSDictionary *)[[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index];
    
     // /7156896/01/28022015/27052015?language=SPA
    _todate =[[NSDateFormatter alloc]init];
    [_todate setDateFormat:@"dMMyyyy"];
    NSLog(@"today: %@",[_todate stringFromDate:[NSDate date]]);
    
    NSString *keyUSM02  = curr_header.contract_token;
    NSString *contact   = [curr_contr objectForKey:@"idContrato"];
    NSString *number    = @"/01/";
    NSString *today     = [_todate stringFromDate:[NSDate date]];
    NSString *lastmount = _Month;  // NSDate *lastmount = _Month;
    NSString *language     = @"?language=SPA";
    NSMutableString *headerString = [NSMutableString string];
    [headerString appendString:[NSString stringWithFormat:@"%@/%@%@%@/%@%@", keyUSM02,contact, number, lastmount, today, language]];

    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData: [@{ @"append_key"  :headerString} mutableCopy ]
                                                toMethod:kRequestMovements
                                                  isPost:NO]; // Request the contract movements
    [[LoadingView loadingViewWithMessage:nil] show];
    
//    ContractHeader  *curr_header    = (ContractHeader *)[self.page_ctrl_delegate getCurrentController];
//    NSDictionary    *curr_contr     = (NSDictionary *)[[self.arr_contracts objectAtIndex:0] objectAtIndex:_current_index];
//    NSDictionary *params = [@{ @"append_key"     : curr_header.contract_token,
//                              @"1"              : [[curr_contr objectForKey:@"idContrato"] stringValue],
//                              @"2"              : @"01",
//                              @"3"              : [[_txt_initial_date text] stringByReplacingOccurrencesOfString:@"/" withString:@""],
//                              @"4"              : [[_txt_final_date text] stringByReplacingOccurrencesOfString:@"/" withString:@""],
//                              }mutableCopy];
//
//    [[RequestManager sharedInstance] sendRequestWithData:[params mutableCopy]   // Request the contract movements
//                                                toMethod:kRequestMovements
//                                                  isPost:YES];
}

-(void)LastMonth{
    NSDateFormatter*Monthdate =[[NSDateFormatter alloc]init];
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSDate * toDate=[NSDate date];
    NSDateComponents *Months=[[NSDateComponents alloc]init];
    [Months setMonth:-3];
    //[nextDate setDay:-1];
    NSDate *next = [calendar dateByAddingComponents:Months toDate:toDate options:0];
    [Monthdate setDateFormat:@"dMMyyyy"];
    _Month = (NSString *)[NSString stringWithFormat:@"%@",[Monthdate stringFromDate:next]];
    NSLog(@"Monthdate : %@",_Month);
  
}

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"segueMovementsList"]) {
         // Cuenta Eje: movementType D,C, Retiro, Deposito
         MovementsListViewController *aux   = segue.destinationViewController;
         aux.arr_movements                  = (NSMutableArray *)sender;
         [LoadingView close];
     }
 }

#pragma mark -> Disable "copy-paste"
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

@end
