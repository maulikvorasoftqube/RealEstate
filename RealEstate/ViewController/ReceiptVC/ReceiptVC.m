//
//  ReceiptVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "ReceiptVC.h"
#import "UnitDetailList_CollectionCell.h"

@interface ReceiptVC ()

@end

@implementation ReceiptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
    self.btnTakePic.layer.borderWidth=1;
    self.btnTakePic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnTakePic.layer.cornerRadius=4;
    self.btnTakePic.clipsToBounds=YES;
    
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UnitDetailList_CollectionCell *cell=(UnitDetailList_CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
    cell.viewBackground.layer.borderWidth=1;
    cell.viewBackground.layer.cornerRadius=4;
    cell.viewBackground.clipsToBounds=YES;
    cell.viewBackground.layer.borderColor=[UIColor grayColor].CGColor;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UIButton Action

- (IBAction)btnProperty:(id)sender {
}

- (IBAction)btnUnit:(id)sender {
}

- (IBAction)btnSelectDate:(id)sender {
}

- (IBAction)btnPaymentMode:(id)sender {
}

- (IBAction)btnTakePic:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
