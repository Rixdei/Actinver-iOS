//
//  ModalEntryDataViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 24/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "ModalEntryDataViewController.h"

@interface ModalEntryDataViewController ()

@end

@implementation ModalEntryDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)captureData:(id)sender{
    
    #warning Validations for each textfield required for data
    
    NSMutableDictionary *recovered_data = [[NSMutableDictionary alloc] init];
    for (int i=1; i<10; i++){
        NSString *text = [(UITextField *)[self.view viewWithTag:1000 + i] text];
        if (text == nil)
            text = @"";
        [recovered_data setValue:text forKey:[NSString stringWithFormat:@"key_%d",i]];
    }
    
    NSLog(@"Data: %@",recovered_data);
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [_delegate notifyDataEntryEnteredInfo:recovered_data];
                             }];
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
