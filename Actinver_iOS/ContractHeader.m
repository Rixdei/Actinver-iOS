//
//  ContractHeader.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ContractHeader.h"
#import "Utility.h"

@interface ContractHeader ()

@property (nonatomic,weak) IBOutlet UILabel *txt_contract_name;
@property (nonatomic,weak) IBOutlet UILabel *txt_contract_balance;
@property (nonatomic,weak) IBOutlet UILabel *txt_contract_type;

@end

@implementation ContractHeader

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_header_type == kOtherBanksHeader) {    // Inspect other keys
        [_txt_contract_name setText:[NSString stringWithFormat:@"                 %@",[_contract_info objectForKey:@"bankName"]]];
        [_txt_contract_balance setText:[NSString stringWithFormat:@"                   Contrato %@",[_contract_info objectForKey:@"contractNumber"]]];
        [_txt_contract_type setText:[NSString stringWithFormat:@"                 %@",[_contract_info objectForKey:@"accountNumber"]]];
    }
    else if (_header_type == kSlaveHeader) {    // Inspect other keys
        [_txt_contract_name setText:[NSString stringWithFormat:@"                 Contrato %@",[_contract_info objectForKey:@"contractNumber"]]];
        [_txt_contract_balance setText:[NSString stringWithFormat:@"                   Cantidad máxima %@",
                                        [Utility stringWithMoneyFormat:[[_contract_info objectForKey:@"maxAmount"] doubleValue]]]];        
        [_txt_contract_type setText:[NSString stringWithFormat:@"                 %@",[_contract_info objectForKey:@"alias"]]];
    }
    else if (_header_type == kPayCreditCard){ // Inspect PayCredictCard
        [_txt_contract_name setText:[NSString stringWithFormat:@"                 %@",[[_contract_info objectForKey:@"bankAccounts"] objectForKey:@"alias"]]];
        [_txt_contract_balance setText:[NSString stringWithFormat:@"                   Cantidad máxima %@",
                                        [Utility stringWithMoneyFormat:[[[_contract_info objectForKey:@"bankAccounts"] objectForKey:@"maxAmount"] doubleValue]]]];
        [_txt_contract_type setText:[NSString stringWithFormat:@"                 %@",[[_contract_info objectForKey:@"contract"] objectForKey:@"creditCardNumber"]]];
    }
    else{
        [_txt_contract_name setText:[NSString stringWithFormat:@"                 Contrato %@",[[_contract_info objectForKey:@"idContrato"] stringValue]]];
        [_txt_contract_balance setText:[NSString stringWithFormat:@"                    Cuenta Eje: %@",
                                    [Utility stringWithMoneyFormat:[[_contract_info objectForKey:@"cuentaEje"] doubleValue]]]];
    
        [_txt_contract_type setText:[NSString stringWithFormat:@"                 %@",[_contract_info objectForKey:@"aliasContrato"]]];
    }

    _contract_token  = NULL;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
