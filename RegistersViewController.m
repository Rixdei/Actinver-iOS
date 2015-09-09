//
//  RegistersViewController.m
//  Actinver_iOS
//
//  Created by David Fernando Guia Orduña on 04/08/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "RegistersViewController.h"

#import "RadioButton.h"
#import "ModalEntryDataViewController.h"
#import "ConfirmHighsDataViewController.h"
#import "RequestManager.h"
#import "CustomizeControl.h"
#import "LoadingView.h"

#define kActinverContractRadioButton     501    //  kActinverContractRadioButton     kActinverTagRadioButton
#define kInterbanCLABERadioButton        502    //  kInterbanCLABERadioButton        kOtherBanksTagRadioButton
#define kServicesTagRadioButton     401
#define kAirTimeTagRadioButton      402

@interface RegistersViewController ()<ResponseFromServicesDelegate,ContractHeaderDelegate,NotifyModalEventsDelegate,
                                      UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


// Transfers (Own contracts)
@property (nonatomic, strong)               UIPageViewController                *page_controller_slave;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate_slave;

// Transfers (Other banks)
@property (nonatomic, strong)               UIPageViewController                *page_controller_otherBanks;
@property (nonatomic, strong)               ContractHeaderPageViewCtrlDelegate  *page_ctrl_delegate_otherBanks;

//@property (nonatomic, strong)   IBOutlet    UICollectionView                    *collection_services;

@property (nonatomic, strong)               NSMutableArray                      *arr_act_accounts;
@property (nonatomic, strong)               NSMutableArray                      *arr_other_banks;
@property (nonatomic, strong)               NSMutableArray                      *arr_user_services;
@property (nonatomic, strong)               NSMutableArray                      *arr_basic_services;

@property                                   int master_index;
@property                                   int slave_index;

@property                                   int services_selected_index;

@property (weak, nonatomic) IBOutlet UIImageView *rigth_buttom;
@property (weak, nonatomic) IBOutlet UIImageView *left_buttom;



@property (nonatomic, assign)               UITextField     *active_txt;
@property (nonatomic, assign) IBOutlet      UIScrollView    *scrll_view;




@end

@implementation RegistersViewController{

    UITextField * bank;
    UITextField * Service;
    UITextField * Amount;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initializeView];
    _left_buttom.hidden = YES;
    // Registers Counts
    NSAttributedString *textBank = [[NSAttributedString alloc] initWithString:@"Selecciona Banco" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:5001] setAttributedPlaceholder:textBank];

    NSAttributedString *textAddress = [[NSAttributedString alloc] initWithString:@"Nombre de destinatario" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:5002] setAttributedPlaceholder:textAddress];
    
    NSAttributedString *textInterbank = [[NSAttributedString alloc] initWithString:@"Número de Contrato Actinver" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:5003] setAttributedPlaceholder:textInterbank];
    
    NSAttributedString *textAlias = [[NSAttributedString alloc] initWithString:@"Crea un Alias" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:5004] setAttributedPlaceholder:textAlias];
    
    NSAttributedString *textAmountMax = [[NSAttributedString alloc] initWithString:@"Monto máximo de pago en pesos (MXN)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:5005] setAttributedPlaceholder:textAmountMax];
    
    if ([(RadioButton *)[self.view viewWithTag:kActinverContractRadioButton] isSelected]) {
        NSAttributedString *textContract = [[NSAttributedString alloc] initWithString:@"Correo Electrónico" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [(UITextField*)[self.view viewWithTag:5006] setAttributedPlaceholder:textContract];
        
       [(UITextField*)[self.view viewWithTag:5001] setHidden:YES];
    }
    
    // Registers Services
    NSAttributedString *textService = [[NSAttributedString alloc] initWithString:@"Selecciona Servicio" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:6001] setAttributedPlaceholder:textService];
    [(UITextField*)[self.view viewWithTag:6001] setEnabled:YES];
    
    Amount = (UITextField*)[self.view viewWithTag:6003];
    [Amount setDelegate:self];
    
    NSAttributedString *txtAlias_Service = [[NSAttributedString alloc] initWithString:@"Crea un Alias" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:6002] setAttributedPlaceholder:txtAlias_Service];
    
    NSAttributedString *txtAmountMax = [[NSAttributedString alloc] initWithString:@"Monto máximo de pago en pesos (MXN)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [(UITextField*)[self.view viewWithTag:6003] setAttributedPlaceholder:txtAmountMax];

    
}

- (void) initializeView{
    
    [self.arr_contracts removeAllObjects];
    
    
    _master_index               = _slave_index  = 0;
    
    _page_controller_slave      = nil;
    
    _arr_basic_services         = nil;
    
    _services_selected_index    = 0;
    
    [(RadioButton *)[self.view viewWithTag:kActinverContractRadioButton] setSelected:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:YES];
    
    [self registerForKeyboardNotifications];
    
    UIBarButtonItem *btn_continue = [[UIBarButtonItem alloc] initWithTitle:@"Continuar"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(continueTransaction:)];
    
    if (_page_controller_slave != nil || _arr_basic_services != nil || arrayServices != nil) {
        return;
    }
    
    NSArray *actionButtonItems = @[btn_continue];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

        [[LoadingView loadingViewWithMessage:nil] show];    // Comming from drawer option
        NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
        NSLog(@"Here: %@", username);
        
        NSString *language     = @"?language=SPA";
        NSString *key =[[RequestManager sharedInstance] keyToSend];
        NSMutableString *headerString = [NSMutableString string];
        
        [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,username, language]];
        NSLog(@"headerString = %@",headerString);
    
        [[RequestManager sharedInstance] setDelegate:self];
        [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :headerString} mutableCopy ]
                                                    toMethod:kRequestGetContracts isPost:NO];
        [[LoadingView loadingViewWithMessage:nil] show];    // Comming from drawer option



    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    }

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect picker = CGRectMake(0, 44, 0, 0);
    PickerView = [[UIPickerView alloc] initWithFrame:picker];
    bank = (UITextField*)[self.view viewWithTag:5001];
    bank.text = [PickerData objectAtIndex:0];
    bank.inputView = PickerView;
    
    Service = (UITextField*)[self.view viewWithTag:6001];
    Service.text = [PickerData objectAtIndex:0];
    Service.inputView = PickerView;
    
    PickerView.delegate = self;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    bank = (UITextField*)[self.view viewWithTag:5001];
    [bank resignFirstResponder];
    
    Service = (UITextField*)[self.view viewWithTag:6001];
    [Service resignFirstResponder];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [PickerData count];
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [PickerData objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    bank = (UITextField*)[self.view viewWithTag:5001];
    bank.text = [PickerData objectAtIndex:row];
    
    Service = (UITextField*)[self.view viewWithTag:6001];
    Service.text = [PickerData objectAtIndex:row];
    
}
-(void)setUpContractsHeader{
    
    if (self.page_controller == nil)
        [super setUpBaseHeader];
    
    
    NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
    
    NSMutableDictionary *params = [@{ @"tipoServicio": [contractInfo objectForKey:@"tipoServicio"],
                                      @"contract"  : [[contractInfo objectForKey:@"idContrato"] stringValue],
                                      @"empresa"     : [contractInfo objectForKey:@"empresa"],
                                      @"append_key"  :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
}


-(void)getCurrentToken:(NSString *)currentToken inContract:(NSDictionary *)contractInfo{
    
    int index =(int)self.page_ctrl_delegate.current_index ;
    int last_pos = ([(NSMutableArray *)[self.page_ctrl_delegate.arr_contracts objectAtIndex:self.page_ctrl_delegate.contract_index] count]-1);
    if (index == 0) {
        _left_buttom.hidden = YES;
        _rigth_buttom.hidden =NO;
    }else if (index == last_pos )
    {
        _left_buttom.hidden = NO;
        _rigth_buttom.hidden =YES;
        
        
    }else{
        _left_buttom.hidden = NO;
        _rigth_buttom.hidden =NO;
        
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

-(IBAction)contractTypeSelector:(RadioButton*)sender{
   
    if (super.flow == RegisterCount) {
       
       if ([(RadioButton *)[self.view viewWithTag:kInterbanCLABERadioButton] isSelected]){

           
           NSAttributedString *textInterbank = [[NSAttributedString alloc] initWithString:@"CLABE Interbancaria (18 dígitos)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
           [(UITextField*)[self.view viewWithTag:5003] setAttributedPlaceholder:textInterbank];
           
          [(UITextField*)[self.view viewWithTag:5001] setHidden:NO];
          
           NSDictionary    *contractInfo   = [self.page_ctrl_delegate getCurrentContract];
            //NSMutableDictionary     *contract          = [super updateTokenIncontractHeader:token];
           [contractInfo objectForKey:@"contract_token"];  // Update the contract token
           
           NSString *key                = [contractInfo objectForKey:@"contract_token"];
           NSLog(@"KEY %@", key);
           NSString *valor              = @"0";
           NSString *language           = @"?language=SPA";
           NSMutableString *ConsulBanks = [NSMutableString string];
           [ConsulBanks appendString:[NSString stringWithFormat:@"%@/%@%@", key,valor, language]];
           NSLog(@"headerString = %@",ConsulBanks);
           [[RequestManager sharedInstance] setDelegate:self];
           [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                   @"append_key"  :ConsulBanks} mutableCopy]
                                                       toMethod:KConsultBanks isPost:NO];

       }else{
           
           NSAttributedString *textContract = [[NSAttributedString alloc] initWithString:@"Número de contrato Actinver" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
           [(UITextField*)[self.view viewWithTag:5003] setAttributedPlaceholder:textContract];
           [(UITextField*)[self.view viewWithTag:5001] setHidden:YES];
       }
   }
    
    
    
}

#pragma mark - ContractHeaderDelegate

-(void)getCurrentToken:(NSString *)token inContractIndex:(int)index inPageViewCtrWithTag:(int)tag{
    NSLog(@"Protocol final");
    
    if (tag == kMasterHeader)
        _master_index   = index;
    
    else
        _slave_index    = index;
    
    NSLog(@"Master: %d Slave: %d",_master_index,_slave_index);
    
    [self getCurrentToken:token inContract:[[self.arr_contracts objectAtIndex:0] objectAtIndex:index]];
}

-(void)responseFromService:(NSMutableDictionary *)response{
#warning Validate the result is nil (Network error)
    
    
    if ([response objectForKey:@"act_net_error"] != NULL) {
        
        return;
    }
  if (super.flow == RegisterCount) {
    
      if ([[response objectForKeyedSubscript:@"method_code"] intValue] == kRequestGetContractToken) {    // *** REVISAR SI SE DEJA ESTE IF ***
          NSString *token = [[response objectForKey:@"result"] objectForKey:@"key"];
        
          NSMutableDictionary     *contract          = [super updateTokenIncontractHeader:token];
          [contract setValue:token forKey:@"contract_token"];  // Update the contract token
          NSString *valor = @"0";
          NSString *language     = @"?language=SPA";
          NSMutableString *ConsulBanks = [NSMutableString string];
          [ConsulBanks appendString:[NSString stringWithFormat:@"%@/%@%@", token,valor, language]];
          NSLog(@"headerString = %@",ConsulBanks);
        
          [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                @"append_key"  :ConsulBanks} mutableCopy]
                                                    toMethod:KConsultBanks isPost:NO ];
          [[LoadingView loadingViewWithMessage:nil] show];
        
        
        }
   }
    
    if ([[response objectForKeyedSubscript:@"method_code"] intValue] == KConsultBanks) {
        NSDictionary * BanksInter = [response objectForKey:@"outBanksCatalog"];
        NSLog(@"Bancos Interbancarios: %@",BanksInter);
        
        NSString * banksNames;
        PickerData = [[NSMutableArray alloc]init];
        NSArray * arrayBanks =[[[response objectForKey:@"outBanksCatalog"]objectForKey:@"banksCatalogData"]objectForKey:@"bank"];
        for (int i = 0; i < [arrayBanks count]; i++) {
            banksNames = [[[[[response objectForKey:@"outBanksCatalog"]objectForKey:@"banksCatalogData"]objectForKey:@"bank"]objectAtIndex:i]objectForKey:@"bankName"];
            [PickerData addObject:banksNames];
            
        }
        bank = (UITextField*)[self.view viewWithTag:5001];
        [bank setDelegate:self];
    }
    
   //if (super.flow == RegisterService) {
        if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContractToken) {
            
            NSString *token = [[response objectForKey:@"result"] objectForKey:@"key"];
 
                //[[LoadingView loadingViewWithMessage:nil] show];
                NSMutableString *headerString = [NSMutableString string];
                [headerString appendString:[NSString stringWithFormat:@"%@/2?language=SPA", token]];
                NSLog(@"headerString = %@",headerString);
                
                [[RequestManager sharedInstance] setDelegate:self];
                [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                                        @"append_key"  :headerString} mutableCopy ]
                                                            toMethod:kRequestGetHightsServices isPost:NO];
            [[LoadingView loadingViewWithMessage:nil] show];
            
            }
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoadingView close];
    });
     //}
    if ([[response objectForKeyedSubscript:@"method_code"] intValue] == kRequestGetHightsServices) {
        NSString * companyName;
        PickerData = [[NSMutableArray alloc]init];
        arrayServices =[[response objectForKey:@"outServiceCompanyQuery"]objectForKey:@"serviceInfo"];
        NSLog(@"arrayServices %@", arrayServices);
        for (int i = 0; i < [arrayServices count]; i++) {
            companyName = [[[[response objectForKey:@"outServiceCompanyQuery"]objectForKey:@"serviceInfo"]objectAtIndex:i]objectForKey:@"companyName"];
            [PickerData addObject:companyName];
            
        }
        Service = (UITextField*)[self.view viewWithTag:6001];
        [Service setDelegate:self];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoadingView close];
    });
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContracts) {   //  este IF no se borra
        NSMutableArray  *cont_array = [response objectForKey:@"contracts"];
        
        NSMutableArray  *aux_array  = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *dict in cont_array) {
            if ([[dict objectForKey:@"empresa"] isEqualToString:@"Banco"]){//cambiar por banco
                [aux_array addObject:[dict mutableCopy]];
                [LoadingView close];
                
            }
        }
        [self.arr_contracts addObject:aux_array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
            [self setUpContractsHeader];
        });
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueNotifyTransDataEntry"]) {
        ModalEntryDataViewController *aux   = segue.destinationViewController;
        aux.delegate                        = self;
    }
    
    if ([segue.identifier isEqualToString:@"segueConfirmHighsDataView"]) {
        ConfirmHighsDataViewController *aux      = segue.destinationViewController;
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
    
}


-(IBAction)continueTransaction:(id)sender{

     NSMutableArray *info = [[NSMutableArray alloc] init];
    
    // Contract Info
    [info addObject:[super getCurrentContract]];
    
    // Destination contract info
    
    NSString *typeProcess;
    NSMutableDictionary *Register_info;
    
    if (self.flow == RegisterCount){
        typeProcess = @"RegisterCount";
        
        BOOL actinver_operation =  [(RadioButton *)[self.view viewWithTag:kActinverContractRadioButton] isSelected];
        
//        if (actinver_operation)                // Actinver Contracts
//            [info addObject:[_page_ctrl_delegate_slave getCurrentContract ]];
//        else
//            [info addObject:[_page_ctrl_delegate_otherBanks getCurrentContract ]];  // Other banks Contracts
        
        
        Register_info = [@{
                        @"beneficiaryName":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5002] text]],
                        @"acountNumber":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5003] text]],
                        @"alias":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5004] text]],
                        @"maxAmount":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5005] text]],
                        @"beneficiaryMail":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5006] text]]} mutableCopy];
        
        if (actinver_operation) {
            [Register_info setObject:@"Contrato Actinver Actinver" forKey:@"acount"];
            [Register_info setObject:@"90621" forKey:@"bankID"];
            [Register_info setObject:@"1" forKey:@"acountType"];
            [Register_info setObject:@"01" forKey:@"businessType"];
            [Register_info setObject:@"" forKey:@"contractNumber"];             // buscar contrato
            [Register_info setObject:@"" forKey:@"countryCodeNumber"];
            [Register_info setObject:@"" forKey:@"mandatorAcountType"];
            [Register_info setObject:@"" forKey:@"nuewValueType"];              // RECIBIR DD SFT21
            [Register_info setObject:@"" forKey:@"phoneNumber"];
            [Register_info setObject:@"" forKey:@"systemID"];
            [Register_info setObject:@"" forKey:@"sendingID"];                  // RECIBIR DD SFT21
            [Register_info setObject:@"" forKey:@"availableDateTime"];
            [Register_info setObject:@"SPA" forKey:@"language"];
            [Register_info setObject:[[Session sharedManager].pre_session_info objectForKey:@"username"] forKey:@"cliendID"];
            

        }
        else{
            [Register_info setObject:[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:5001] text]] forKey:@"bankName"];
            [Register_info setObject:@"Cuenta Bancaria de Terceros" forKey:@"acount"];
            [Register_info setObject:@"" forKey:@"bankID"];                     // colocar el  numero del id del banco
            [Register_info setObject:@"2" forKey:@"acountType"];
            [Register_info setObject:@"01" forKey:@"businessType"];
            [Register_info setObject:@"" forKey:@"contractNumber"];             // buscar contrato
            [Register_info setObject:@"" forKey:@"countryCodeNumber"];
            [Register_info setObject:@"" forKey:@"mandatorAcountType"];
            [Register_info setObject:@"" forKey:@"nuewValueType"];              // RECIBIR DD SFT21
            [Register_info setObject:@"" forKey:@"phoneNumber"];
            [Register_info setObject:@"" forKey:@"systemID"];
            [Register_info setObject:@"" forKey:@"sendingID"];                  // RECIBIR DD SFT21
            [Register_info setObject:@"" forKey:@"availableDateTime"];
            [Register_info setObject:@"SPA" forKey:@"language"];
            [Register_info setObject:[[Session sharedManager].pre_session_info objectForKey:@"username"] forKey:@"cliendID"];
            

        }
    }
    
    else if (self.flow == RegisterService){
        typeProcess = @"RegisterService";
        
//        BOOL user_services =(UITextField*)[self.view viewWithTag:6001];
//        
//        
//        if (user_services) {        // Contract services option selected
            //[info addObject:[[_arr_user_services objectAtIndex:_master_index] objectAtIndex:_services_selected_index]];
            
            Register_info = [@{@"Service":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6001]text]],
                            @"alias":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6002] text]],
                            @"amountLimit":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6003] text]],
                            @"clientId":[[RequestManager sharedInstance] userId],
                            @"newValueType":@" ",
                            @"sendingID":@" ",
                            @"contractNumber":@" ",
                            @"serviceCompanyId":@" ",
                            @"associatedServiceCompanyID":@" ",
                            @"associatedContractNumber":@" ",
                            @"availableDateTime":@" ",
                            @"language":@"SPA"
                            } mutableCopy];
            
            if ([[(UITextField*)[self.view viewWithTag:6001] text] isEqualToString:@""]) {
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"No se a seleccionado Servicio."
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
            if ([[(UITextField*)[self.view viewWithTag:6002] text] isEqualToString:@""]) {
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"No se a creado un Alias."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil , nil];
                [campo show];
                return;
            }
            if ([[(UITextField*)[self.view viewWithTag:6003] text] isEqualToString:@""]) {
                
                UIAlertView *campo = [[UIAlertView alloc] initWithTitle:@"Atención"
                                                                message:@"No se a introducido un monto."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil , nil];
                [campo show];
                return;
            }
            
            NSLog(@"Trans info: %@",Register_info);
        //}
        
    } else if (self.flow == RegisterCreditCard){
        typeProcess = @"RegisterCreditCard";
        
        // BOOL user_services =  [(RadioButton *)[self.view viewWithTag:kServicesTagRadioButton] isSelected];
        
        //  if (user_services) {        // Contract services option selected
        //[info addObject:[[_arr_user_services objectAtIndex:_master_index] objectAtIndex:_services_selected_index]];
        
        Register_info = [@{@"creditCardNumber":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:7001]text]],
                           @"alias":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:7002] text]],
                           @"maxAmount":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:7003] text]],
                           @"clientId":[[Session sharedManager].pre_session_info objectForKey:@"username"],
                           @"contract":@"",  // obtenr del servico
                           @"language":@"SPA"
                           } mutableCopy];
        
        
        
        NSLog(@"Trans info: %@",Register_info);
        
    }
    
    if(typeProcess ==nil){
        typeProcess=@"RegisterService";
        Register_info = [@{@"Service":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6001]text]],
                           @"alias":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6002] text]],
                           @"amountLimit":[Utility makeSafeString:[(UITextField *)[self.view viewWithTag:6003] text]],
                           @"clientId":[[RequestManager sharedInstance] userId],
                           @"newValueType":@" ",
                           @"sendingID":@" ",
                           @"contractNumber":@" ",
                           @"serviceCompanyId":@" ",
                           @"associatedServiceCompanyID":@" ",
                           @"associatedContractNumber":@" ",
                           @"availableDateTime":@" ",
                           @"language":@"SPA"
                           } mutableCopy];

    
    }
    [Register_info setObject:typeProcess forKey:@"typeProcess"];
    
    [info addObject:Register_info];
    
    NSLog(@"Recovered Register Info: %@",Register_info);
                                                                            // segueConfirmDataView
    [self performSegueWithIdentifier:@"segueConfirmHighsDataView" sender:info];  // segueConfirmHighsDataView
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    Amount = (UITextField*)[self.view viewWithTag:6003];
    
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
    }
//        else{
//
//        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
//        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        Amount.text = [_currencyFormatter stringFromNumber:00];
//
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Deposit Amount Limit"
//                                                       message: @"You've exceeded the deposit amount limit. Kindly re-input amount"
//                                                      delegate: self
//                                             cancelButtonTitle:@"Cancel"
//                                             otherButtonTitles:@"OK",nil];
//
//        [alert show];
//        return NO;
//    }
    return string;
}

#pragma mark -> Disable "copy-paste"

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}




/*
 
 ***PARA DATOS DE LA TARJETA **  view: tag 4000
    Número de tarjeta :     tag:4001
    Nombre:                 tag:4002
    Monto máximo:           tag:4003
 
 ***PARA CUENTAS A REGISTRAR ***  view tag 4004
    Tipo de cuenta          tag 4005
    Banco                   tag 4006
    Beneficiario            tag 4007
    Número de cuenta        tag 4008
    Crea un alias           tag 4009
    Correo electrónico      tag 4010
 
 *** PARA REGISTRAR SERVICIOS  Vew tag 4011
 
    Nombre:                tag 4012
    Tipo Servicio:         tag 4013
    Empresa:               tag 4014
    Monto Maximo:          tag 4015
 
 
 */

@end
