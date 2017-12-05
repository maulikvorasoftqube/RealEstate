//
//  CustomerVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "CustomerVC.h"

@interface CustomerVC ()

@end

@implementation CustomerVC

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
    self.tblCustomerList.separatorStyle =UITableViewCellSeparatorStyleNone;
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
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnEditCustomer:(id)sender {
    
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnAddNewCustomer:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
