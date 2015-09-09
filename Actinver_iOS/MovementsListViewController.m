//
//  MovementsListViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 21/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "MovementsListViewController.h"
#import "Utility.h"

@interface MovementsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MovementsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr_movements count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"MovementsListCellIdentifier"
                                                                  forIndexPath:indexPath];
    
    NSDictionary *info = [[_arr_movements objectAtIndex:indexPath.row] objectForKey:@"movements"];
    
 //   if ([[[[_arr_movements objectAtIndex:indexPath.row] objectForKey:@"movements"] objectForKey:@"movementType"] isEqualToString:@"D"] || [[[[_arr_movements objectAtIndex:indexPath.row] objectForKey:@"movements"] objectForKey:@"movementType"] isEqualToString:@"C"] || [[[[_arr_movements objectAtIndex:indexPath.row] objectForKey:@"movements"] objectForKey:@"movementType"] isEqualToString:@"Retiro"] || [[[[_arr_movements objectAtIndex:indexPath.row] objectForKey:@"movements"] objectForKey:@"movementType"] isEqualToString:@"Deposito"]) {


    
       NSString *DateOperation     = [info objectForKey:@"operationDate"];
       NSString *dateString        = [NSString stringWithFormat:@"%@",DateOperation];
       NSInteger converterDate     = [dateString doubleValue];
       NSDate *date                = [NSDate dateWithTimeIntervalSince1970:(converterDate / 1000)];
       NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
       [formatDate setDateFormat:@"dd/MM/yyyy"];
       [formatDate stringFromDate:date];
    
        UILabel *aux_lbl1        =   (UILabel *)[cell viewWithTag:101];  // Operation Date
        [aux_lbl1 setText:[formatDate stringFromDate:date]];
    
       NSString *settlementDate    = [info objectForKey:@"operationTime"];
       NSString *settlementString  = [NSString stringWithFormat:@"%@",settlementDate];
       NSInteger converterdate     = [settlementString doubleValue];
       NSDate *Date                = [NSDate dateWithTimeIntervalSince1970:(converterdate / 1000)];
       NSDateFormatter *Formatdate = [[NSDateFormatter alloc]init];
       [Formatdate setDateFormat:@"dd/MM/yyyy"];
       [Formatdate stringFromDate:Date];

        UILabel *aux_lbl2        =   (UILabel *)[cell viewWithTag:102];        // Settlemment Date
        [aux_lbl2 setText:[Formatdate stringFromDate:Date]];
        
        UILabel *aux_lbl3        =   (UILabel *)[cell viewWithTag:103];
        [aux_lbl3 setText:[info objectForKey:@"movementConcept"]];             // Description
    
    
//    if ([info objectForKey:@"amountTitles"] == nil) {
//        UILabel *aux_lbl4        =   (UILabel *)[cell viewWithTag:104];
//        [aux_lbl4 setText:@"0"];  // Titles  , envia null
//    }else{
//        
//        UILabel *aux_lbl4        =   (UILabel *)[cell viewWithTag:104];
//        //[aux_lbl4 setText:[[info objectForKey:@"amountTitles"] stringValue]];  // Titles
//        [aux_lbl4 setText:[info objectForKey:@"amountTitles"]];  // Titles
//
//    }
//    
//    if ([info objectForKey:@"netAmount"]  == nil) {
//        
//        UILabel *aux_lbl5        =   (UILabel *)[cell viewWithTag:105];         // Price , envía null
//        [aux_lbl5 setText: @"0"];
//        
//    }else{
//        UILabel *aux_lbl5        =   (UILabel *)[cell viewWithTag:105];         // Price , envía null
//        //[aux_lbl5 setText: [[info objectForKey:@"netAmount"] stringValue]];
//        [aux_lbl5 setText: [info objectForKey:@"netAmount"]];
//
//    }
       //  [(UITextField*)[self.view viewWithTag:201]setText:[Utility stringWithMoneyFormat:[[details objectForKey:@"amount"] doubleValue]] ]

       NSDictionary *Amount = [info objectForKey:@"netAmount"];
       NSString *converDict = [NSString stringWithFormat:@"%@",Amount];
       NSInteger converterAmount = [converDict doubleValue];
       NSString *netAmount = [converDict substringFromIndex:1];
    
       if (converterAmount < 0) {
           
           UILabel *aux_lbl6        =   (UILabel*)[cell viewWithTag:106];     // Amount
//[_txt_balance setText:[NSString stringWithFormat:@"Cuenta Eje: %@",[Utility stringWithMoneyFormat:[[_contract_info objectForKey:@"cuentaEje"] doubleValue]]]];
           [aux_lbl6 setText:netAmount];
       }
    
    
  //}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155.f;
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
