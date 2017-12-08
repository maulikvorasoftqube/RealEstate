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
    NSString *is_filterCall;
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
    //
    self.selected_FromDate = [NSDate date];
    self.selected_ToDate = [NSDate date];
    
    
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
    else
    {
        [self apiCall_GetALLBookingList];
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

-(void)apiCall_GetALLBookingList
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetAllBookingList];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             if(arrData.count != 0)
             {
                 if(![[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:0]objectForKey:@"success"] ]  isEqualToString:@"0"])
                 {
                     arrBookingList=[[NSMutableArray alloc]init];
                     
                     NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                         sortDescriptorWithKey:@"DateOfBooking"
                                                         ascending:NO];
                     NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                     NSArray *sortedEventArray = [arrData
                                                  sortedArrayUsingDescriptors:sortDescriptors];
                     arrBookingList = [sortedEventArray mutableCopy];
                     
                     arrBookingList_main=[[NSMutableArray alloc]init];
                     arrBookingList_main = [sortedEventArray mutableCopy];
                     
                     if(arrBookingList.count == 0 )
                     {
                         arrBookingList=[[NSMutableArray alloc]init];
                         arrBookingList_main=[[NSMutableArray alloc]init];
                         [WToast showWithText:@"No data found"];
                     }
                     [self.tblBookingList reloadData];
                     
                 }
                 else
                 {
                     arrBookingList=[[NSMutableArray alloc]init];
                     [WToast showWithText:@"No data found"];
                     [self.tblBookingList reloadData];
                     
                 }
             }
             else
             {
                 arrBookingList=[[NSMutableArray alloc]init];
                 [WToast showWithText:@"No data found"];
                 [self.tblBookingList reloadData];
                 
             }
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
         
     }];
    
}

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
             if(arrData.count != 0)
             {
                 if(![[NSString stringWithFormat:@"%@",[[arrData objectAtIndex:0]objectForKey:@"success"] ]  isEqualToString:@"0"])
                 {
                     arrBookingList=[[NSMutableArray alloc]init];
                     
                     NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                         sortDescriptorWithKey:@"DateOfBooking"
                                                         ascending:NO];
                     NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                     NSArray *sortedEventArray = [arrData
                                                  sortedArrayUsingDescriptors:sortDescriptors];
                     arrBookingList = [sortedEventArray mutableCopy];
                     
                     if([is_filterCall isEqualToString:@"YES"])
                     {
                         //nothing
                     }
                     else
                     {
                         arrBookingList_main=[[NSMutableArray alloc]init];
                         arrBookingList_main = [sortedEventArray mutableCopy];
                     }
                     if(arrBookingList.count == 0 )
                     {
                         arrBookingList=[[NSMutableArray alloc]init];
                         arrBookingList_main=[[NSMutableArray alloc]init];
                     }
                     [self.tblBookingList reloadData];                 }
                 else
                 {
                     arrBookingList=[[NSMutableArray alloc]init];
                     [self.tblBookingList reloadData];
                     [WToast showWithText:@"No data found"];
                 }
             }
             else
             {
                 arrBookingList=[[NSMutableArray alloc]init];
                 [self.tblBookingList reloadData];
                 [WToast showWithText:@"No data found"];
             }
             
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
    return [arrBookingList count];
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
    lblDate.text=[NSString stringWithFormat:@"%@",[Utility convertMiliSecondtoDate:@"dd-MM-yyyy" date:[[arrBookingList objectAtIndex:indexPath.row]objectForKey:@"DateOfBooking"]]];
    
    UILabel *lblFullName=(UILabel*)[cell.contentView viewWithTag:2];
    lblFullName.text=[NSString stringWithFormat:@"%@",[[arrBookingList objectAtIndex:indexPath.row]objectForKey:@"FullName"]];
    
    UILabel *lblRoomNo=(UILabel*)[cell.contentView viewWithTag:3];
    lblRoomNo.text=[NSString stringWithFormat:@"%@",[[arrBookingList objectAtIndex:indexPath.row]objectForKey:@"RoomNo"]];
    
    UILabel *lblUnitPrice=(UILabel*)[cell.contentView viewWithTag:4];
    lblUnitPrice.text=[NSString stringWithFormat:@"%@",[[arrBookingList objectAtIndex:indexPath.row]objectForKey:@"TotalPrice"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - actionSheet delegate

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    UIButton *btn=(UIButton*)element;
    if(btn.tag == 1)
    {
        self.selected_FromDate = selectedDate;
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSString *result = [df stringFromDate:self.selected_FromDate];
        
        self.txtSelectFromDate.text = result;
    }
    else
    {
        self.selected_ToDate = selectedDate;
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy"];
        NSString *result = [df stringFromDate:self.selected_ToDate];
        
        self.txtSelectToDate.text = result;
    }
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
    [self.view endEditing:YES];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selected_FromDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnSelectToDate:(id)sender {
    [self.view endEditing:YES];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selected_ToDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnSearch:(id)sender {
    
    NSString *strFromDate=self.txtSelectFromDate.text;
    NSString *strToDate=self.txtSelectToDate.text;
    
    if (strFromDate.length == 0)
    {
        strFromDate=@"";
    }
    else
    {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd/MM/yyyy"];
        strFromDate = [df stringFromDate:self.selected_FromDate];
    }
    
    if (strToDate.length == 0)
    {
        strToDate=@"";
    }
    else
    {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd/MM/yyyy"];
        strToDate = [df stringFromDate:self.selected_ToDate];
    }
    
    self.viewFilter_Popup.hidden=YES;
    is_filterCall=@"YES";
    [self apiCall_GetCurrentMonthBookingList:strFromDate toDate:strToDate];
}

- (IBAction)btnReset:(id)sender {
    
    self.txtSelectFromDate.text=@"";
    self.txtSelectToDate.text=@"";
    
    self.selected_FromDate = [NSDate date];
    self.selected_ToDate = [NSDate date];
    
    self.viewFilter_Popup.hidden=YES;
    arrBookingList=[arrBookingList_main mutableCopy];
    [self.tblBookingList reloadData];
}
@end
