//
//  Container.m
//  Actinver-IOS
//
//  Created by Raymundo Pescador Piedra on 25/03/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "Container.h"
#import "EnrollmentStepController.h"
#import "ShowChallengeViewController.h"
#import "Session.h"
#import "RequestManager.h"

@interface Container ()<NotifyModalEventsDelegate, ResponseFromServicesDelegate>

@property (strong, nonatomic)   NSString                    *currentSegueId;
@property (strong, nonatomic)   NSMutableArray              *controllers_array;
@property (assign, nonatomic)   BOOL                        inTransition;
@property (weak, nonatomic)     UIViewController            *currentController;

@end

@implementation Container

@synthesize current_position    = _current_position;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_processFlow == EnrollmentProcess)
        _child_number   = 10;
    else if (_processFlow == LoginProcess)
        _child_number   = 3;
    else
        _child_number   = 2;
    
    _controllers_array  = [[NSMutableArray alloc] init];
    for (int i=0; i<_child_number; i++)
        [_controllers_array addObject:[NSNull null]];
    
    _inTransition       = NO;
    _currentSegueId     = @"0";
    _current_position   = 0;
    
    [_delegate updateHeaderIndex: [NSString stringWithFormat:@"%d/%d",(_current_position + 1),_child_number]];
    NSLog(@"VISTA: %d/%d",(_current_position + 1),_child_number);
    [self performSegueWithIdentifier:_currentSegueId
                              sender:[NSNumber numberWithBool:YES]];
}

// Container start //
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    BOOL isForward = [(NSNumber *)sender boolValue];
    
    if (_processFlow == EnrollmentProcess || _processFlow == LoginProcess) {
        ((EnrollmentStepController *)segue.destinationViewController).enrollment_step   = _current_position;
        ((EnrollmentStepController *)segue.destinationViewController).processFlow       = _processFlow;
    }
    
    [_controllers_array replaceObjectAtIndex:_current_position withObject:segue.destinationViewController];
    
    if ([segue.identifier isEqualToString:@"0"] && _current_position == 0) {
        
        NSLog(@"First");
        
        _currentController          = segue.destinationViewController;
        
        if (_processFlow == TokenConfirmation) {
            ((ShowChallengeViewController *)_currentController).challenge_info  = _additionalData;
            ((ShowChallengeViewController *)_currentController).trans_array     = _additionalDataArray;
            ((ShowChallengeViewController *)_currentController).delegate        = self;
        }
        
        [self addChildViewController:_currentController];
        UIView  *destView           = ((UIViewController *)_currentController).view;
        destView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame              = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:destView];
        [segue.destinationViewController didMoveToParentViewController:self];
        
        
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
    
    if (_processFlow == TokenConfirmation) {
        ((ShowChallengeViewController *)toViewController).challenge_info  = _additionalData;
        ((ShowChallengeViewController *)toViewController).delegate        = self;
    }        
    
    [_delegate updateHeaderIndex: [NSString stringWithFormat:@"%d/%d",(_current_position + 1),_child_number]];
    
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
                                _currentController  = toViewController;
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
        
        if (_processFlow == EnrollmentProcess || _processFlow == LoginProcess) {
            if (![(EnrollmentStepController *)_currentController validateStepFields]) {
                _inTransition       = NO;
                return;
            }
        }
        
        if (_current_position < ([_controllers_array count] -1)) {
            _current_position ++;
            
            if (_current_position == 2 && _processFlow == LoginProcess) {
                _inTransition       = NO;
                [_delegate getForwardMessageFromContainerWithMessage:(kSendLogin)];
                return;
            }
            
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
            [_delegate getForwardMessageFromContainerWithMessage:kOpenConfirmation];
        }
        
        if (_current_position == 1 && _processFlow == EnrollmentProcess) {
            _inTransition       = NO;
            [_delegate getForwardMessageFromContainerWithMessage:(KTokenGenerate)];         // SFT22
            return;
        }
        if (_current_position == 4 && _processFlow == EnrollmentProcess) {
            _inTransition       = NO;
            [_delegate getForwardMessageFromContainerWithMessage:(KEnrolmentQuestion)];    // PRA12
            return;
        }
        if (_current_position == 8 && _processFlow == EnrollmentProcess) {
            _inTransition       = NO;
            [_delegate getForwardMessageFromContainerWithMessage:(KImageQuestion)];         // PRA05
            return;
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
            [_delegate getBackMessageFromContainer];
        }
    }
}

- (void)showTokenView{
    //_current_position ++;
    [self performSegueWithIdentifier:@"2"
                              sender:[NSNumber numberWithBool:YES]];
    
    NSMutableDictionary    *params = [@{@"language"         : @"SPA",
                                        @"userId"           : [[Session sharedManager].pre_session_info objectForKey:@"username"],
                                        @"append_key"       :[[RequestManager sharedInstance] keyToSend]} mutableCopy];
//    [RequestManager sharedInstance].delegate = self;
    [[RequestManager sharedInstance] sendRequestWithData:params toMethod:KGenerateChallenge isPost:YES];   // SFT21
}

#pragma mark NotifyModalEventsDelegate

-(void) notifyDataEntryWasCancelled{
    NSLog(@"Data Cancelled");
    [_delegate getForwardMessageFromContainerWithMessage:kSendTransaction];        
}
-(void) notifyDataEntryEnteredInfo:(NSMutableDictionary *)info{
    [_additionalData addEntriesFromDictionary:info];
    
    if ([[[info objectForKey:@"outServicePaymentRequest"] objectForKey:@"transferResult"] objectForKey:@"transferReference"] == NULL)
       
      
        [_delegate getForwardMessageFromContainerWithMessage:kSendTransaction];
        
    else
        [_delegate getForwardMessageFromContainerWithMessage:kOpenTransactionSucceed];

}

-(void) notifyReturnToMainViewWithMessage:(MessageFromEnrollmentStep)messageType{
    NSLog(@"In container");
    [_delegate getBackMessageFromContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
