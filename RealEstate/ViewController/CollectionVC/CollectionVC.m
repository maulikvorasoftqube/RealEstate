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
{
    NSMutableArray *arrCollectionList,*arrCollectionList_main,*arrBlockList;
    NSString *strSelectBlockid;
}
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
    
    self.tblCollectionList.estimatedRowHeight=44;
    
    //
    self.selected_FromDate = [NSDate date];
    self.selected_ToDate = [NSDate date];
    
    [self apiCall_GetAllOptions];
    
    if([self.strNavigateToVC isEqualToString:@"current_month"])
    {
        NSString *FirstDate_CurrentMonth=[self getFirstDate_CurrntMonth];
        
        NSDateFormatter *ft=[[NSDateFormatter alloc]init];
        ft.dateFormat=@"dd/MM/yyyy";
        NSString *currentDate=[ft stringFromDate:[NSDate date]];
        
        [self apiCall_GetCollectionList:FirstDate_CurrentMonth ToDate:currentDate];
    }
    else if([self.strNavigateToVC isEqualToString:@"today"])
    {
        NSDateFormatter *ft=[[NSDateFormatter alloc]init];
        ft.dateFormat=@"dd/MM/yyyy";
        NSString *currentDate=[ft stringFromDate:[NSDate date]];
        
        [self apiCall_GetCollectionList:currentDate ToDate:currentDate];
    }
    else if([self.strNavigateToVC isEqualToString:@"last_month"])
    {
        NSString *FirstDate_lastMonth=[self getFirstDate_lastMonth];
        NSString *lastDate_lastMonth=[self getlastDate_lastMonth];
        
        [self apiCall_GetCollectionList:FirstDate_lastMonth ToDate:lastDate_lastMonth];
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

-(NSString *)getFirstDate_lastMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDate * firstDateOfMonth = [self returnDateForMonth:comps.month-1 year:comps.year day:1];
    
    NSDateFormatter *ft=[[NSDateFormatter alloc]init];
    ft.dateFormat=@"dd/MM/yyyy";
    NSString *firstdateofcurrentmonth=[ft stringFromDate:firstDateOfMonth];
    
    return firstdateofcurrentmonth;
}

-(NSString *)getlastDate_lastMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];

    NSDate * lastDateOfMonth = [self returnDateForMonth:comps.month year:comps.year day:0];
    
    NSDateFormatter *ft=[[NSDateFormatter alloc]init];
    ft.dateFormat=@"dd/MM/yyyy";
    NSString *lastdateofcurrentmonth=[ft stringFromDate:lastDateOfMonth];
    
    return lastdateofcurrentmonth;
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

-(void)apiCall_GetCollectionList:(NSString*)FromDate ToDate:(NSString*)ToDate
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetCollectionListByDateWise];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:FromDate forKey:@"FromDate"];
    [dic setObject:ToDate forKey:@"ToDate"];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             
             if ([arrData count] != 0)
             {
                 
                 arrCollectionList=[[NSMutableArray alloc]init];
                 arrCollectionList_main=[[NSMutableArray alloc]init];
                 NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                     sortDescriptorWithKey:@"DateToPay"
                                                     ascending:NO];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                 NSArray *sortedEventArray = [arrData
                                              sortedArrayUsingDescriptors:sortDescriptors];
                 arrCollectionList = [sortedEventArray mutableCopy];
                 arrCollectionList_main = [sortedEventArray mutableCopy];
                 
                 long paidAmount=0;
                 for(NSMutableDictionary *dic in arrCollectionList)
                 {
                     NSString *strPaidAmount=[dic objectForKey:@"PaidAmount"];
                     paidAmount=paidAmount+[strPaidAmount integerValue];
                 }
                 
                 if([arrCollectionList count] != 0)
                 {
                     self.tblCollectionList.tableFooterView=self.viewtblFooter;
                     if (paidAmount > 0) {
                         self.lbltblFooter_TotalPaidAmount.text=[NSString stringWithFormat:@"%ld",paidAmount];
                     }
                     else
                     {
                         self.lbltblFooter_TotalPaidAmount.text=@"0";
                     }
                 }
                 
                 [self.tblCollectionList reloadData];
                 
             }
             else
             {
                 [WToast showWithText:@"No data found!"];
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


-(void)apiCall_GetCollection_FilterList:(NSString*)WingID DueAmount:(NSString *)DueAmount PaidAmount:(NSString*)PaidAmount ToDate:(NSString*)ToDate FromDate:(NSString*)FromDate
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetCollectionList];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:FromDate forKey:@"FromDate"];
    [dic setObject:ToDate forKey:@"ToDate"];
    [dic setObject:PaidAmount forKey:@"PaidAmount"];
    [dic setObject:DueAmount forKey:@"DueAmount"];
    [dic setObject:WingID forKey:@"WingID"];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             
             if ([arrData count] != 0)
             {
                 arrCollectionList=[[NSMutableArray alloc]init];
                 NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                     sortDescriptorWithKey:@"DateToPay"
                                                     ascending:NO];
                 NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                 NSArray *sortedEventArray = [arrData
                                              sortedArrayUsingDescriptors:sortDescriptors];
                 arrCollectionList = [sortedEventArray mutableCopy];
                 
                 long paidAmount=0;
                 for(NSMutableDictionary *dic in arrCollectionList)
                 {
                     NSString *strPaidAmount=[dic objectForKey:@"PaidAmount"];
                     paidAmount=paidAmount+[strPaidAmount integerValue];
                 }
                 
                 if([arrCollectionList count] != 0)
                 {
                     self.tblCollectionList.tableFooterView=self.viewtblFooter;
                     if (paidAmount > 0)
                     {
                         self.lbltblFooter_TotalPaidAmount.text=[NSString stringWithFormat:@"%ld",paidAmount];
                     }
                     else
                     {
                         self.lbltblFooter_TotalPaidAmount.text=@"0";
                     }
                 }
                 
                 [self.tblCollectionList reloadData];
                 
             }
             else
             {
                 [WToast showWithText:@"No data found!"];
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


-(void)apiCall_GetAllOptions
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetAllOptions];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             
             arrBlockList=[[NSMutableArray alloc]init];
             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"WingName"
                                                 ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
             NSArray *sortedEventArray = [[dicData objectForKey:@"Table1"]
                                          sortedArrayUsingDescriptors:sortDescriptors];
             arrBlockList = [sortedEventArray mutableCopy];

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
    return [arrCollectionList count];
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
    
    UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
    lbl.text=[Utility convertMiliSecondtoDate:@"dd-MM-yyyy" date:[NSString stringWithFormat:@"%@",[[arrCollectionList objectAtIndex:indexPath.row] objectForKey:@"DateToPay"]]];
    
    
    UILabel *lblName=(UILabel*)[cell.contentView viewWithTag:2];
    lblName.text=[NSString stringWithFormat:@"%@",[[arrCollectionList objectAtIndex:indexPath.row] objectForKey:@"FullName"]];
    
    UILabel *lblUnitNo=(UILabel*)[cell.contentView viewWithTag:3];
    lblUnitNo.text=[NSString stringWithFormat:@"%@",[[arrCollectionList objectAtIndex:indexPath.row] objectForKey:@"UnitNo"]];
    
    UILabel *lblPaidAmount=(UILabel*)[cell.contentView viewWithTag:4];
    lblPaidAmount.text=[NSString stringWithFormat:@"%@",[[arrCollectionList objectAtIndex:indexPath.row] objectForKey:@"PaidAmount"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - NIDropDown Delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender title:(NSString *)strTitle tag:(long)btntag rowIndex:(long)rowIndex
{
   
    self.txtSelectBlock.text=strTitle;
    strSelectBlockid=[[arrBlockList objectAtIndex:rowIndex]objectForKey:@"WingID"];
    
    
    [self rel];
}

-(void)rel{
    dropDown = nil;
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
        
        self.txtselecttodate.text = result;
    }
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
    [self.view endEditing:YES];
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    arr=[[arrBlockList valueForKey:@"WingName"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 150;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnSelectfromdate:(id)sender
{
    [self.view endEditing:YES];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selected_FromDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnselecttodate:(id)sender
{
    [self.view endEditing:YES];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selected_ToDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnSearch:(id)sender
{
    NSString *strFromDate=self.txtSelectFromDate.text;
    NSString *strToDate=self.txtselecttodate.text;
    NSString *strDue=self.txtEnterdue.text;
    NSString *strPaidAmount=self.txtEnterPaidAmount.text;
    
    if (strSelectBlockid.length == 0)
    {
        strSelectBlockid=@"";
    }
    
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
    
    if (strDue.length == 0)
    {
        strDue=@"";
    }
    
    if (strPaidAmount.length == 0)
    {
        strPaidAmount=@"";
    }
    
    [self apiCall_GetCollection_FilterList:strSelectBlockid DueAmount:strDue PaidAmount:strPaidAmount ToDate:strToDate FromDate:strFromDate];
    [self.viewFilterPopup setHidden:YES];
}

- (IBAction)btnReset:(id)sender
{
    strSelectBlockid=@"";
    self.txtSelectBlock.text=@"";
    self.txtSelectFromDate.text=@"";
    self.txtselecttodate.text=@"";
    self.txtEnterdue.text=@"";
    self.txtEnterPaidAmount.text=@"";

    arrCollectionList=[arrCollectionList_main mutableCopy];
    [self.tblCollectionList reloadData];
    [self.viewFilterPopup setHidden:YES];
}
@end
