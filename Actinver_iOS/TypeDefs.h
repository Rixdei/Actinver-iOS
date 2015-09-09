//
//  TypeDefs.h
//  Actinver-IOS
//
//  Created by Josue de Jesus Maqueda Flores on 2/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#define kBASE_URL @"http://www.splitsoft-studio.com/tester/services/"
#define kTimerOut 30


typedef enum {
    INVALID_SESSION,
    VALID_SESSION,
    CLOSE_SESSION
} SessionStatus;


typedef enum {
    TRANSACTION_MINE,
    TRANSACTION_THIRD,
    TRANSACTION_OTHER
} TypeTransaction;
