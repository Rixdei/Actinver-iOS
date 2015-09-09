//
//  SecurityImageSelector.m
//  Actinver_iOS
//
//  Created by Raymundo Pescador Piedra on 13/06/15.
//  Copyright (c) 2015 Sellcom Solutions. All rights reserved.
//

#import "SecurityImageSelector.h"

@interface SecurityImageSelector ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)               NSArray   *imagesArray;
@property (nonatomic, weak)     IBOutlet    UICollectionView *clv_sec_image;

@end

@implementation SecurityImageSelector

- (void)viewDidLoad {
    _imagesArray    = @[@"car",@"star",@"coffee",@"female",@"camera"];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imagesArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"secImageCellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *img_view = (UIImageView *)[cell viewWithTag:200];
    [img_view setImage:[UIImage imageNamed:[_imagesArray objectAtIndex:indexPath.row]]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                [_delegate updateImage:[_imagesArray objectAtIndex:indexPath.row]];
                             }];
}

@end
