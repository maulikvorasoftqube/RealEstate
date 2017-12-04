//
//  UnitAvailabilityListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "UnitAvailabilityListVC.h"
#import "Globle.h"

@interface UnitAvailabilityListVC ()
{
    NSMutableArray *aryGetList;
}
@end

@implementation UnitAvailabilityListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryGetList = [[NSMutableArray alloc]init];
    
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

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    //UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
 //   UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UnitAvailabilityDetailVC"];
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
    
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,GetList];

    [Utility PostApiCall:strURL params:nil block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
        // [FTIndicator dismissProgress];
         
         NSLog(@"datata=%@",dicResponce);
         
        //aryGetList
         
      /*   if ([[dicResponce objectForKey:@"status"]intValue] == 1)
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SUCCESSMSG delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:VALIDEMAIL delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
         }*/
         
     }];
    
}


@end
