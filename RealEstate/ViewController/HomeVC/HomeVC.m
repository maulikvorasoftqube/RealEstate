//
//  HomeVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "HomeVC.h"
#import "Globle.h"
#import "ReceiptVC.h"
#import "CollectionVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self GetStrategy];
}

#pragma mark - Count Action

- (IBAction)btnCount1:(id)sender {
    CollectionVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionVC"];
    vc.strNavigateToVC=@"today";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)btnCount2:(id)sender {
}

- (IBAction)btnCount3:(id)sender {
    BookingListVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
    vc.strNavigateToVC=@"current_month";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCount4:(id)sender {
    CollectionVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionVC"];
    vc.strNavigateToVC=@"last_month";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (IBAction)btnUnitAvailability:(id)sender
{
    UnitAvailabilityListVC *unit = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitAvailabilityListVC"];
    unit.strPropertyID = [[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyID"];
    [self.navigationController pushViewController:unit animated:YES];
}

- (IBAction)btnReceipt:(id)sender {
    ReceiptVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptVC"];
    vc.strNavigateToVC = @"receipt";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPayOut:(id)sender {
    ReceiptVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptVC"];
    vc.strNavigateToVC = @"payout";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCustomer:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnBooking:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddBookingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCollection:(id)sender {
    CollectionVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionVC"];
    vc.strNavigateToVC=@"current_month";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnDocument:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DocumentListVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get ALL strategy

-(void)GetStrategy
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GETALLSTRATEGY];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyID"] forKey:@"CompanyID"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJSON  = [dicResponce objectForKey:@"d"];
             NSMutableDictionary *Dic = [Utility ConvertStringtoJSON:strJSON];
             
             NSMutableArray *ary = [Dic mutableCopy];
             
             NSString *strTodayColl = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:0]objectForKey:@"TodayCollections"]];
             
             if ([strTodayColl isEqualToString:@"<null>"])
             {
                 _lblCount1.text =@"0";
             }
             else
             {
                 _lblCount1.text = strTodayColl;
             }
             
             _lblCount2.text = [NSString stringWithFormat:@"%@ / %@",[[ary objectAtIndex:0]objectForKey:@"TotalUnits"],[[ary objectAtIndex:0]objectForKey:@"BookedUnits"]];
             
             _lblCount3.text = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:0]objectForKey:@"LastMonthBookingCount"]];
             
             _lblCount4.text = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:0]objectForKey:@"LastMonthCollections"]];
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
