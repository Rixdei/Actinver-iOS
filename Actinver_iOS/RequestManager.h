//
//  RequestManager.h
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 11/05/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "RadioButton.h"

typedef enum {
  kRequestLogin,                    // Login (genera token)   USM01
  kRequestEnrollmentStep,           // Redirecionamiento      USM06
  kRequestGetContracts,             // Contratos              USM04
  kRequestGetContractToken,         // Contratos              USM02
  kRequestInvPortfolio,             // Investment Data 1      BPS10
  kRequestMoneyMarket,              // Investment Data 2      BPD06
  kRequestMovements,                // Movements              PRC09_BANCO

  kRequestCEDEInvest,               // FixedTermInvestments   BRI04CEDE
  kRequestFixedTermInvest,          // FixedTermInvestments   BRI04PRLV
    
  kRequestGetTransfersOtherBanks,   // Contratos              BRG01
  kRequestGetTransfersChallenge,    // Challenge              SFT21
    
  kRequestSendTransaction,          // ServicesPaymentRest    BRP08
    
  kRequestSendTransfer,             // ServicesPaymentRest    TSP03    
  kRequestSendPayService,           // ServicesPaymentRest    BRP08
    
  kRequestGetUSerServices,          // ServicesPaymentRest    BRP06
    
 
  kRequestGetAirtimeServices,       // ServicesPaymentRest    BRP02
  kRequestGetAirtimeServices_1,     // ServicesPaymentRest    BRP02_1
  kRequestGetAirtimeServices_3,     // ServicesPaymentRest    BRP02_3
  
  kRequestGetHightsServices,        // ServicesPaymentRest    BRP02_2
    
  KRequestGetPayCreditCard,         // ContractRest           BRC04
  KRequestSendPayCreditCard,        // BankingOpsRest         BRC08

    
    
  KGenerateChallenge,               //sft21_2
  KValidateChallenge,               // sft23
    
  KSecretGetQuestion,               // list of questions       PRA12
  KSecurityGetImage,                // Picture list    PRA05
    
    
    
   KGenerateToken,                  // Registro de Token      SFT22
    
  KRequestLogout,                   // Logout                 USM05
  KSemillaToken,                    // GeneraSemilla          SFT19
    
  KConsultBanks,                     // CatalogsRest       BRG01
    
  KChangeAlias,                     // Change Alias       GAS01
  kChanguePassWord,                  //Change password
  KchangeNotification,
  KChangeImageSecurity,
  kQuickBloxLogin

    
} RequestType;

@protocol ResponseFromServicesDelegate <NSObject>
    -(void)responseFromService:(NSMutableDictionary *)response;
@end

@interface RequestManager : NSObject{
    NSURLSession    *session;
    RequestType     currentRequest;
    NSString *key1;
    BOOL sandbox;
    BOOL qBloxx;
}

+(instancetype)sharedInstance;

@property (nonatomic, weak) id<ResponseFromServicesDelegate> delegate;

-(void)sendRequestWithData:(NSMutableDictionary *)data toMethod:(RequestType)requestType isPost:(BOOL)isPost;
//date
@property (nonatomic , strong) NSString * iniYear;
@property (nonatomic , strong) NSString * nexYear;
@property (nonatomic , strong) NSString * lastMonth;

@property (nonatomic , strong) NSString * Month;

//singleton
@property (strong , nonatomic) NSDictionary *dicToSend;
@property (strong, nonatomic)   NSString *keyToSend;
@property (strong, nonatomic)   NSString *userId;
@property (nonatomic , strong) NSDateFormatter * Today;
@property (nonatomic , strong) NSDateFormatter *todate;
@property (nonatomic , strong) NSString * last_Month;
@property (nonatomic , strong) NSString * n_password;
@property (nonatomic , strong) NSString * email;
@property (nonatomic , strong) NSString * cellPhone;


@property (nonatomic , strong) NSArray * advisors;







@property (strong, nonatomic)   NSString *keyUSM02;
@property (strong, nonatomic)   NSString *numberContract;
@property (strong, nonatomic)   NSString * initial_Year;
@property (strong, nonatomic)   NSString * next_Year;
@property (strong, nonatomic)   NSMutableDictionary * dic_USM02;
@property (strong, nonatomic)   NSString *keyUSM02_2;
@property (strong,nonatomic)   NSDictionary * dic_PRP06;
@property (strong,nonatomic)   NSMutableDictionary *sendingid;
@property (strong,nonatomic)   NSMutableDictionary *NewvalueType;
//@property (strong, nonatomic)   NSString *new_alias;
@property (strong, nonatomic) NSString *chang;



@property (strong ,nonatomic) RadioButton * sender;
@property (strong, nonatomic)NSMutableArray * questionList;


@end
