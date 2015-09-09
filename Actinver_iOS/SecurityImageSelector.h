//
//  SecurityImageSelector.h
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 13/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectorResponse <NSObject>

-(void) updateImage:(NSString *)imageName;

@end

@interface SecurityImageSelector : UIViewController{
    
}

@property (nonatomic, weak) id<ImageSelectorResponse> delegate;

@end
