//
//  Utility.h
//  Booking Room
//
//  Created by Angel Solorio on 2/6/14.
//  Copyright (c) 2014 Angel Solorio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kAdviceButtonTag 9876

@interface Utility : NSObject

enum {
    ChangeContractAlias = 1001
};
typedef NSUInteger ModalViewFlow;

enum {
    EnrollmentProcess   = 1,
    LoginProcess        = 2,
    TokenConfirmation   = 3,
    
    password            = 1,
    notific             = 2,
    image               = 3,
    
};
typedef NSUInteger ProcessFlow;

enum {
    Investments         = 101,
    Movements           = 102,
    Balances            = 103,
    
    Transfers           = 201,
    Services            = 202,
    CreditCard          = 203,

    AdmonOwnContracts   = 301,
    
    RegisterCount       = 401,
    RegisterService     = 402,
    RegisterCreditCard  = 403
};

enum {
    Transfer_Actinver   = 101,
    Transfer_OtherBanks = 102,
    Transfer_UserServs  = 103,
    Transfer_BasicServ  = 104,
    Register_service    = 105,
    Pay_CredictCard     = 106,
    
    Register_CountActinver = 201,
    Register_otherCount    = 202,
    Register_Service       = 203,
    Register_CreditCard    = 204,
};

enum {
    UniContract         = 1,
    MultiContract       = 0
};

enum {
    OwnContracts         = 0,
    OtherBanks           = 1
};
typedef enum kContHeaderType kContHeaderType;

enum{
    SimpleModal             = 0,    // Modal Entry-Confirmation
    EntryTokenConfirmation  = 1,    // Modal Entry-Token-Confirmation
    MenuModalToken          = 2,    // Modal Menu->Entry-Confirmation
    MenuModalTokenConfirm   = 3     // Modal Menu->Entry-Token-Confirmation
};
typedef NSUInteger ContainerModalType;

enum MessageFromEnrollmentStep {
    kSendLogin,
    kOpenConfirmation,
    kSendSeedRequest,
    kSendTransaction,
    KValidationChallenge,  // SFT23
    KEnrolmentQuestion,    // Pregunta Secreta - PRA12
    KImageQuestion,        // Imagen Seguridad - PRA05
    KTokenGenerate,        // SFT22
    kOpenTransactionSucceed,
    KchangePassword,
    KchangeNotific,
    kchangeImage
 
};
typedef enum MessageFromEnrollmentStep MessageFromEnrollmentStep;

enum {
    kMasterHeader           = 0,
    kSlaveHeader            = 1,
    kOtherBanksHeader       = 2,
    kPayCreditCard          = 3,
};
typedef NSUInteger PageViewTag;

+(NSString *)stringWithMoneyFormat:(double)number;
+(NSString *)makeSafeString:(NSString *)str;

+(NSString *)getOneYearDifferenceFromNow:(BOOL)ahead;
+(NSString *)getDateInWSFormat:(NSDate*)date;

+ (NSString *)trimString:(NSString *)string;
+ (float)getDeviceiOSVersion;
+ (CGSize)getScreenSize;
+ (UIInterfaceOrientation)getOrientation;
+ (UIImage *)getScreenshot:(UIView *)view;

+ (UIImage *)getImageFromURLString:(NSString *)stringURL;
+ (UIImage *)getImageFrom64EncodedString:(NSString *)encodedString;
+ (UIImage *)getImageFromFileSystem:(NSString *)fileName;
+ (UIImage *)getImageFromFileSystem:(NSString *)fileName inFolder:(NSString *)directory;
+ (void)saveImageToFileSystem:(UIImage *)photo withFileName:(NSString *)fileName inFolder:(NSString*)directory;
+ (void)saveImageToFileSystem:(UIImage *)photo withFileName:(NSString *)fileName;
+ (BOOL)deleteFileFromFileSystemWithName:(NSString *)fileName;
+ (BOOL)deleteFileFromFileSystemWithName:(NSString *)fileName inFolder:(NSString*)directory;
+ (void)savePlistFile:(NSString *)fileName andData:(NSDictionary *)data;
+ (NSDictionary *)loadPlistFile:(NSString *)fileName;

+ (NSDate *)getDateFromString:(NSString *)stringDate withFormat:(NSString *)format;
+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSInteger)getNumberOfDaysFromMonth:(NSDate *)date;
+ (NSArray *)getArrayOfDaysFromMonth:(NSDate *)date;
+ (NSInteger)getDayNumberFromDate:(NSDate *)date;
+ (NSInteger)getMonthNumberFromDate:(NSDate *)date;
+ (NSInteger)getYearNumberFromDate:(NSDate *)date;

+ (NSString *)amountCurrencyFormat:(NSString *)amount;
+ (NSString *)getFormattedStringFromValue:(id)value;

+ (NSString *)getCurrentLanguageString;
+ (NSString *)getCurrentLanguageCode;
+ (NSInteger)getCurrentLanguageID;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;

+ (NSString *)getHttpStringFromString:(NSString *)urlString;
+ (NSString*)getStringBetweenStringStart:(NSString*)start andEnd:(NSString*)end andString:(NSString *)string;
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (BOOL)validationNumber:(NSString *)string;
+ (BOOL)validationDecimalNumber:(NSString *)string;

+ (NSString*) formatAmount: (NSString*) anAmount isNegative: (BOOL) aNegative;


@end
