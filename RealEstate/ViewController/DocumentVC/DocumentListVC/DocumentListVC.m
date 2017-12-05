//
//  DocumentListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "DocumentListVC.h"
#import "Globle.h"

@interface DocumentListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DocumentListVC

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
    [self.viewFilter setHidden:YES];
    self.tblDocumentList.separatorStyle =UITableViewCellSeparatorStyleNone;

    self.btnAddNewDocument.layer.cornerRadius=20;
    self.btnAddNewDocument.clipsToBounds=YES;
    
    self.viewInnerFilter.layer.cornerRadius=4;
    self.viewInnerFilter.clipsToBounds=YES;

    self.btnSearch.layer.cornerRadius=4;
    self.btnSearch.clipsToBounds=YES;

    self.btnReset.layer.cornerRadius=4;
    self.btnReset.clipsToBounds=YES;

    [self.tblDocumentList reloadData];
    
    [Utility setRightViewOfTextField:self.txtCustomerName_Filter rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectDocument_Filter rightImageName:@"down_arrow"];
}

#pragma mark - UITableView Section Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_section"];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_row"];
    
    UIView *view=(UIView*)[cell.contentView viewWithTag:1];
    view.layer.cornerRadius=4;
    view.clipsToBounds=YES;
    
    //UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
    //   UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFilter:(id)sender {
    [self.viewFilter setHidden:NO];
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnAddNewDocument:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UploadDocumentVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnClose_filterPopup:(id)sender {
[self.viewFilter setHidden:YES];
}

- (IBAction)btnSelectDocument_Filter:(id)sender {
}

- (IBAction)btnSelectCustomerName_Filter:(id)sender {
}

- (IBAction)btnSearch:(id)sender {
}

- (IBAction)btnReset:(id)sender {
}
@end
