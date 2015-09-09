//
//  DataEntryModalView.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 03/07/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "DataEntryModalView.h"
#import "ModalContainer.h"
#import "Utility.h"

@interface DataEntryModalView ()<MessagesFromContainerToModalDelegate>

@property                               ModalContainer      *container;
@property (nonatomic, weak) IBOutlet    UIView              *containerView;
@property (nonatomic, weak) IBOutlet    UIScrollView        *scrll_view;

@end

@implementation DataEntryModalView


/*
SimpleModal             = 0,    // Modal Entry-Confirmation
EntryTokenConfirmation  = 1,    // Modal Entry-Token-Confirmation
MenuModalToken          = 2,    // Modal Menu->Entry-Confirmation
MenuModalTokenConfirm   = 3     // Modal Menu->Entry-Token-Confirmation
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        NSLog(@"Segue embed: %@",_aditionalData);
        _container                  = segue.destinationViewController;
        _container.delegate         = self;
        _container.aditional_data   = _aditionalData;
        
      //  ((DataEntryModalView *)segue.destinationViewController).ProcessFlow = password;

        if (_kModalFlow == ChangeContractAlias) {
            _container.kModalType   = SimpleModal;
        }
    }
}

#pragma - mark MessagesFromContainerToModalDelegate

- (void)passToNextStep:(NSDictionary *)aditionalData{
    
}
- (void)cancelDataEntry{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

- (void)passKeyboardShowEvent:(float)key_height txt_height:(CGRect)txt_frame{
    
    CGRect final_frame = CGRectMake(txt_frame.origin.x + _containerView.frame.origin.x,
                                    txt_frame.origin.y + _containerView.frame.origin.y,
                                    txt_frame.size.width,
                                    txt_frame.size.height);
    
    UIEdgeInsets contentInsets              = UIEdgeInsetsMake(0.0, 0.0, key_height, 0.0);
    self.scrll_view.contentInset            = contentInsets;
    self.scrll_view.scrollIndicatorInsets   = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= key_height;
    
    if (!CGRectContainsPoint(aRect, final_frame.origin) ) {
        [self.scrll_view scrollRectToVisible:final_frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets              = UIEdgeInsetsZero;
    self.scrll_view.contentInset            = contentInsets;
    self.scrll_view.scrollIndicatorInsets   = contentInsets;
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
