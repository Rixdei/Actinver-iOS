//
//  NavDrawerMenu.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 16/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "NavDrawerMenu.h"
#import "MainView.h"
#import "CustomizeControl.h"
#import "NavigationDrawer.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>


@interface NavDrawerMenu ()<UITableViewDataSource,UITableViewDelegate,ResponseFromServicesDelegate>

@property (nonatomic, strong)               NSArray     *menu_options;
@property (nonatomic, strong)   IBOutlet    UITableView *tbw_menu;
@property                                   int         selected_index;

@end

@implementation NavDrawerMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selected_index = 0;
    
//    _menu_options    = @[@"Mis Contratos", @"Consultas y Movimientos",@"Transferencias y \n Pagos",
//                         @"Administración de \n Cuentas", @"Altas", @"Terminar Sesión"];
    _menu_options    = @[@"Mis Contratos", @"Consultas",@"Transferencias y \n Pagos",@"Administración de Servicios",
                          @"Terminar Sesión"];
    
    [[RequestManager sharedInstance] dicToSend];
    NSString *name      = [[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"nombre"];
    NSString *lastname  = [[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"apaterno"];
    NSString *lasrname1 = [[[[RequestManager sharedInstance] dicToSend]objectForKey:@"usrData"]objectForKey:@"amaterno"];
    
    NSMutableString* user = [[NSMutableString alloc] initWithFormat:@"%@ %@ %@",name,lastname,lasrname1];
    [(UILabel*)[self.view viewWithTag:200] setText:user];
    
}

- (IBAction)openEditPerfilModal:(id)sender{
    NSLog(@"Edit Perfil Menu");
    [self performSegueWithIdentifier:@"segueEditProfile"
                              sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menu_options.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"CellMenuIdentifier"
                                                                  forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    
    UILabel *lbl_aux = (UILabel *)[cell viewWithTag:101];
    [lbl_aux    setText:[_menu_options objectAtIndex:[indexPath row]]];

    if (indexPath.row == _selected_index) {
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_drawer_itm_s_%d",(int)indexPath.row +1]]];
        [lbl_aux setTextColor:[CustomizeControl getYellowColor]];
    }
    else{
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_drawer_itm_n_%d",(int)indexPath.row +1]]];
        [lbl_aux setTextColor:[UIColor whiteColor]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selected_index == (int)indexPath) {
        return;
    }
    
    _selected_index = (int)indexPath.row;
    [_tbw_menu reloadData];
    
    if (indexPath.row == [_menu_options count] - 1) {
        NSLog(@"Logout: %@",[[RequestManager sharedInstance] keyToSend]);
        [RequestManager sharedInstance].delegate = self;
        [[RequestManager sharedInstance] sendRequestWithData: [@{@"append_key":[[RequestManager sharedInstance] keyToSend]} mutableCopy]
                                                    toMethod:KRequestLogout isPost:NO];
        return;
    }
    
    UINavigationController  *nav    = (UINavigationController *)self.mm_drawerController.centerViewController;
    MainView *aux                   =  (MainView *)[nav topViewController];
    [aux enterSectionWithIdentifier:(int)indexPath.row];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)responseFromService:(NSMutableDictionary *)response{

    // If the logout was successfull
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [((NavigationDrawer *)self.mm_drawerController) exitApplication];
        [LoadingView close];
    });
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
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
