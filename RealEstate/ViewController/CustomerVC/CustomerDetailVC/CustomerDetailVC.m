//
//  CustomerDetailVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "CustomerDetailVC.h"
#import "Globle.h"

@interface CustomerDetailVC ()
{
    NSMutableArray *aryCustomeList;
}
@end

@implementation CustomerDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    aryCustomeList = [[NSMutableArray alloc]init];
    
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
   self.tblUnitDetailList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.tblUnitDetailList.tableHeaderView=self.viewHeader;
    self.tblUnitDetailList.tableFooterView=self.viewFooter;
}
-(void)viewWillAppear:(BOOL)animated
{
   // NSLog(@"Dic=%@",_DicCustomerDetail);
   //
    _lblCustomerName.text = [_DicCustomerDetail objectForKey:@"FullName"];
    _lblMobileNumber.text = [_DicCustomerDetail objectForKey:@"MobileNo"];
    NSString *strTearm = [NSString stringWithFormat:@"%@",[_DicCustomerDetail objectForKey:@"TermsAndCondition"]];
    
    if ([strTearm isEqualToString:@"<null>"])
    {
        _lblTermandcondition.text =@"";
    }
    else
    {
        _lblTermandcondition.text=strTearm;
    }
    [self getDetails:[_DicCustomerDetail objectForKey:@"InvestorID"] :[_DicCustomerDetail objectForKey:@"CompanyID"]];
}
#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCustomeList.count;
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
    lbl.text = [Utility convertMiliSecondtoDate:@"dd-MM-yyyy" date:[NSString stringWithFormat:@"%@",[[aryCustomeList objectAtIndex:indexPath.row]objectForKey:@"DateToPay"]]];
    
    UILabel *lbl1=(UILabel*)[cell.contentView viewWithTag:2];
    lbl1.text = [NSString stringWithFormat:@"%@",[[aryCustomeList objectAtIndex:indexPath.row]objectForKey:@"UnitNo"]];
    
     UILabel *lbl2=(UILabel*)[cell.contentView viewWithTag:3];
     lbl2.text = [NSString stringWithFormat:@"%@",[[aryCustomeList objectAtIndex:indexPath.row]objectForKey:@"TotalPrice"]];
    
     UILabel *lbl3=(UILabel*)[cell.contentView viewWithTag:4];
    lbl3.text = [NSString stringWithFormat:@"%@",[[aryCustomeList objectAtIndex:indexPath.row]objectForKey:@"DueAmount"]];
    
     UILabel *lbl4=(UILabel*)[cell.contentView viewWithTag:5];
    lbl4.text = [NSString stringWithFormat:@"%@",[[aryCustomeList objectAtIndex:indexPath.row]objectForKey:@"PaidAmount"]];
    
    
    return cell;
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
}

#pragma mark - API get Customer Detail

-(void)getDetails :(NSString *)strInvestorID :(NSString *)strCompny
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetInvestorDetails];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:strInvestorID forKey:@"InvestorID"];
    [dic setObject:strCompny forKey:@"CompanyID"];

    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson= [dicResponce objectForKey:@"d"];
          
             NSMutableDictionary  *dicRes =  [Utility ConvertStringtoJSON:strJson];
             aryCustomeList = [dicRes objectForKey:@"Table1"];
                NSLog(@"dic=%@",aryCustomeList);
             
             int getval = 0;
             
             for (NSMutableDictionary *d in aryCustomeList)
             {
                 getval = getval + [[NSString stringWithFormat:@"%@",[d objectForKey:@"PaidAmount"]]intValue];
             }
             //Helvetica Neue 17.0
             NSString *str = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",getval]];
             CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:17] constrainedToSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
             
             _lblHeader_TotalPaidAmount.text = [NSString stringWithFormat:@"%d",getval];
             
             [_lbTotalAmountWidth setConstant:size.width+5];
             
             [_tblUnitDetailList reloadData];
             
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
