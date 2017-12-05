//
//  AddCustomerVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "AddCustomerVC.h"
#import "Globle.h"

@interface AddCustomerVC ()<UITextFieldDelegate>

@end

@implementation AddCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    self.btnIdProof.layer.borderWidth=1;
    self.btnIdProof.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnIdProof.layer.cornerRadius=4;
    self.btnIdProof.clipsToBounds=YES;
    
    self.btnsigned.layer.borderWidth=1;
    self.btnsigned.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnsigned.layer.cornerRadius=4;
    self.btnsigned.clipsToBounds=YES;
    
    self.txtTermandConditin.layer.borderWidth=1;
    self.txtTermandConditin.layer.borderColor=[UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:.4f].CGColor;
    self.txtTermandConditin.layer.cornerRadius=4;
    self.txtTermandConditin.clipsToBounds=YES;

    
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    self.tblReferenceUserNameList.layer.borderWidth=1;
    self.tblReferenceUserNameList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblReferenceUserNameList.layer.cornerRadius=4;
    self.tblReferenceUserNameList.clipsToBounds=YES;

    
    self.tblReferenceUserNameList_Height.constant=0;
    
    self.tblReferenceUserNameList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [Utility setRightViewOfTextField:self.txtRefUserName rightImageName:@"down_arrow"];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.tblReferenceUserNameList_Height.constant=0;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tblReferenceUserNameList_Height.constant=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    /*NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.item_name CONTAINS[c] %@", searchString];
    NSArray *filteredArray = [arrMainItem filteredArrayUsingPredicate:predicate];
    arrItemList=[filteredArray mutableCopy];*/
    self.tblReferenceUserNameList_Height.constant=150;
    
    
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
    
    //UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
    //   UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - UIButton Action

- (IBAction)btnIdProof:(id)sender {
}

- (IBAction)btnsigned:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender {
}

@end
