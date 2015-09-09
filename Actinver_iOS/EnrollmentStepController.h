//
//  EnrollmentStepController.h
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface EnrollmentStepController : UIViewController
{
    NSMutableArray *arrayOfPicker;
}

@property (strong, nonatomic) IBOutlet UITextField *questionSecurityTextField;
@property int  enrollment_step;

-(BOOL) validateStepFields;
@property ProcessFlow   processFlow;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;

@property (weak, nonatomic) IBOutlet UILabel *softTokenLabel;
@property (weak, nonatomic) IBOutlet UITextField *hardToken_textField;



@end

