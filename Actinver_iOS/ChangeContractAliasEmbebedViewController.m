//
//  ChangeContractAliasEmbebedViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 04/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ChangeContractAliasEmbebedViewController.h"
#import "RequestManager.h"
#import "LoadingView.h"


@interface ChangeContractAliasEmbebedViewController ()<ResponseFromServicesDelegate>{
    NSString * contrac_alias_name;
}

    @property (nonatomic, weak)     IBOutlet    UILabel     *lbl_contract_number;
    @property (nonatomic, weak)     IBOutlet    UITextField *txt_contract_alias;
@property (weak, nonatomic) IBOutlet UIButton *password_changue;





@end

@implementation ChangeContractAliasEmbebedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txt_contract_alias.textColor = [UIColor whiteColor];
    
    NSString *username      = [[Session sharedManager].pre_session_info objectForKey:@"username"];
    NSString *params     = @"?language=SPA";
    NSString *key =[[RequestManager sharedInstance] keyToSend];
    
    NSMutableString *headerString = [NSMutableString string];
    
    [headerString appendString:[NSString stringWithFormat:@"%@/%@%@", key,username, params]];
    NSLog(@"headerString = %@",headerString);
    //[[LoadingView loadingViewWithMessage:nil] show];

    
    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:[@{
                                                            @"append_key"  :headerString} mutableCopy ]
                                                toMethod:kRequestGetContracts isPost:NO];
    [[LoadingView loadingViewWithMessage:nil] show];

    
    
    // Do any additional setup after loading the view.
//    NSMutableDictionary *params = [@{ @"tipoServicio"   :[_contract_info objectForKey:@"tipoServicio"],
//                                      @"contract"       :[[_contract_info objectForKey:@"idContrato"] stringValue],
//                                      @"empresa"        :[_contract_info objectForKey:@"empresa"],
//                                      @"append_key"     :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
//    
//    [RequestManager sharedInstance].delegate = self;
//    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
////    //[[LoadingView loadingViewWithMessage:nil] show];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"Data: %@",super.aditional_data);
    
    [_lbl_contract_number setText:[NSString stringWithFormat:@"Contrato: %@",[[super.aditional_data objectForKey:@"idContrato"] stringValue]]];
    [_txt_contract_alias setText:[super.aditional_data objectForKey:@"aliasContrato"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//agregar
-(IBAction)sendChangeAliasRequest:(id)sender {  // este bonton puede funcionar para la siguiente pantalla
    NSLog(@"sender = %ld",(long)[sender tag ]);
    if ([sender tag] == 400) {
       NSLog(@"contraseña");
       
        [super.delegate passToNextStep:sender];
    
    }else
        
        if([sender tag] == 300){
        NSLog(@"medios de notificación");
            
            [super.delegate passToNextStep:sender];
   
            

    }else if([sender tag] == 200){
      NSLog(@"imagen de seguridad");
        
        [super.delegate passToNextStep:sender];

        
    }else{
    
    [super.delegate passToNextStep:nil];
   
    if ([_txt_contract_alias.text  isEqual: @""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"introduce tu alias" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        

        NSString * new_Alias = _txt_contract_alias.text;
        [[RequestManager sharedInstance] setChang:new_Alias];
        
        //create json lstContractAlias
        NSString * lst_contract_Alias = [NSString stringWithFormat:@"[{\"contractNumber\":\"%@\",\"alias\":\"%@\",\"estatus\":\"\"}]",contracts,new_Alias];
//create json
        NSString *user = [[Session sharedManager].pre_session_info objectForKey:@"username"];
        NSString *leng = @"SPA";
        NSString * json_string = [NSString stringWithFormat:@"{\"customerId\":\"%@\",\"language\":\"%@\",\"lstContractAlias\":}%@",user,leng,lst_contract_Alias];


        NSMutableDictionary *params = [@{
                                         @"Json_stng"        : json_string,
                                     
                                         @"append_key"  :key} mutableCopy];
    [[RequestManager sharedInstance] setDelegate:self];
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KChangeAlias isPost:YES];
    
    }
    }
}

-(void)responseFromService:(NSMutableDictionary *)response

{
    //NSLog(@"respuesta gal01 : %@",response);

    
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContracts) {
        //NSLog(@"Get Contracts response-------------");
        NSMutableArray  *cont_array = [response objectForKey:@"contracts"];
        //NSLog(@"contracts------>%@",cont_array);
        contracts = [[[response objectForKey:@"contracts"]  objectAtIndex:0] objectForKey:@"idContrato"];
        tippServicio = [[[response objectForKey:@"contracts"] objectAtIndex:0] objectForKey:@"tipoServicio"];
        empresa = [[[response objectForKey:@"contracts"] objectAtIndex:0] objectForKey:@"empresa"];
        [[RequestManager sharedInstance]setNumberContract:contracts];
    
    NSMutableDictionary *params = [@{ @"tipoServicio"   :tippServicio,
                                      @"contract"       :contracts,
                                      @"empresa"        :empresa,
                                      @"append_key"     :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
    
    //[RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:kRequestGetContractToken isPost:YES];
    //[[LoadingView loadingViewWithMessage:nil] show];

    }
    if ([[response objectForKey:@"method_code"] intValue] == kRequestGetContractToken) {
        key = [[response objectForKey:@"result"] objectForKey:@"key"];
        NSLog(@"LLAVE GAL01: %@",key);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView close];
        });
   
    }

}





@end
