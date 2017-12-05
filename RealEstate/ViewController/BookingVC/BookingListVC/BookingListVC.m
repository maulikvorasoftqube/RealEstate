//
//  BookingListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "BookingListVC.h"

@interface BookingListVC ()

@end

@implementation BookingListVC

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
    self.viewFilter_Popup.hidden=YES;
    
    self.tblBookingList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.btnSearch.layer.cornerRadius=4;
    self.btnSearch.clipsToBounds=YES;
    
    self.btnReset.layer.cornerRadius=4;
    self.btnReset.clipsToBounds=YES;
    
    self.viewInner_filterPopup.layer.cornerRadius=4;
    self.viewInner_filterPopup.clipsToBounds=YES;
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
    self.viewFilter_Popup.hidden=NO;
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnClose_FilterPopup:(id)sender {
    self.viewFilter_Popup.hidden=YES;
}

- (IBAction)btnSelectFromDate:(id)sender {
}

- (IBAction)btnSelectToDate:(id)sender {
}

- (IBAction)btnSearch:(id)sender {
}

- (IBAction)btnReset:(id)sender {
}
@end
