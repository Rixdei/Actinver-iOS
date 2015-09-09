//
//  EnrollmentViewController.h
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"

@interface EnrollmentViewController : UIViewController
{

}

@property (nonatomic, strong) NSMutableDictionary   *pre_enrollment_info;

@property ProcessFlow   processFlow;

@property NSString * Usuer_name;
@property NSString * Usuer_pass;
@property NSString * language;

@property NSString *KEY;
@property NSString *KEY_USM06;

@end
