//
//  CustomizeControl.h
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizeControl : NSObject{
    
}

+ (void)roundCornersInButton:(UIButton *)btn;
+ (void)roundCornersInView:(UIView *)view;
+ (void)setPlaceHolderForUITextFieldInEnrollment: (UITextField*)txt_field WithText:(NSString *)text;
+ (void)makeButtonCircular:(UIButton *)btn;

+ (UIColor *)getYellowColor;
+ (UIColor *)getDarkGrayColor;

@end
