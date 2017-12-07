//
//  BookingListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "BookingListVC.h"

@interface BookingListVC ()
{
    NSMutableArray *arrBookingList,*arrBookingList_main;
}
@end

@implementation BookingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    if([_strNavigateToVC isEqualToString:@"current_month"])
    {
        NSString *FirstDate_CurrentMonth=[self getFirstDate_CurrntMonth];
        
        NSDateFormatter *ft=[[NSDateFormatter alloc]init];
        ft.dateFormat=@"dd/MM/yyyy";
        NSString *currentDate=[ft stringFromDate:[NSDate date]];
        
        [self apiCall_GetCurrentMonthBookingList:FirstDate_CurrentMonth toDate:currentDate];
    }
    
}

-(NSString *)getFirstDate_CurrntMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDate * firstDateOfMonth = [self returnDateForMonth:comps.month year:comps.year day:1];
    
    NSDateFormatter *ft=[[NSDateFormatter alloc]init];
    ft.dateFormat=@"dd/MM/yyyy";
    NSString *firstdateofcurrentmonth=[ft stringFromDate:firstDateOfMonth];
    
    return firstdateofcurrentmonth;
}

- (NSDate *)returnDateForMonth:(NSInteger)month year:(NSInteger)year day:(NSInteger)day {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian dateFromComponents:components];
}

#pragma mark - ApiCall

-(void)apiCall_GetCurrentMonthBookingList:(NSString *)fromDate toDate:(NSString*)toDate
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetCurrentMonthBookingList];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:fromDate forKey:@"FromDate"];
    [dic setObject:toDate forKey:@"ToDate"];
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             
             arrBookingList=[[NSMutableArray alloc]init];
             arrBookingList_main=[[NSMutableArray alloc]init];
             arrBookingList =[arrData mutableCopy];
             arrBookingList_main =[arrData mutableCopy];
             [self.tblBookingList reloadData];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
     }];
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
    
    UILabel *lblDate=(UILabel*)[cell.contentView viewWithTag:1];
    lblDate.text=[Utility convertMiliSecondtoDate:@"" date:[[arrBookingList objectAtIndex:indexPath.row]objectForKey:@"DateOfBooking"]];
    
    UILabel *lblFullName=(UILabel*)[cell.contentView viewWithTag:2];
    
    UILabel *lblRoomNo=(UILabel*)[cell.contentView viewWithTag:3];
    
    UILabel *lblUnitPrice=(UILabel*)[cell.contentView viewWithTag:4];
    
    
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
