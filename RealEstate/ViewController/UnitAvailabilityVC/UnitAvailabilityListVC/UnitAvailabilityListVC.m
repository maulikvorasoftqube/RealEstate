//
//  UnitAvailabilityListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "UnitAvailabilityListVC.h"
#import "Globle.h"
#import "Reachability.h"

@interface UnitAvailabilityListVC ()
{
    NSMutableArray *aryGetList;
    NSMutableDictionary *getAllDetailData;
    NSMutableDictionary *dicRes;
}
@end

@implementation UnitAvailabilityListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryGetList = [[NSMutableArray alloc]init];
    getAllDetailData = [[NSMutableDictionary alloc]init];
    dicRes = [[NSMutableDictionary alloc]init];
    
    [self commonData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
    self.tblUnitList.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getList];
}
#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryGetList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_unitlist"];
    
    if(indexPath.row % 2)
    {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    
    UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
    lbl.text = [NSString stringWithFormat:@"%@",[[aryGetList objectAtIndex:indexPath.row]objectForKey:@"WingName"]];
    
    UILabel *lbl1=(UILabel*)[cell.contentView viewWithTag:2];
    lbl1.text = [NSString stringWithFormat:@"%@",[[aryGetList objectAtIndex:indexPath.row]objectForKey:@"NoOfUnits"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     @property (strong,nonatomic)NSMutableDictionary *dicDetails;
     @property (strong,nonatomic)NSString *strWingID;
     */
    
    UnitAvailabilityDetailVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UnitAvailabilityDetailVC"];
    
    vc.strWingID = [NSString stringWithFormat:@"%@",[[aryGetList objectAtIndex:indexPath.row]objectForKey:@"WingID"]];
    vc.strWingNAME = [NSString stringWithFormat:@"%@",[[aryGetList objectAtIndex:indexPath.row]objectForKey:@"WingName"]];
    vc.dicDetails = [dicRes mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
}

#pragma mark - getlist

-(void)getList
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetList];

    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_strPropertyID forKey:@"PropertyID"];

    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             dicRes =  [Utility ConvertStringtoJSON:strJson];
             getAllDetailData = [dicRes mutableCopy];
             
             aryGetList = [dicRes objectForKey:@"Table"];
             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"WingName"
                                                 ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
             NSArray *sortedEventArray = [aryGetList
                                sortedArrayUsingDescriptors:sortDescriptors];
             aryGetList = [sortedEventArray mutableCopy];
             
             [_tblUnitList reloadData];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }

     }];
    
}


@end
