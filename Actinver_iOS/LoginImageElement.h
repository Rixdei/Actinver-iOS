//
//  LoginImageElement.h
//  Actinver-IOS
//
//  Created by Raul Galindo Hernandez on 3/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginImageElement : NSObject

@property (strong, nonatomic) UIImage *imageElement;
@property (assign, nonatomic) int idElement;

-(id)initWithImage:(UIImage*)image idElement:(int)idElement;

@end
