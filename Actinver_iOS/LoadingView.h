//
//  LoadingView.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/05/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView

- (id) init;

- (void) show;

+ (LoadingView*) loadingViewWithMessage:(NSString *)message;
+ (void)close;

@end
