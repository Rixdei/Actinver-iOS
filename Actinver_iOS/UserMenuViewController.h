//
//  UserMenuViewController.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 22/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserMenuDelegate <NSObject>
- (void) openSubMenu:(int)tag;
@end

@interface UserMenuViewController : UIViewController{
    
}
@property (nonatomic, weak)     id<UserMenuDelegate> delegate;

@end
