//
//  CustomizeControl.m
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 26/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizeControl.h"

@implementation CustomizeControl

+ (void)roundCornersInButton:(UIButton *)btn {
    btn.layer.cornerRadius    = 15;
    btn.clipsToBounds         = YES;
}
+ (void)roundCornersInView:(UIView *)view {
    view.layer.cornerRadius    = 7;
    view.clipsToBounds         = YES;
}

+ (void)setPlaceHolderForUITextFieldInEnrollment: (UITextField*)txt_field WithText:(NSString *)text{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text
                                                              attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:179/255.f
                                                                                                                             green:143/255.f
                                                                                                                              blue: 32/255.f
                                                                                                                             alpha:1.0f] }];
    txt_field.attributedPlaceholder = str;
}

+ (void)makeButtonCircular:(UIButton *)btn {
    btn.layer.cornerRadius      = 0.5 * btn.bounds.size.width;
    btn.clipsToBounds           = YES;
    btn.layer.borderWidth       = 1.5;
    btn.layer.borderColor       = [UIColor whiteColor].CGColor;
}

+ (UIColor *)getYellowColor{
    return [UIColor colorWithRed:231/255.f
                           green:203/255.f
                            blue: 11/255.f
                           alpha:1.0];
}

+ (UIColor *)getDarkGrayColor{
    return [UIColor colorWithRed: 31/255.f
                           green: 33/255.f
                            blue: 36/255.f
                           alpha:1.0];
}


@end
