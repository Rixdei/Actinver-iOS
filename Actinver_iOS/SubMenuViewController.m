//
//  SubMenuViewController.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "SubMenuViewController.h"
#import "InqAndMovsViewController.h"

@interface SubMenuViewController ()

@end

@implementation SubMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    int tag = (int)selectedCell.tag;
    
    if (tag == 301) {
        UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Módulo en Desarrollo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        return;
    }
    
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"%d",tag]
                              sender:[NSNumber numberWithInt:tag]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InqAndMovsViewController *aux   = segue.destinationViewController;
    aux.flow                        = [(NSNumber*)sender intValue];
}



@end
