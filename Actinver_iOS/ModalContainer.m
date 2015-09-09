//
//  ModalContainer.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 03/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ModalContainer.h"
#import "EmbebedViewController.h"
#import "ChangeContractAliasEmbebedViewController.h"


@interface ModalContainer ()<MessagesFromControllerToContainerDelegate>

@property (strong, nonatomic)   NSMutableArray              *controllers_array;
@property (assign, nonatomic)   BOOL                        inTransition;
@property (weak, nonatomic)     EmbebedViewController       *currentController;
@property                       int                         child_number;

@end

/*
SimpleModal             = 0,    // Modal Entry-Confirmation
EntryTokenConfirmation  = 1,    // Modal Entry-Token-Confirmation
MenuModalToken          = 2,    // Modal Menu->Entry-Confirmation
MenuModalTokenConfirm   = 3     // Modal Menu->Entry-Token-Confirmation
*/
 
@implementation ModalContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_kModalType == SimpleModal)
        _child_number   = 4;
    else if (_kModalType == EntryTokenConfirmation || _kModalType == MenuModalToken)
        _child_number   = 3;
    else
        _child_number   = 4;
    
    _controllers_array  = [[NSMutableArray alloc] init];
    for (int i=0; i<_child_number; i++)
        [_controllers_array addObject:[NSNull null]];
    
    _inTransition       = NO;
    _current_position   = 0;
    
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",_current_position]
                              sender:[NSNumber numberWithBool:YES]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Container start //
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    


    
    ((EmbebedViewController *)segue.destinationViewController).delegate         = self;
    ((EmbebedViewController *)segue.destinationViewController).aditional_data   = _aditional_data;
    
    BOOL isForward = [(NSNumber *)sender boolValue];
    
    [_controllers_array replaceObjectAtIndex:_current_position withObject:segue.destinationViewController];
    
    if ([segue.identifier isEqualToString:@"0"] && _current_position == 0) {
        
        NSLog(@"First");
        
        _currentController          = segue.destinationViewController;
        
        [self addChildViewController:_currentController];
        UIView  *destView           = ((UIViewController *)_currentController).view;
        destView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:destView];
        [segue.destinationViewController didMoveToParentViewController:self];
        
        
    } else   if ([segue.identifier isEqualToString:@"2"]) {
        
        [self swapFromViewController:_currentController
                    toViewController:[_controllers_array objectAtIndex:2]
                           isForward:isForward];
    }else if  ([segue.identifier isEqualToString:@"3"]){
       
        [self swapFromViewController:_currentController
                    toViewController:[_controllers_array objectAtIndex:3]
                           isForward:isForward];
        
    }
    else{
        [self swapFromViewController:_currentController
                    toViewController:[_controllers_array objectAtIndex:_current_position]
                           isForward:isForward];
    }
    
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController isForward:(BOOL)isForward
{
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    CGFloat width           = fromViewController.view.frame.size.width;
    CGFloat height          = fromViewController.view.frame.size.height;
    
    CGFloat final_height    = -height;
    toViewController.view.frame = CGRectMake(0, height, width, height);
    
    if (!isForward) {
        final_height    = height;
        toViewController.view.frame = CGRectMake(0, -height, width, height);
    }
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.5
                               options:UIViewAnimationOptionTransitionNone
                            animations:^(void) {
                                fromViewController.view.frame = CGRectMake(0, final_height, width, height);
                                toViewController.view.frame = CGRectMake(0, 0, width, height);
                            }
                            completion:^(BOOL finished){
                                [fromViewController removeFromParentViewController];
                                [toViewController didMoveToParentViewController:self];
                                _inTransition = NO;
                                _currentController  = (EmbebedViewController *)toViewController;
                            }
     ];
}

- (void)swapViewControllers:(BOOL) isForward
{
    

    
    
    if (_inTransition)
        return;
    
    _inTransition       = YES;
    
    if (isForward){
        NSLog(@"Forward: %d",_current_position);
        
        if (_current_position < ([_controllers_array count] -1)) {
            _current_position ++;
            
            if ([_controllers_array objectAtIndex:_current_position] == [NSNull null]) {
                [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",_current_position]
                                          sender:[NSNumber numberWithBool:isForward]];
            }
            else{
                [self swapFromViewController:_currentController
                            toViewController:[_controllers_array objectAtIndex:_current_position]
                                   isForward:isForward];
            }
        }
        else{
            _inTransition       = NO;
            //[_delegate getForwardMessageFromContainerWithMessage:kOpenConfirmation];
        }
        
    }
    else{
        NSLog(@"Backwards :%d",_current_position);
        if (_current_position > 0) {
            _current_position --;
            if ([_controllers_array objectAtIndex:_current_position] == [NSNull null]) {
                [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",_current_position]
                                          sender:[NSNumber numberWithBool:isForward]];
            }
            else{
                [self swapFromViewController:_currentController
                            toViewController:[_controllers_array objectAtIndex:_current_position]
                                   isForward:isForward];
            }
        }
        else{
            _inTransition       = NO;
            //[_delegate getBackMessageFromContainer];
        }
    }
}

- (void)passToNextStep:(NSDictionary *)aditionalData{
   
    id sender =  aditionalData;
    NSLog(@"sender in nextstep %ld ", (long)[sender tag]);
    

    if ([sender tag] == 400) {
        _current_position = 0;
        [self swapViewControllers:YES];
        
        [self swapFromViewController:_currentController
                    toViewController:[_controllers_array objectAtIndex:_current_position]
                           isForward:YES];

    }else
   
    if([sender tag] == 300){
       _current_position = 1;
       [self swapViewControllers:YES];

       [self swapFromViewController:_currentController
                   toViewController:[_controllers_array objectAtIndex:_current_position]
                          isForward:YES];
    
   }else if([sender tag] == 200){
    
       _current_position = 2;
       [self swapViewControllers:YES];

       [self swapFromViewController:_currentController
                   toViewController:[_controllers_array objectAtIndex:_current_position]
                          isForward:YES];

   
   }else{


    _current_position ++;
    [self swapViewControllers:YES];
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",_current_position] sender:aditionalData];
   }
}

- (void)cancelDataEntry{
    [_delegate cancelDataEntry];
}

- (void)backToPreviousStep:(NSDictionary *)aditionalData{
    [self swapViewControllers:NO];
}

- (void)passKeyboardShowEvent:(float)key_height txt_height:(CGRect)txt_frame{
    [_delegate passKeyboardShowEvent:key_height txt_height:txt_frame];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
