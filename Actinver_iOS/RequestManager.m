//
//  RequestManager.m
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 11/05/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "RequestManager.h"
#import "IOConstants.h"
#import "EnrollmentViewController.h"
#import "LoadingView.h"
#import "Session.h"


@implementation RequestManager

static RequestManager   *manager    = nil;

+(instancetype)sharedInstance{
    if (manager == nil) {
        manager = [[RequestManager alloc] init];
    }
    return manager;
}

-(id)init{
    if (self = [super init]) {
        _userId = @"UserId";
    }
    return self;
}

-(void)sendRequestWithData:(NSMutableDictionary *)data toMethod:(RequestType)requestType isPost:(BOOL)isPost{
    NSString *str_url ;
    NSLog(@"Params: %@",data);
      qBloxx =NO;
      sandbox    = YES;
   
    currentRequest  = requestType;
    
    [session invalidateAndCancel];
    session         = nil;
    
    session         = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if (requestType == kQuickBloxLogin) {
        qBloxx =YES;
        str_url   = [BASE_URL_QUICKBLOX stringByAppendingString:[self getURLRequest:currentRequest]];
    
    }else{
        
        str_url   = [BASE_URL_ACTINVER stringByAppendingString:[self getURLRequest:currentRequest]];
   
    }
    
    
    NSMutableURLRequest *request;
    
    NSString *str_final = str_url;
    
    if ([data objectForKey:@"append_key"] != nil) {     // Append the value to the base URL
        str_final   = [str_url stringByAppendingString:[data objectForKey:@"append_key"]];
    }
    
    NSLog(@"FINAL BASE URL= %@",str_final);
    
    if (sandbox){
        if (!isPost)
            NSLog(@"GET  Test generator: %@",[self getURLGetRequest:data inBaseURL:str_final]);
        else
            NSLog(@"POST Test generator: %@",[self getURLPostRequest:data inBaseURL:str_final]);

        if (qBloxx ==NO) {
            str_url     = [str_url stringByAppendingString:@".json"];
        
        isPost      = NO;
       
        request     = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_url]];
        }else{
            isPost      = NO;
            
            request     = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self getURLGetRequest:data inBaseURL:str_final]]];

        
        
        }
        }
    else{
        
        if (isPost){                // Data added to post URL (special cases)
            str_final   = [self getURLPostRequest:data inBaseURL:str_url];
            request     = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_final]];
            [request setHTTPMethod:@"POST"];
         
            
            if (currentRequest == KChangeAlias) {
  
                
                NSString * jsonRequest = [data objectForKey:@"Json_stng"] ;
                NSLog(@"Request json to send: %@", jsonRequest);
                
                
                
                NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
                //agregar
                
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                //  [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                //  [ request setValue : @ "application/json" forHTTPHeaderField : @ "Content-Type" ];
                
                [request setHTTPBody: requestData];


                
            
            }else{
               [request setHTTPBody:[[self createPostData:data] dataUsingEncoding:NSUTF8StringEncoding]];
            
            }
         
            
            [LoadingView close];
        
   
        
        }
        else{
            //str_final   = [self getURLGetRequest:data inBaseURL:str_url];       // Append all the parameters to the base URL+METHOD
            request     = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str_final]];
            [request setHTTPMethod:@"GET"];        
            [LoadingView close];
        }
    }
    
    NSURLSessionDataTask *postDataTask   = [session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                   if (error != nil) {
                                                       [session invalidateAndCancel];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [_delegate responseFromService:[@{@"act_net_error":@"error",
                                                                                             @"method_code":[NSNumber numberWithInt:currentRequest]} mutableCopy] ]; // ERROR
                                                           [LoadingView close];
                                                       });
                                                   }
                                                   else{
                                                       
//                                                     NSLog(@"STR: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                       if (currentRequest ==KChangeAlias) {
                                                           
                                                           NSString* xmlString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                           
                                                           //  NSLog(@"XML request = %@" , xmlString);
                                                           NSMutableDictionary *dic = [[NSMutableDictionary alloc] init ];
                                                           [dic setValue:xmlString forKey:@"xml_response"];
                                                           [_delegate responseFromService:dic];
                                                           
                                                           
                                                       }
                                                       
                                                       NSDictionary* info_dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:NSJSONReadingMutableLeaves error:nil];
                                                       [self lastYear];
                                                       [self nextYear];
                                                       [self LastMonth];
                                                       [self today];
                                                       //key1 = [info_dict objectForKey:@"key"];
                                                      
//                                                       NSString*key_USM02_2 = [[info_dict objectForKey:@"result"]objectForKey:@"key"];
//                                                       [[RequestManager sharedInstance]setKeyUSM02_2:key_USM02_2];
                                                       
//                                                       NSLog(@"Response: %@",info_dict);
                                                       NSMutableDictionary  *info   = [info_dict mutableCopy];
                                                       
                                                       if (currentRequest == kRequestGetTransfersOtherBanks ) {
                                                           
                                                           //NSMutableDictionary  *info   = [info_dict mutableCopy];
                                                           NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                                           [dict setObject:info forKey:@"array"];
                                                           [dict setObject:[NSNumber numberWithInt:currentRequest]
                                                                    forKey:@"method_code"];
                                                           [_delegate responseFromService:dict];
                                                           return;
                                                       }
                                                       else{
                                                           [info setObject:[NSNumber numberWithInt:currentRequest]
                                                                    forKey:@"method_code"];
                                                           
                                                       }
                                                       
                                                    
                                                       [_delegate responseFromService:info];
                                                      NSMutableDictionary *dic =[[info objectForKey:@"contracts"] objectAtIndex:0];
                                                       [[RequestManager sharedInstance]setDic_USM02:dic];
                                                      // NSLog(@"Info: %@",info);
                                                   }
                                               }];
    [postDataTask resume];
}

- (NSString *)getURLPostRequest:(NSMutableDictionary *)params inBaseURL:(NSString *)str_url{
    
//    if (currentRequest == kRequestGetTransfersChallenge){
//        str_url = [str_url stringByAppendingString:[NSString stringWithFormat:@"?language=SPA&userId=%@",_userId]];
//    }
 if (currentRequest == kRequestGetContractToken)
        str_url = [str_url stringByAppendingString:[NSString stringWithFormat:@"%@",[[RequestManager sharedInstance]keyToSend]]];

   [LoadingView close];
    return str_url;
}

- (NSString *)getURLGetRequest:(NSMutableDictionary *)params inBaseURL:(NSString *)str_url{
    
    // Arrange the params keys to ensure the params values are added in the correct order.
    NSArray *sorted_keys = [[params allKeys] sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }];
    
    for(NSString *key in sorted_keys) {
        if (![key isEqualToString:@"append_key"])
            if (qBloxx ==YES) {
            str_url = [str_url stringByAppendingString:[NSString stringWithFormat:@"?customerId=%@",[params objectForKey:key]]];

            }else{
            str_url = [str_url stringByAppendingString:[NSString stringWithFormat:@"/%@",[params objectForKey:key]]];
            }
    }
    if (qBloxx ==NO) {
        str_url = [str_url stringByAppendingString:@"?language=SPA"];
    }
    
    if (currentRequest == kRequestGetTransfersChallenge)
        str_url = [str_url stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",_userId]];
    [LoadingView close];
    return str_url;
}

-(NSString *)getURLRequest:(RequestType)requestType{
 
    switch (requestType) {
            
        case kRequestLogin:
            return USM01;
        break;
        case kRequestEnrollmentStep:
            return USM06;
        break;
        case KRequestLogout:
            return USM05;
            break;
            
        case kRequestGetContracts:
            return USM04;               // Ready
            break;
            
        case kRequestGetContractToken:
            return USM02;               // Ready
            break;
            
        case kRequestInvPortfolio:
            return BPS10;               // Ready
            break;
            
        case kRequestMoneyMarket:
            return BPD06;               // Ready
            break;
            
        case kRequestMovements:// is Bank
         
          
            if (sandbox == YES) {
                return PRC09_BANCO;
            }else{
                return PRC09;
            }
            break;
            
        case kRequestCEDEInvest:// is CEDE
            if (sandbox == YES) {
                return BRI04CEDE;
            }else{
                  return BRI04;
            }
        
            break;
            
        case kRequestFixedTermInvest:   // pagare vigente
             if (sandbox == YES) {
            return BRI04PRLV;
             }else{
            return BRI04;
             }
            break;
            
        case kRequestGetTransfersOtherBanks:
            return PRD01;           // Ready
            break;
            
        case kRequestGetTransfersChallenge:
            return SFT21;           // Ready TODO: Validate if token is user or contract
            break;
            
        case kRequestSendTransfer:
            return TSP03;           // Ready TODO: Validate the operationID key in params
            break;
            
        case kRequestSendPayService:
            return BRP08;
            break;
            
        case kRequestSendTransaction:
            return BRP08;
            break;
            
        case kRequestGetUSerServices:
            return BRP06;           // Ready
            break;

        case kRequestGetHightsServices:
            if (sandbox== YES) {
                return BRP02_2;
            }else{
                return BRP02;
            }
            
            break;
        case kRequestGetAirtimeServices:
            return BRP02;
            break;
        case kRequestGetAirtimeServices_1:
             return BRP02_1;
             break;
        case kRequestGetAirtimeServices_3:
            return BRP02_3;
            break;
        case KGenerateChallenge:     // se genera Código en la 3er pantala de login
            return SFT21;
            break;
        case KValidateChallenge:     // Ready  KGenerateChallenge
            return SFT23;
            break;
        case KSemillaToken:
            return  SFT19;
            break;
        case KSecretGetQuestion:
            return PRA12;
            break;
        case KGenerateToken:
            return SFT22;
            break;
        case KSecurityGetImage:
            return PRA05;
            break;
        
        case KConsultBanks:
            return BRG01;
            break;
        case KChangeAlias:
            if (sandbox== YES) {
                return GAS001 ;
            }else{
                return GAS01;
            }
            break;
        case kChanguePassWord:
            return PRA03;
            break;
        case KRequestGetPayCreditCard:
            return BRC04;
            break;
        case KRequestSendPayCreditCard:
            return BRC08;
            break;
        case KchangeNotification:
            return PRA09;
            break;
        case KChangeImageSecurity:
            return PRA04;
            break;
        case kQuickBloxLogin:
            return QBLOX;
            break;
            
      
        default:
            break;
    }
    
    return [self getURLRequest:requestType];
}

-(NSString *)createPostData:(NSMutableDictionary *)params{
    NSString *params_str = @"";
    if (params == nil)
        return params_str;
    
    int i = 0;
    for(NSString *key in params) {
        NSString    *value = [params objectForKey:key];
        if (i==0)
            params_str  = [params_str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        else
            params_str  = [params_str stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        i++;
    }
    return params_str;
}
-(void)singleton{
    self.keyUSM02=nil;
    self.initial_Year=nil;
    self.next_Year=nil;
    self.dic_USM02=nil;
    self.keyUSM02_2=nil;
    self.dic_PRP06=nil;
    self.NewvalueType = nil;
    self.sendingid = nil;
    self.chang = nil;
    self.n_password = nil ;
    self.advisors = nil;
}
-(void)lastYear{
    NSDateFormatter*date =[[NSDateFormatter alloc]init];
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSDate * toDate=[NSDate date];
    NSDateComponents *inicialDate=[[NSDateComponents alloc]init];
    [inicialDate setYear:-1];
    NSDate *inicial = [calendar dateByAddingComponents:inicialDate toDate:toDate options:0];
    [date setDateFormat:@"dMMyyyy"];
    _iniYear = (NSString *)[NSString stringWithFormat:@"%@",[date stringFromDate:inicial]];
    NSLog(@"date1 : %@",_iniYear);
    [[RequestManager sharedInstance]setInitial_Year:_iniYear];

}
-(void)nextYear{
    NSDateFormatter*date =[[NSDateFormatter alloc]init];
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSDate * toDate=[NSDate date];
    NSDateComponents *nextDate=[[NSDateComponents alloc]init];
    [nextDate setYear:+1];
    NSDate *next = [calendar dateByAddingComponents:nextDate toDate:toDate options:0];
    [date setDateFormat:@"dMMyyyy"];
    _nexYear = (NSString *)[NSString stringWithFormat:@"%@",[date stringFromDate:next]];
    NSLog(@"date2 : %@",_nexYear);
    [[RequestManager sharedInstance]setNext_Year:_nexYear];
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
    [[RequestManager sharedInstance] setLast_Month:_lastMonth];
}
-(void)today{
    
    _todate =[[NSDateFormatter alloc]init];
    [_todate setDateFormat:@"dMMyyyy"];
    NSLog(@"today: %@",[_todate stringFromDate:[NSDate date]]);
    [[RequestManager sharedInstance]setToday:_todate];
    
}

@end
