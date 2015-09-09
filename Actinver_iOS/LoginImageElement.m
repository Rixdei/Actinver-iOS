//
//  LoginImageElement.m
//  Actinver-IOS
//
//  Created by Raul Galindo Hernandez on 3/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "LoginImageElement.h"

@implementation LoginImageElement

-(id)initWithImage:(UIImage*)image idElement:(int)idElement
{
    self = [super init];
    
    if(self)
    {
        self.imageElement = image;
        self.idElement = idElement;
    }
    return self;
}

-(void)dealloc
{
    self.imageElement = nil;
    self.idElement = -99;
}
@end
