//
//  LoadingView.m
//  Estafeta_iOS
//
//  Created by Raymundo Pescador Piedra on 16/05/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "LoadingView.h"
#import "CustomizeControl.h"
#import "RequestManager.h"

const int LOADING_TAG = 654321;

@interface LoadingView ()

@property (nonatomic, weak)     IBOutlet    UILabel             *lbl_loading;


@property (nonatomic, strong)               NSString            *str_loading;


@end

@implementation LoadingView

- (id)init{
    
    self    = [super init];

    if (self) {
        self.frame  =   CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UIView  *load_view = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
        load_view.frame  =   CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [self addSubview:load_view];
    }
    return self;
}

+ (LoadingView*) loadingViewWithMessage:(NSString *)message{
    LoadingView *view   = [[LoadingView alloc] init];
    view.str_loading    = @"Cargando";
    
    
    
    if (message != nil)
        view.str_loading    = message;
    
    view.tag            = LOADING_TAG;
    return view;
}


-(void) show{
    NSLog(@"Show");
    
    [_lbl_loading   setText:_str_loading];
    
    self.tag            =   LOADING_TAG;
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
}

+(void)close{
    NSLog(@"Close loading view");
    UIView  *load_view = (UIView *)[[[[UIApplication sharedApplication] windows] lastObject] viewWithTag:LOADING_TAG];
    
    [UIView animateWithDuration:0.75f animations:^{
        [load_view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [load_view removeFromSuperview];
    }];
}

@end
