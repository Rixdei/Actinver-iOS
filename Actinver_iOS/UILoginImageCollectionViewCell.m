//
//  UILoginImageCollectionViewCell.m
//  Actinver-IOS
//
//  Created by Raul Galindo Hernandez on 3/23/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "UILoginImageCollectionViewCell.h"

@implementation UILoginImageCollectionViewCell
- (void)awakeFromNib {
    // Initialization code
    UIView *cellView = [[UIView alloc] initWithFrame:self.frame];
    cellView.backgroundColor = [([UIColor colorWithRed:35./255. green:58./255. blue:96./255. alpha:1.]) colorWithAlphaComponent:0.8f];
    [self setSelectedBackgroundView:cellView];
}

-(void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
    
}
@end
