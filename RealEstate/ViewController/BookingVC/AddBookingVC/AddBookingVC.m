//
//  AddBookingVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "AddBookingVC.h"
#import "UnitPrice_TblCellVC.h"
#import "Globle.h"

@interface AddBookingVC ()

@end

@implementation AddBookingVC

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
    self.btnSave.layer.borderWidth=.7f;
    self.btnSave.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    self.collection_SelectUnitList_Popup.layer.borderWidth=1;
    self.collection_SelectUnitList_Popup.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.collection_SelectUnitList_Popup.layer.cornerRadius=4;
    self.collection_SelectUnitList_Popup.clipsToBounds=YES;
    
    self.tblCustomerNameList.layer.borderWidth=1;
    self.tblCustomerNameList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblCustomerNameList.layer.cornerRadius=4;
    self.tblCustomerNameList.clipsToBounds=YES;
    
    self.btnContinue.layer.cornerRadius=4;
    self.btnContinue.clipsToBounds=YES;
    
    self.viewInnerSelectUnitList_popup.layer.cornerRadius=4;
    self.viewInnerSelectUnitList_popup.clipsToBounds=YES;
    
    self.tblCustomerNameList_Height.constant=0;
    self.viewUnitPriceList_Height.constant=6*52;
    
    
    self.tblCustomerNameList.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tblUnitPriceList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [Utility setRightViewOfTextField:self.txtSelectProperty rightImageName:@"down_arrow"];
    
    [Utility setRightViewOfTextField:self.txtSelectBlock rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectUnit rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectdateofbooking rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectCustomerName rightImageName:@"down_arrow"];
    
    [self.viewSelectUnit_popup setHidden:YES];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.tblCustomerNameList_Height.constant=0;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tblCustomerNameList_Height.constant=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    /*NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.item_name CONTAINS[c] %@", searchString];
     NSArray *filteredArray = [arrMainItem filteredArrayUsingPredicate:predicate];
     arrItemList=[filteredArray mutableCopy];*/
    self.tblCustomerNameList_Height.constant=150;
    
    
    return YES;
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
    UIView *view=(UIView*)[cell.contentView viewWithTag:1];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=4;
    view.clipsToBounds=YES;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblCustomerNameList)
    {
        return 5;
    }
    else
    {
        return 6;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblCustomerNameList)
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
        
        //UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
        //   UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
        
        return cell;
    }
    else
    {
        UnitPrice_TblCellVC *cell=(UnitPrice_TblCellVC *)[tableView dequeueReusableCellWithIdentifier:@"UnitPrice_TblCell"];
        
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnSelectProperty:(id)sender {
}

- (IBAction)btnSelectBlock:(id)sender {
}

- (IBAction)btnSelectUnit:(id)sender {
    [self.viewSelectUnit_popup setHidden:NO];
}

- (IBAction)btnSelectdateofbooking:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnAddNewCustomer:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnClose_SelectUnit:(id)sender {
    [self.viewSelectUnit_popup setHidden:YES];
}

- (IBAction)btnContinue:(id)sender {
}
@end
