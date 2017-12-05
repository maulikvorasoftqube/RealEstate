//
//  CollectionVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "CollectionVC.h"
#import "Globle.h"

@interface CollectionVC ()

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    [self.viewFilterPopup setHidden:YES];
    
    self.viewInnerPopup.layer.cornerRadius=4;
    self.viewInnerPopup.clipsToBounds=YES;

    self.btnReset.layer.cornerRadius=4;
    self.btnReset.clipsToBounds=YES;

    self.btnSearch.layer.cornerRadius=4;
    self.btnSearch.clipsToBounds=YES;

    self.tblCollectionList.tableHeaderView=self.viewtblHeader;
    self.tblCollectionList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [Utility setRightViewOfTextField:self.txtSelectBlock rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectFromDate rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtselecttodate rightImageName:@"down_arrow"];
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
    [self.viewFilterPopup setHidden:NO];
}

- (IBAction)btnHome:(id)sender
{
}

- (IBAction)btnClose_filter:(id)sender
{
    [self.viewFilterPopup setHidden:YES];
}

- (IBAction)btnSelectBlock:(id)sender
{
}

- (IBAction)btnSelectfromdate:(id)sender
{
}

- (IBAction)btnselecttodate:(id)sender
{
}

- (IBAction)btnSearch:(id)sender
{
}

- (IBAction)btnReset:(id)sender
{
}
@end
