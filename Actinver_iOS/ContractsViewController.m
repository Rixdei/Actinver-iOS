//
//  ContractsViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//Contractvc

#import "ContractsViewController.h"
#import "LoadingView.h"
#import "ContractDetailViewController.h"
#import "DataEntryModalView.h"
#import "RequestManager.h"
#import "Utility.h"

@interface ContractsViewController ()<UITableViewDelegate,UITableViewDataSource,ResponseFromServicesDelegate>

@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)               NSMutableArray  *arr_contracts;

@end

@implementation ContractsViewController
@synthesize hiddeView;

- (void)viewDidLoad {
    NSLog(@"ViewDidLoad");
    [super viewDidLoad];

    _arr_contracts  = nil;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ViewWillAppear");
    
//    if (hiddeView) {
//        
//        
//    }else{
    
    if (_arr_contracts != nil) {
        return;
    }
    
    // Make the request for contracts info
//    [[LoadingView loadingViewWithMessage:@"Consultando contratos ... "] show];
    
    _arr_contracts  = [[NSMutableArray alloc] init];
    
//    NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
//    NSLog(@"Here: %@", username);
//    
//    [[RequestManager sharedInstance] setDelegate:self];
//    [[RequestManager sharedInstance] sendRequestWithData:[@{@"1" :username,
//                                                            @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy ]
//                                                toMethod:kRequestGetContracts isPost:NO];
    
        if (hiddeView) {
    
    
        }else{
    NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
    NSString *params     = @"?language=SPA";
    NSString *key =[[RequestManager sharedInstance] keyToSend];
    
    NSMutableString *headerString = [NSMutableString string];
    
    [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,username, params]];
    NSLog(@"headerString = %@",headerString);
    

    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                            @"append_key"  :headerString} mutableCopy ]
                                                toMethod:kRequestGetContracts isPost:NO];
    [[LoadingView loadingViewWithMessage:@"Consultando contratos ... "] show];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr_contracts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"ContractsCellIdentifier"
                                                                  forIndexPath:indexPath];
    
    NSDictionary    *info   =   [_arr_contracts objectAtIndex:indexPath.row];
    UILabel *aux_lbl        =   (UILabel *)[cell viewWithTag:101];
    aux_lbl.tag             =   indexPath.row;
    [aux_lbl setText:[info objectForKey:@"aliasContrato"]];

    aux_lbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEditContractAliasView:)];
    [aux_lbl addGestureRecognizer:tapGesture];

    aux_lbl        =   (UILabel *)[cell viewWithTag:102];
    [aux_lbl setText:[[info objectForKey:@"idContrato"] stringValue]];
    
    aux_lbl        =   (UILabel *)[cell viewWithTag:104];
    [aux_lbl setText:[info objectForKey:@"empresa"]];
    
    aux_lbl        =   (UILabel *)[cell viewWithTag:105];
    [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"cuentaEje"] doubleValue]]];
    
    aux_lbl        =   (UILabel *)[cell viewWithTag:106];
    [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"cuentaInversiones"] doubleValue]]];
    
    aux_lbl        =   (UILabel *)[cell viewWithTag:107];
    [aux_lbl setText:[Utility stringWithMoneyFormat:[[info objectForKey:@"total"] doubleValue]]];
    
    
    if (_flow == AdmonOwnContracts) {
        UIButton  *btn = (UIButton *)[cell viewWithTag:109];
        btn.tag        = indexPath.row;
        [btn addTarget:self
                action:@selector(openContractDetail:)
      forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        UIButton  *btn = (UIButton *)[cell viewWithTag:108];
        btn.tag        = indexPath.row;
        [btn addTarget:self
                action:@selector(openContractDetail:)
      forControlEvents:UIControlEventTouchUpInside];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flow == AdmonOwnContracts) {
        NSLog(@"Own COntracts");
        return 195.f;
    }
    else{
        return 165.f;
    }
}

-(void)responseFromService:(NSMutableDictionary *)response{
    #warning Validate the result is nil (Network error)
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
    
    
    #warning Validations for each service (no value-key, fields in blank, etc)
    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContracts) {
        NSLog(@"Get Contracts response");
        NSMutableArray  *cont_array = [response objectForKey:@"contracts"];
        NSLog(@"contracts------>%@",cont_array);
        NSString*contracts = [[[response objectForKey:@"contracts"]  objectAtIndex:0] objectForKey:@"idContrato"];
        [[RequestManager sharedInstance]setNumberContract:contracts];
        
        for (NSMutableDictionary *dict in cont_array) {
            if ([[dict objectForKey:@"empresa"] isEqualToString:@"Banco"]){//Banco
                [_arr_contracts addObject:dict];
        }else if ([[dict objectForKey:@"empresa"] isEqualToString:@"Casa"]){//casa
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alerta" message:@"No existe contratos" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//            [alert show];

        }}
        
        #warning Validations final contract list is empty
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [LoadingView close];
        });
    }
    

}

-(IBAction)openContractDetail:(UIButton *)sender{
    [self performSegueWithIdentifier:@"segueContractDetail" sender:[_arr_contracts objectAtIndex:(int)sender.tag]];
}

-(IBAction)openEditContractAliasView:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"1001" sender:[NSNumber numberWithInt:(int)sender.view.tag]];  // 1001 is the corresponding flow to update contract alias
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueContractDetail"]) {
        ContractDetailViewController    *aux    = segue.destinationViewController;
        aux.contract_info                       = [(NSDictionary*)sender mutableCopy];
    }
    else if ([segue.identifier isEqualToString:@"1001"]) {
        DataEntryModalView    *aux  = segue.destinationViewController;
        aux.kModalFlow              = [segue.identifier intValue];
        aux.aditionalData           = [_arr_contracts objectAtIndex:[sender intValue]];
    }
}

/*t
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
