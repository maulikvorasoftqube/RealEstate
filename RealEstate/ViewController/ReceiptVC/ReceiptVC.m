//
//  ReceiptVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "ReceiptVC.h"
#import "UnitDetailList_CollectionCell.h"
#import "Globle.h"

@interface ReceiptVC ()
{
    NSMutableArray *arrPropertyList,*arrUnitList,*arrSearch_UnitList;
    NSMutableArray *arrCustomer_UnitList;
    NSString *strSelectProperty;
    NSString *strSelectUntiId;
}
@end

@implementation ReceiptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    self.btnTakePic.layer.borderWidth=1;
    self.btnTakePic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnTakePic.layer.cornerRadius=4;
    self.btnTakePic.clipsToBounds=YES;
    
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    self.tblSelectUnitList_Height.constant=0;
    self.viewUnitDetailList_Height.constant=0;
    
    
    [Utility setRightViewOfTextField:self.txtbtnProperty rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtbtnSelectUnit rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectDate rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtPaymentMode rightImageName:@"down_arrow"];
    
    self.tblSelectUnit.layer.borderWidth=1;
    self.tblSelectUnit.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblSelectUnit.layer.cornerRadius=4;
    self.tblSelectUnit.clipsToBounds=YES;

    self.tblSelectUnit.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [self.viewUnitList_Popup setHidden:YES];
    
    [self apiCall_GetAllOptions];
}


#pragma mark - ApiCall

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
             
             arrPropertyList=[[NSMutableArray alloc]init];
             arrPropertyList=[dicData objectForKey:@"Table"];
             
             arrUnitList=[[NSMutableArray alloc]init];
             arrSearch_UnitList=[[NSMutableArray alloc]init];
             
             //sort
             NSMutableArray *arrSearch_UnitList_Temp=[dicData objectForKey:@"Table5"];
             
             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"RoomNo"
                                                 ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
             NSArray *sortedEventArray = [arrSearch_UnitList_Temp
                                          sortedArrayUsingDescriptors:sortDescriptors];
             arrUnitList = [sortedEventArray mutableCopy];
             arrSearch_UnitList = [sortedEventArray mutableCopy];
             
             [self.collection_UnitListPopup reloadData];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
     }];
}

-(void)apiCall_GetCustomerByUnitNo:(NSString *)strRoomID
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetCustomerByUnitNo];
    
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    [dic setObject:strRoomID forKey:@"UnitID"];
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             arrCustomer_UnitList =[[NSMutableArray alloc]init];
             arrCustomer_UnitList=[arrData mutableCopy];
             [self.collection_UnitDeailList reloadData];
             
             if(arrCustomer_UnitList.count != 0)
             {
                 self.viewUnitDetailList_Height.constant=232;
             }
             else
             {
                 self.viewUnitDetailList_Height.constant=0;
                 [WToast showWithText:@"Data not found!"];
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

#pragma mark - NIDropDown Delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender title:(NSString *)strTitle tag:(long)btntag rowIndex:(long)rowIndex
{
    self.txtbtnProperty.text=strTitle;
    strSelectProperty=[[arrPropertyList objectAtIndex:rowIndex]objectForKey:@"PropertyID"];
    
    [self rel];
}

-(void)rel{
    dropDown = nil;
}


#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == self.txtSearchUnitList)
    {
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtSearchUnitList)
    {
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtSearchUnitList)
    {
        NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.RoomNo CONTAINS[c] %@", searchString];
        NSArray *filteredArray = [arrSearch_UnitList filteredArrayUsingPredicate:predicate];
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"RoomNo"
                                            ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        NSArray *sortedEventArray = [filteredArray
                                     sortedArrayUsingDescriptors:sortDescriptors];
        arrUnitList = [sortedEventArray mutableCopy];

        
        [self.collection_UnitListPopup reloadData];
    }
    
    return YES;
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUnitList count];
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
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tblSelectUnitList_Height.constant=0;
    NSString *RoomID=[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"InvestorRoomID"];

    NSString *RoomNo=[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"];
    [self.txtbtnSelectUnit setText:RoomNo];
    
    [self apiCall_GetCustomerByUnitNo:RoomID];
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.collection_UnitListPopup)
    {
        return [arrUnitList count];
    }
    else
    {
        return [arrCustomer_UnitList count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collection_UnitListPopup)
    {
        UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
        UIView *view=(UIView*)[cell.contentView viewWithTag:1];
        view.layer.borderWidth=1;
        view.layer.cornerRadius=4;
        view.clipsToBounds=YES;
        view.layer.borderColor=[UIColor lightGrayColor].CGColor;

        UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
        lbl.text=[NSString stringWithFormat:@"%@",[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"]];
        
        return cell;
    }
    else
    {
        UnitDetailList_CollectionCell *cell=(UnitDetailList_CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
        cell.viewBackground.layer.borderWidth=1;
        cell.viewBackground.layer.cornerRadius=4;
        cell.viewBackground.clipsToBounds=YES;
        cell.viewBackground.layer.borderColor=[UIColor grayColor].CGColor;
        
        cell.lblUnit.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"UnitNo"]];
        cell.lblPrice.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"TotalPrice"]];
        
        if (![[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"paidAmount"] isKindOfClass:[NSNull class]])
        {
            cell.lblPaidAmount.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"paidAmount"]];
        }
        
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collection_UnitListPopup)
    {
        strSelectUntiId=[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"InvestorRoomID"];
        
        NSString *RoomNo=[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"];
        [self.txtbtnSelectUnit setText:RoomNo];
        [self.viewUnitList_Popup setHidden:YES];
        
        [self apiCall_GetCustomerByUnitNo:strSelectUntiId];
    }
    else
    {
    }
}

#pragma mark - UIButton Action

- (IBAction)btnProperty:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    arr=[[arrPropertyList valueForKey:@"PropertyName"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 50;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnUnit:(id)sender {
    [self.viewUnitList_Popup setHidden:NO];
}

- (IBAction)btnSelectDate:(id)sender {
}

- (IBAction)btnPaymentMode:(id)sender {
}

- (IBAction)btnTakePic:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClose_UnitListPopup:(id)sender {
    [self.viewUnitList_Popup setHidden:YES];
}

- (IBAction)btnContinue_UnitListPopup:(id)sender {
}
@end
