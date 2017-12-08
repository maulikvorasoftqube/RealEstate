//
//  AddBookingVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "AddBookingVC.h"
#import "UnitPrice_TblCellVC.h"
#import "Globle.h"

@interface AddBookingVC ()<UIActionSheetDelegate>
{
    NSMutableArray *aryBlock,*aryProperty,*aryUnit,*aryCustomerList,*aryTempUnitList,*aryCustomerListTemp,*aryAssignUnitNo;
    NSString*strProperyID,*strBlockPropertyID,*strUnitProperyID,*strDate,*strCustomerPropertyID,*strCutomerID,*strRoomID;
    NSString *unit;
}
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) ActionSheetDatePicker *actionSheetPicker;
@end

@implementation AddBookingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryBlock = [[NSMutableArray alloc]init];
    aryProperty = [[NSMutableArray alloc]init];
    aryUnit = [[NSMutableArray alloc]init];
    aryCustomerList = [[NSMutableArray alloc]init];
    aryTempUnitList = [[NSMutableArray alloc]init];
    aryAssignUnitNo = [[NSMutableArray alloc]init];
    aryCustomerListTemp = [[NSMutableArray alloc]init];
    
    
    [self.view endEditing:YES];
    
    self.selectedDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    self.actionSheetPicker.hideCancel = YES;
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_txtSearch_SelectUnitPopup];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange1:) name:UITextFieldTextDidChangeNotification object:_txtSelectCustomerName];
    
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
    self.btnSave.layer.borderWidth=.7f;
    self.btnSave.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    self.collection_SelectUnitList_Popup.layer.borderWidth=1;
    self.collection_SelectUnitList_Popup.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.collection_SelectUnitList_Popup.layer.cornerRadius=4;
    self.collection_SelectUnitList_Popup.clipsToBounds=YES;
    
    self.tblCustomerNameList.layer.borderWidth=1;
    self.tblCustomerNameList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblCustomerNameList.layer.cornerRadius=4;
    self.tblCustomerNameList.clipsToBounds=YES;
    
    self.btnContinue.layer.cornerRadius=4;
    self.btnContinue.clipsToBounds=YES;
    
    self.viewInnerSelectUnitList_popup.layer.cornerRadius=4;
    self.viewInnerSelectUnitList_popup.clipsToBounds=YES;
    
    self.tblCustomerNameList_Height.constant=0;
    self.viewUnitPriceList_Height.constant=0;
    
    
    self.tblCustomerNameList.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tblUnitPriceList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [Utility setRightViewOfTextField:self.txtSelectProperty rightImageName:@"down_arrow"];
    
    [Utility setRightViewOfTextField:self.txtSelectBlock rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectUnit rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectdateofbooking rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectCustomerName rightImageName:@"down_arrow"];
    
    [self.viewSelectUnit_popup setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self apiCall_GetAllOptionsAPI];
}
#pragma mark - UITextField Delegate

/*-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.tblCustomerNameList_Height.constant=0;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tblCustomerNameList_Height.constant=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    self.tblCustomerNameList_Height.constant=150;
 
    return YES;
}*/

#pragma mark - search textfield

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (_txtSearch_SelectUnitPopup.text.length == 0)
    {
        aryUnit = [[NSMutableArray alloc]initWithArray:aryTempUnitList];
        [_collection_SelectUnitList_Popup reloadData];
    }
    else
    {
        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:aryTempUnitList];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RoomNo contains[c] %@ ",_txtSearch_SelectUnitPopup.text];
        NSArray *result = [aryTemp filteredArrayUsingPredicate:predicate];
        aryUnit = [[NSMutableArray alloc]initWithArray:result];
        [_collection_SelectUnitList_Popup reloadData];
    }
}

- (void)textFieldDidChange1:(NSNotification *)notification
{
    if (_txtSelectCustomerName.text.length == 0)
    {
        aryCustomerList = [[NSMutableArray alloc]initWithArray:aryCustomerListTemp];
         self.tblCustomerNameList_Height.constant=0.0;
        [_tblCustomerNameList reloadData];
    }
    else
    {
        NSMutableArray *aryTemp = [[NSMutableArray alloc]initWithArray:aryCustomerListTemp];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FullName contains[c] %@ ",_txtSelectCustomerName.text];
        NSArray *result = [aryTemp filteredArrayUsingPredicate:predicate];
        aryCustomerList = [[NSMutableArray alloc]initWithArray:result];
         self.tblCustomerNameList_Height.constant=150.0;
        [_tblCustomerNameList reloadData];
    }
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return aryUnit.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
    
    UIView *view=(UIView*)[cell.contentView viewWithTag:1];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=4;
    view.clipsToBounds=YES;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    NSString *compareID = [NSString stringWithFormat:@"%@",[[aryUnit objectAtIndex:indexPath.row]objectForKey:@"Select"]];
    
    if ([compareID isEqualToString:@"1"])
    {
        view.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        view.backgroundColor = [UIColor clearColor];
    }
    
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:2];
    lb.text = [[aryUnit objectAtIndex:indexPath.row]objectForKey:@"RoomNo"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [[aryUnit objectAtIndex:indexPath.row]mutableCopy];
    NSString *compareID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Select"]];
    
    if ([compareID isEqualToString:@"0"])
    {
        [dic setObject:@"1" forKey:@"Select"];
        [aryUnit replaceObjectAtIndex:indexPath.row withObject:dic];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Select"];
        [aryUnit replaceObjectAtIndex:indexPath.row withObject:dic];
    }
    [_collection_SelectUnitList_Popup reloadData];
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblCustomerNameList)
    {
        return aryCustomerList.count;
    }
    else
    {
        return aryAssignUnitNo.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblCustomerNameList)
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
        
        cell.textLabel.text = [[aryCustomerList objectAtIndex:indexPath.row]objectForKey:@"FullName"];
        
        return cell;
    }
    else
    {
        UnitPrice_TblCellVC *cell=(UnitPrice_TblCellVC *)[tableView dequeueReusableCellWithIdentifier:@"UnitPrice_TblCell"];
        
        cell.lblUnitName.text = [NSString stringWithFormat:@"%@",[[aryAssignUnitNo objectAtIndex:indexPath.row]objectForKey:@"RoomNo"]];
        
      //  cell.txtUnitPrice
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblCustomerNameList)
    {
         strCutomerID = [[aryCustomerListTemp objectAtIndex:indexPath.row]objectForKey:@"InvestorID"];
        _txtSelectCustomerName.text = [[aryCustomerListTemp objectAtIndex:indexPath.row]objectForKey:@"FullName"];
        [_txtSelectCustomerName resignFirstResponder];
        
        [_tblCustomerNameList_Height setConstant:0.0];
    }
    else
    {
    }
   
}

#pragma mark - NIDropDown Delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender title:(NSString *)strTitle tag:(long)btntag rowIndex:(long)rowIndex
{
    if(btntag == 1)
    {
        _txtSelectProperty.text=strTitle;
        
        strProperyID=[[aryProperty objectAtIndex:rowIndex]objectForKey:@"PropertyID"];
        
        NSMutableArray *aryTmp = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dic in aryBlock)
        {
            NSString *strBlockProperyID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PropertyID"]];
            
            if ([strProperyID isEqualToString:strBlockProperyID])
            {
                [aryTmp addObject:dic];
            }
        }
        aryBlock = [aryTmp mutableCopy];
        
    }
    else if(btntag == 2)
    {
        _txtSelectBlock.text=strTitle;
        
        strBlockPropertyID =[[aryBlock objectAtIndex:rowIndex]objectForKey:@"PropertyID"];
        
        NSMutableArray *aryTmp = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dic in aryUnit)
        {
            NSString *strUnitProperyID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PropertyID"]];
            
            if ([strBlockPropertyID isEqualToString:strUnitProperyID])
            {
                [aryTmp addObject:dic];
            }
        }
        aryUnit = [aryTmp mutableCopy];
        aryTempUnitList = [aryTmp mutableCopy];
    }
    else if(btntag == 3)
    {
        /* _txtSelectUnit.text=strTitle;
         
         strUnitProperyID =[[aryUnit objectAtIndex:rowIndex]objectForKey:@"PropertyID"];*/
        
    }
    [self rel];
}

-(void)rel{
    dropDown = nil;
}

#pragma mark - UIButton Action

- (IBAction)btnSelectProperty:(id)sender
{
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    arr=[[aryProperty valueForKey:@"PropertyName"]mutableCopy];
    
    if(dropDown == nil)
    {
        int i = (int)(40*aryProperty.count);
        
        CGFloat f = [[NSString stringWithFormat:@"%d",i]floatValue];
        
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnSelectBlock:(id)sender
{
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    
    arr=[[aryBlock valueForKey:@"WingName"]mutableCopy];
    
    if(dropDown == nil)
    {
        int i = (int)(40*aryBlock.count);
        
        CGFloat f = [[NSString stringWithFormat:@"%d",i]floatValue];
        
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnSelectUnit:(id)sender
{
    [_collection_SelectUnitList_Popup reloadData];
    
    [self.viewSelectUnit_popup setHidden:NO];
    [self.view bringSubviewToFront:_viewSelectUnit_popup];
}
- (IBAction)btnClose_SelectUnit:(id)sender
{
    [self.viewSelectUnit_popup setHidden:YES];
}

- (IBAction)btnSelectdateofbooking:(id)sender
{
    [_txtSelectCustomerName resignFirstResponder];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    [self.actionSheetPicker showActionSheetPicker];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.selectedDate = selectedDate;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *result = [df stringFromDate:self.selectedDate];
    self.txtSelectdateofbooking.text = result;
}


- (IBAction)btnSave:(id)sender
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    if ([Utility validateBlankField:_txtSelectProperty.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTPROPERTY delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    if ([Utility validateBlankField:_txtSelectBlock.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTBLOCK delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    if ([Utility validateBlankField:_txtSelectUnit.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTUNIT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    if ([Utility validateBlankField:_txtSelectdateofbooking.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTDATE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    if ([Utility validateBlankField:_txtSelectCustomerName.text])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NAME delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"FullName contains[c] %@",
                                    _txtSelectCustomerName.text];
    
    
    NSArray *searchResults = [aryCustomerListTemp  filteredArrayUsingPredicate:resultPredicate];
    
    if (searchResults.count == 0)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTVALIDCUST delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    else
    {
    }
    
    for(int i=0;i<aryAssignUnitNo.count;i++)
    {
        NSMutableDictionary *dic = [[aryAssignUnitNo objectAtIndex:i]mutableCopy];
        
        UnitPrice_TblCellVC *cell = (UnitPrice_TblCellVC *)[_tblUnitPriceList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        int getprice = [[NSString stringWithFormat:@"%@",cell.txtUnitPrice.text]intValue];
        
        if ([cell.txtUnitPrice.text isEqualToString:@""])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:UNITPRICEADD delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        else if (getprice > 0)
        {
             [dic setValue:[NSString stringWithFormat:@"%d",getprice] forKey:@"UnitPrice"];
            [aryAssignUnitNo replaceObjectAtIndex:i withObject:dic];
        }
        else
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:UNITPRICE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
    }
//    NSLog(@"Assing=%@",aryAssignUnitNo);
     NSString *strDateofBooking = [Utility convertDateFtrToDtaeFtr:@"yyyy-MM-dd" newDateFtr:@"dd/MM/yyyy" date:_txtSelectdateofbooking.text];
//    NSLog(@"Date of booking=%@",strDateofBooking);
    
    NSMutableArray *aryUnitPR = [[NSMutableArray alloc]init];
    NSMutableArray *arySBA= [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *d in aryAssignUnitNo)
    {
        NSString *strPRice = [NSString stringWithFormat:@"%@",[d objectForKey:@"UnitPrice"]];
        [aryUnitPR addObject:strPRice];
        [arySBA addObject:[NSString stringWithFormat:@"%@",[d objectForKey:@"SBArea"]]];
    }
    NSString *strPRiceCom = [aryUnitPR componentsJoinedByString:@","];
    NSString *StrSBA = [arySBA componentsJoinedByString:@","];
    
    //NSLog(@"PRice=%@",strPRiceCom);
    
    //AddEditBooking
    
    //[self AddEditBooking1:@"" :strCutomerID :strRoomID : [[NSUserDefaults standardUserDefaults]valueForKey:@"UsearID"] :strPRiceCom :@"" :strDateofBooking];
    [self AddEditBooking1:@"" :strCutomerID :strRoomID :[[NSUserDefaults standardUserDefaults]valueForKey:@"UsearID"] :strPRiceCom :StrSBA :strDateofBooking];
    /* <InvestorRoomID>string</InvestorRoomID>
     
    <InvestorID>string</InvestorID>   strCutomerID
     
    <RoomID>string</RoomID>   strRoomID
     
    <UserID>string</UserID> [[NSUserDefaults standardUserDefaults]valueForKey:@"UsearID"]
     
    <UnitPrice>string</UnitPrice>
     
     
    <SBA>string</SBA>
     
    <DateOfBooking>string</DateOfBooking> self.txtSelectdateofbooking.text */
    
    //Date Formate:- dd/MM/yyyy
    
   
}
- (IBAction)btnAddNewCustomer:(id)sender
{
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnContinue:(id)sender
{
    NSMutableArray *unitNo = [[NSMutableArray alloc]init];
    NSMutableArray *arySelectUnit = [[NSMutableArray alloc]init];
     NSMutableArray *Roomid = [[NSMutableArray alloc]init];
    //strRoomID
    for (NSMutableDictionary *d in aryUnit)
    {
        NSString *strCheck = [NSString stringWithFormat:@"%@",[d objectForKey:@"Select"]];
        
        if ([strCheck isEqualToString:@"1"])
        {
            [arySelectUnit addObject:d];
        }
       
    }
    
    NSLog(@"COUNT UNIT===%lu",(unsigned long)arySelectUnit.count);
    
    if (arySelectUnit.count == 0)
    {
        _txtSelectUnit.text = @"";
        _viewSelectUnit_popup.hidden = YES;
        self.viewUnitPriceList_Height.constant = 0.0;
        
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTUNIT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    else
    {
        for (NSMutableDictionary *d in arySelectUnit)
        {
            [unitNo addObject:[d objectForKey:@"RoomNo"]];
            [Roomid addObject:[d objectForKey:@"RoomID"]];
            
        }
        
        unit = [unitNo componentsJoinedByString:@","];
        strRoomID = [Roomid componentsJoinedByString:@","];
        
        _txtSelectUnit.text = unit;
        _viewSelectUnit_popup.hidden = YES;
        
        aryAssignUnitNo = [arySelectUnit mutableCopy];
        [_tblUnitPriceList reloadData];
        self.viewUnitPriceList_Height.constant = (aryAssignUnitNo.count*52)+20;
        
        
    }
}
- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
}
#pragma mark - ApiCall

-(void)apiCall_GetAllOptionsAPI
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
             NSMutableDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             aryProperty = [dicData objectForKey:@"Table"];
             aryBlock = [dicData objectForKey:@"Table1"];
             aryUnit = [dicData objectForKey:@"Table3"];
             aryCustomerList = [dicData objectForKey:@"Table2"];
             aryCustomerListTemp =[aryCustomerList mutableCopy];
             [_tblCustomerNameList reloadData];
             
             //aryCustomerList
             
             NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:aryUnit];
             
             for (int i=0; i<mutableArray.count; i++)
             {
                 NSMutableDictionary *dicUnit=[NSMutableDictionary dictionaryWithDictionary:[aryUnit objectAtIndex:i]];
                 [dicUnit setObject:@"0" forKey:@"Select"];
                 [mutableArray replaceObjectAtIndex:i withObject:dicUnit];
             }
             aryUnit = mutableArray;
             
             NSArray *sortedArray = [aryProperty sortedArrayUsingComparator:^(NSDictionary* dic1, NSDictionary *dic2)
                                     {
                                         NSString *str1=[dic1 objectForKey:@"PropertyName"];
                                         NSString *str2=[dic2 objectForKey:@"PropertyName"];
                                         return [str1 compare:str2 options:NSNumericSearch];
                                     }];
             
             aryProperty = [sortedArray mutableCopy];
             
             NSArray *sortedArray1 = [aryBlock sortedArrayUsingComparator:^(NSDictionary* dic1, NSDictionary *dic2)
                                      {
                                          NSString *str1=[dic1 objectForKey:@"WingName"];
                                          NSString *str2=[dic2 objectForKey:@"WingName"];
                                          return [str1 compare:str2 options:NSNumericSearch];
                                      }];
             aryBlock = [sortedArray1 mutableCopy];
             
             NSArray *sortedArray2 = [aryUnit sortedArrayUsingComparator:^(NSDictionary* dic1, NSDictionary *dic2)
                                      {
                                          NSString *str1=[dic1 objectForKey:@"RoomNo"];
                                          NSString *str2=[dic2 objectForKey:@"RoomNo"];
                                          return [str1 compare:str2 options:NSNumericSearch];
                                      }];
             aryUnit = [sortedArray2 mutableCopy];
             
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
     }];
}

#pragma mark - addEditBookingAPI

-(void)AddEditBooking1 :(NSString *)strInvestorID :(NSString *)strCustomerID :(NSString *)strRoomID :(NSString *)userID :(NSString *)strPRice :(NSString *)SBA :(NSString *)BookingDate
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    /* <InvestorRoomID>string</InvestorRoomID>
     <InvestorID>string</InvestorID>
     <RoomID>string</RoomID>
     <UserID>string</UserID>
     <UnitPrice>string</UnitPrice>
     <SBA>string</SBA>
     <DateOfBooking>string</DateOfBooking>*/
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,AddEditBooking];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:strInvestorID forKey:@"InvestorRoomID"];
    [dic setObject:strCustomerID forKey:@"InvestorID"];
    [dic setObject:strRoomID forKey:@"RoomID"];
    [dic setObject:userID forKey:@"UserID"];
    [dic setObject:strPRice forKey:@"UnitPrice"];
    [dic setObject:SBA forKey:@"SBA"];
    [dic setObject:BookingDate forKey:@"DateOfBooking"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             
             NSMutableDictionary *dicRes =  [Utility ConvertStringtoJSON:strJson];
             
             NSArray *aryCustomerDetail = [dicRes mutableCopy];
             if([[[aryCustomerDetail objectAtIndex:0]objectForKey:@"success"]intValue] == 1)
             {
                 [WToast showWithText:@"Data saved"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:@"Network connection slow...." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alrt show];
                 return;
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

@end
