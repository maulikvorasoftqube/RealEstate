//
//  CustomerVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "CustomerVC.h"
#import "Globle.h"

@interface CustomerVC ()
{
    NSMutableArray *aryCustomerDetail,*aryTempStoreList;
}
@end

@implementation CustomerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryCustomerDetail = [[NSMutableArray alloc]init];
    aryTempStoreList = [[NSMutableArray alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_txtSearch];
    
    [self commonData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
    self.tblCustomerList.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tblCustomerList.estimatedRowHeight=92.0f;
    
}

-(void)NotificationReceived:(NSNotification *)notif
{
    NSLog(@"dic=%@",notif.userInfo);
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *DicLoginData = (NSDictionary *)[[NSUserDefaults standardUserDefaults]valueForKey:@"LoginData"];
    
    [self getCustomerList:[DicLoginData objectForKey:@"UsearID"] :[DicLoginData objectForKey:@"CompanyID"]];
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCustomerDetail.count;
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
    lbl.text = [[aryCustomerDetail objectAtIndex:indexPath.row]objectForKey:@"FullName"];
    
    UILabel *lbl1=(UILabel*)[cell.contentView viewWithTag:2];
    
    NSString *checkUnitNo = [NSString stringWithFormat:@"%@",[[aryCustomerDetail objectAtIndex:indexPath.row]objectForKey:@"UnitNo"]];
    
    if ([checkUnitNo isEqualToString:@"<null>"])
    {
        lbl1.text = @"";
    }
    else
    {
        lbl1.text = [[aryCustomerDetail objectAtIndex:indexPath.row]objectForKey:@"UnitNo"];
    }
    
    UILabel *lbl2=(UILabel*)[cell.contentView viewWithTag:5];
    lbl2.text = [[aryCustomerDetail objectAtIndex:indexPath.row]objectForKey:@"MobileNo"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerDetailVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerDetailVC"];
    vc.DicCustomerDetail = [aryTempStoreList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - search textfield

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (_txtSearch.text.length == 0)
    {
        aryCustomerDetail = [[NSMutableArray alloc]initWithArray:aryTempStoreList];
        [_tblCustomerList reloadData];
    }
    else
    {
        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:aryTempStoreList];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FullName contains[c] %@ OR UnitNo contains[c] %@ OR MobileNo contains[c] %@",_txtSearch.text,_txtSearch.text,_txtSearch.text];
        
        NSArray *result = [aryTemp filteredArrayUsingPredicate:predicate];
        aryCustomerDetail = [[NSMutableArray alloc]initWithArray:result];
        [_tblCustomerList reloadData];
    }
}

#pragma mark - UIButton Action

- (IBAction)btnAddNewCustomer:(id)sender
{
    AddCustomerVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCustomerVC"];
    vc.strCheckAddEdit = @"Add";
    vc.aryCustomerList = [aryTempStoreList mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)btnEditCustomer:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblCustomerList];
    NSIndexPath *indexPath = [_tblCustomerList indexPathForRowAtPoint:buttonPosition];
    AddCustomerVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCustomerVC"];
    vc.DicEditCustomer = [aryCustomerDetail objectAtIndex:indexPath.row];
    vc.strCheckAddEdit = @"Edit";
    vc.aryCustomerList = [aryTempStoreList mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btn_Call_Clicked:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblCustomerList];
    NSIndexPath *indexPath = [_tblCustomerList indexPathForRowAtPoint:buttonPosition];
    
    NSString *callDial = [NSString stringWithFormat:@"%@",[[aryCustomerDetail objectAtIndex:indexPath.row]objectForKey:@"MobileNo"]];
     NSURL *url = [NSURL URLWithString:callDial];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
}

#pragma mark - API Customer List

-(void)getCustomerList : (NSString *)strUserID :(NSString *)strCompnyID
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetAllInvestors];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    //  <InvestorName>string</InvestorName>
    //  <CompanyID>guid</CompanyID>
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"InvestorName"];
    [dic setObject:strCompnyID forKey:@"CompanyID"];
    
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSMutableDictionary  *dicRes =  [Utility ConvertStringtoJSON:strJson];
             aryCustomerDetail = [dicRes mutableCopy];
             aryTempStoreList = [dicRes mutableCopy];
             
             [_tblCustomerList reloadData];
             
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
