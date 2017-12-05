//
//  ReceiptVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "ReceiptVC.h"
#import "UnitDetailList_CollectionCell.h"
#import "Globle.h"

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
    
    self.tblSelectUnitList_Height.constant=0;
    
    [Utility setRightViewOfTextField:self.txtbtnProperty rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtbtnSelectUnit rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectDate rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtPaymentMode rightImageName:@"down_arrow"];
    
    self.tblSelectUnit.layer.borderWidth=1;
    self.tblSelectUnit.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblSelectUnit.layer.cornerRadius=4;
    self.tblSelectUnit.clipsToBounds=YES;

    self.tblSelectUnit.separatorStyle =UITableViewCellSeparatorStyleNone;

}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.tblSelectUnitList_Height.constant=0;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tblSelectUnitList_Height.constant=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    /*NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.item_name CONTAINS[c] %@", searchString];
     NSArray *filteredArray = [arrMainItem filteredArrayUsingPredicate:predicate];
     arrItemList=[filteredArray mutableCopy];*/
    self.tblSelectUnitList_Height.constant=120;
    
    
    return YES;
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_row"];
    
    if(indexPath.row % 2)
    {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
