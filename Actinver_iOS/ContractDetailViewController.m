//
//  ContractDetailViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 21/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ContractDetailViewController.h"
#import "UserMenuViewController.h"
#import "InqAndMovsViewController.h"
#import "LoadingView.h"
#import "Utility.h"
#import "RequestManager.h"

@interface ContractDetailViewController ()<ResponseFromServicesDelegate,UserMenuDelegate>

@property (nonatomic, weak) IBOutlet    UILabel     *txt_contract;
@property (nonatomic, weak) IBOutlet    UILabel     *txt_balance;
@property (nonatomic, weak) IBOutlet    UILabel     *txt_contract_type;

@property (nonatomic, weak) IBOutlet    UITableView *tbv_contract_data;

@property (nonatomic, strong)           NSString    *contract_token;

@property (nonatomic, strong)           NSMutableArray          *arr_section_headers;
@property (nonatomic, strong)           NSMutableArray          *arr_contract_detail;

@end


@implementation ContractDetailViewController

- (void)viewDidLoad {
    
    _arr_section_headers    = [[NSMutableArray alloc] init];
    _arr_contract_detail    = [[NSMutableArray alloc] init];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    

    
    [_arr_section_headers removeAllObjects];
    [_arr_contract_detail removeAllObjects];

    [_txt_contract setText:[NSString stringWithFormat:@"                Contrato: %@",[[_contract_info objectForKey:@"idContrato"] stringValue]]];
    [_txt_balance setText:[NSString stringWithFormat:@"                   Cuenta Eje: %@",[Utility stringWithMoneyFormat:[[_contract_info objectForKey:@"cuentaEje"] doubleValue]]]];
    [_txt_contract_type setText:[NSString stringWithFormat:@"                Familia: %@",[_contract_info objectForKey:@"tipoServicio"]]];
    
    //[[LoadingView loadingViewWithMessage:nil] show];
    //  empresa=Casa&tipoServicio=Asesorado&contract=1048057   empresa=Casa&tipoServicio=Asesorado&contract=1048057

    NSMutableDictionary *params = [@{ @"tipoServicio"   :[_contract_info objectForKey:@"tipoServicio"],
                                      @"contract"       :[[_contract_info objectForKey:@"idContrato"] stringValue],
                                      @"empresa"        :[_contract_info objectForKey:@"empresa"],
                                      @"append_key"     :[[RequestManager sharedInstance] keyToSend]} mutableCopy];

    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
    [[LoadingView loadingViewWithMessage:nil] show];

    [super viewWillAppear:YES];
}

#pragma mark - Request Manager

-(void)responseFromService:(NSMutableDictionary *)response{
    #warning Validate the result is nil (Network error)
    if ([response objectForKey:@"act_net_error"] != NULL) {

        if ([[response objectForKey:@"method_code"] intValue] == kRequestCEDEInvest){
            
//            if ( [[response objectForKey:@"outFixedTermInvestmentQuery"] objectForKey:@"fixedTermIvestment"] == 0){
//                UIAlertView *AlertCEDE = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No hay Informacion Disponible" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [AlertCEDE show];
//            }
            
        }
        return;
    }
    
    
    #warning Validations for each service (no value-key, fields in blank, etc)
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContractToken) {
        _contract_token      = [[response objectForKey:@"result"] objectForKey:@"key"];     // Update the contract token
        [_contract_info setValue:_contract_token forKey:@"contract_token"];                 // Store the contract token for next requests
        
        NSString *TODO    = @"TODO";
        NSString *idContract = [_contract_info objectForKey:@"idContrato"];
        NSString *key     = [_contract_info objectForKey:@"contract_token"];
        NSString *params  = @"?language=SPA";
        NSMutableString *parameters = [NSMutableString string];
        [parameters appendString:[NSString stringWithFormat:@"%@/%@/%@%@",key,TODO,idContract,params]];
        // Request the money maket list       parameters: /TODO/7362569?language=SPA
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :parameters} mutableCopy ]
                                                            toMethod:kRequestMoneyMarket isPost:NO];
        //[[LoadingView loadingViewWithMessage:nil] show];
        
        
//        [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  : [_contract_info objectForKey:@"contract_token"],
//                                                                 @"1"           :@"TODO",
//                                                                 @"2"           :[_contract_info objectForKey:@"idContrato"],
//                                                                 } mutableCopy]
//                                                    toMethod:kRequestMoneyMarket
//                                                      isPost:NO];

    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestMoneyMarket) {
        NSArray *list = [[response objectForKey:@"outFIXMMSecuritiesPortfolioQuery"] objectForKey:@"accountTypeList"];
        if (list.count != 0) {
        //if (list.count == 0) {
            [_arr_section_headers    addObject:@"Mercado de dinero"];
            NSMutableArray  *final_list = [[NSMutableArray alloc] init];
            for (NSDictionary *info in list) {
                for(id key in info)
                    [final_list addObjectsFromArray:[info objectForKey:key]];
            }
            
            [_arr_contract_detail            addObject:final_list];
        }

        NSString *keytoken  = _contract_token;
        NSString *contrac  = [_contract_info objectForKey:@"idContrato"];
        NSString *A01TD1   = @"01TD1";
        NSString *lastDate = [[RequestManager sharedInstance] initial_Year];;
        NSString *nextDate = [[RequestManager sharedInstance] next_Year];
//        NSString *lastDate = [Utility getDateInWSFormat:[NSDate date]];
//        NSString *nextDate = [Utility getOneYearDifferenceFromNow:NO];
        NSMutableString *parameters = [NSMutableString string];
//        [parameters appendString:[NSString stringWithFormat:@"%@/%@/%@/1/%@/%@?language=SPA",keytoken,contrac,_01TD1,lastDate,nextDate]];
        [parameters appendString:[NSString stringWithFormat:@"%@/%@/%@/1/%@/%@?language=SPA",keytoken,contrac,A01TD1,lastDate,nextDate]];

        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :parameters} mutableCopy]   // Request the fixed term investment list
                                                    toMethod:kRequestCEDEInvest
                                                      isPost:NO];
        
//        [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key": _contract_token,
//                                                                 @"1"         :[_contract_info objectForKey:@"idContrato"],
//                                                                 @"2"         :@"01TD1",
//                                                                 @"3"         :[Utility getDateInWSFormat:[NSDate date]],
//                                                                 @"4"         :[Utility getOneYearDifferenceFromNow:NO]
//                                                                 } mutableCopy]   // Request the fixed term investment list
//                                                    toMethod:kRequestCEDEInvest
//                                                      isPost:NO];
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestCEDEInvest) {
        NSArray *list = [[response objectForKey:@"outFixedTermInvestmentQuery"] objectForKey:@"fixedTermIvestment"];
        if (list.count != 0) {
        //if (list.count == 0) {

            [_arr_section_headers    addObject:@"Cede Vigente"];
            [_arr_contract_detail    addObject:list];
        }
        
       // [[RequestManager sharedInstance]setInitial_Year:_iniYear];
        [[RequestManager sharedInstance] initial_Year];
        [[RequestManager sharedInstance] next_Year];
        // /7362569/01TDA/1/8042014/7042016?language=SPA
        NSString *keytoken  = _contract_token;
        NSString *contrac  = [_contract_info objectForKey:@"idContrato"];
        NSString *A01TD1   = @"01TDA";
        NSString *lastDate = [[RequestManager sharedInstance] initial_Year];;
        NSString *nextDate = [[RequestManager sharedInstance] next_Year];
//        NSString *lastDate = [Utility getDateInWSFormat:[NSDate date]];
//        NSString *nextDate = [Utility getOneYearDifferenceFromNow:YES];
       
       NSMutableString *parameter = [NSMutableString string];
       [parameter appendString:[NSString stringWithFormat:@"%@/%@/%@/1/%@/%@?language=SPA",keytoken,contrac,A01TD1,lastDate,nextDate]];
       
        [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  :parameter
                                                                 } mutableCopy]   // Request the fixed term investment list
                                                    toMethod:kRequestFixedTermInvest
                                                      isPost:NO];

//        [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key": _contract_token,
//                                                                 @"1"         :[_contract_info objectForKey:@"idContrato"],
//                                                                 @"2"         :@"01TDA",
//                                                                 @"3"         :[Utility getDateInWSFormat:[NSDate date]],
//                                                                 @"4"         :[Utility getOneYearDifferenceFromNow:YES]
//                                                                 } mutableCopy]   // Request the fixed term investment list
//                                                    toMethod:kRequestCEDEInvest  kRequestFixedTermInvest
//                                                      isPost:NO];
    }
   else if ([[response objectForKey:@"method_code"] intValue] == kRequestFixedTermInvest) {
   //else if ([[response objectForKey:@"method_code"] intValue] == kRequestCEDEInvest) {
        NSArray *list = [[response objectForKey:@"outFixedTermInvestmentQuery"] objectForKey:@"fixedTermIvestment"];
        if (list.count != 0) {
            [_arr_section_headers    addObject:@"Pagaré Vigente"];
            [_arr_contract_detail    addObject:list];
            
            // /7362569?language=SPA
            NSString *keytoken  = [_contract_info objectForKey:@"contract_token"];
            NSString *contract  = [_contract_info objectForKey:@"idContrato"];

            NSMutableString *parameter = [NSMutableString string];
            [parameter appendString:[NSString stringWithFormat:@"%@/%@?language=SPA",keytoken,contract]];
            
            [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  :parameter
                                                                     } mutableCopy]   // Request the fixed term investment list
                                                        toMethod:kRequestInvPortfolio
                                                          isPost:NO];
            
//            [[RequestManager sharedInstance] sendRequestWithData:[@{ @"append_key"  : [_contract_info objectForKey:@"contract_token"],
//                                                                     @"1"           : [_contract_info objectForKey:@"idContrato"],
//                                                                     } mutableCopy]
//                                                        toMethod:kRequestInvPortfolio
//                                                          isPost:NO];
        }
    }
    else if ([[response objectForKey:@"method_code"] intValue] == kRequestInvPortfolio) {
        NSArray *list = [[[[response objectForKey:@"outFIXISSecuritiesPortfolioQuery"] objectForKey:@"fundsList"] objectAtIndex:0] objectForKey:@"fundPortfolioList"];
        
        if (list.count != 0) {
            [_arr_section_headers    addObject:@"Sociedades de Inversión"];
            [_arr_contract_detail    addObject:list];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            [_tbv_contract_data reloadData];
        });
    }
}

#pragma mark - Contract Detail TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_arr_contract_detail objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_section_headers.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_arr_section_headers objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"InvestmentCellIdentifier"
                                                                  forIndexPath:indexPath];
    NSDictionary    *info   =   [[_arr_contract_detail objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
    
    if ([[_arr_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Mercado de dinero"]) {   // Money Market
        
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[info objectForKey:@"issuerName"]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"actualValue"] doubleValue]]];
    }
    
    else if ([[_arr_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Cede Vigente"]) {   // Cede
        
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[[info objectForKey:@"termName"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"amount"] doubleValue]]];
    }
    
    else if ([[_arr_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Pagaré Vigente"]) {   // Fixed term
        
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[[info objectForKey:@"termName"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"amount"] doubleValue]]];
    }
    
    else if ([[_arr_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Sociedades de Inversión"]) {   // Investment
        UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
        [aux_lbl setText:[[info objectForKey:@"issuerName"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        aux_lbl        =   (UILabel *)[cell viewWithTag:102];
        [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"valuation"] doubleValue]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210.f;

}

#pragma mark - User Menu

- (IBAction)btnUserOptions:(id)sender {
    [self performSegueWithIdentifier:@"segueOpenUserOptions" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueOpenUserOptions"]) {
        UserMenuViewController  *aux    = (UserMenuViewController *)segue.destinationViewController;
        aux.delegate                    = self;
    }
    else{
        InqAndMovsViewController *aux   = segue.destinationViewController;
        aux.flow                        = [(NSNumber*)sender intValue];
        aux.contract_info               = _contract_info;
        aux.contract_type               = UniContract;
    }
}

#pragma mark - User Menu Delegate

- (void) openSubMenu:(int)tag{
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",tag] sender:[NSNumber numberWithInt:tag]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
