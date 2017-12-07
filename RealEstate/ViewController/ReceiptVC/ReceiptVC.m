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
    NSString *strSelectProperty,*strSelect_InvestorId;
    NSString *strSelectUntiId,*strSelectImage,*strSelect_PaymentModeId;
    
    NSMutableArray *arrPaymentModeType;
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
    if([self.strNavigateToVC isEqualToString:@"payout"])
    {
        self.lblHeaderTitle.text=@"PayOut";
    }
    else
    {
        self.lblHeaderTitle.text=@"Receipt";
    }
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
    
    self.selectedDate = [NSDate date];
    
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
             
             arrPaymentModeType=[[NSMutableArray alloc]init];
             arrPaymentModeType=[dicData objectForKey:@"Table4"];
             
             arrUnitList=[[NSMutableArray alloc]init];
             arrSearch_UnitList=[[NSMutableArray alloc]init];
             
             //sort
             NSMutableArray *arrSearch_UnitList_Temp=[dicData objectForKey:@"Table5"];
             NSArray *sortedArray = [arrSearch_UnitList_Temp sortedArrayUsingComparator:^(NSDictionary *dic1, NSDictionary *dic2) {
                 NSString *str1=[dic1 objectForKey:@"RoomNo"];
                 NSString *str2=[dic2 objectForKey:@"RoomNo"];
                 return [str1 compare:str2 options:NSNumericSearch];
             }];
             arrUnitList = [sortedArray mutableCopy];
             arrSearch_UnitList = [sortedArray mutableCopy];
             
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
             
             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"UnitNo"
                                                 ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
             NSArray *sortedEventArray = [arrData
                                          sortedArrayUsingDescriptors:sortDescriptors];
             arrCustomer_UnitList = [sortedEventArray mutableCopy];
             [self.collection_UnitDeailList reloadData];
             
             if(arrCustomer_UnitList.count != 0)
             {
                 strSelect_InvestorId=[[arrCustomer_UnitList objectAtIndex:0]objectForKey:@"InvestorID"];
                 NSString *FullName=[[arrCustomer_UnitList objectAtIndex:0]objectForKey:@"FullName"];
                 self.lblCustomerName.text=FullName;
                 self.viewUnitDetailList_Height.constant=232;
             }
             else
             {
                 arrCustomer_UnitList =[[NSMutableArray alloc]init];
                 self.viewUnitDetailList_Height.constant=0;
                 [self.collection_UnitDeailList reloadData];
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


-(void)apiCall_AddEditReceipt
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    NSString *UserID=[[NSUserDefaults standardUserDefaults]objectForKey:@"UsearID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,AddEditReceipt];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@"" forKey:@"InvestorPaymentReceiptID"];
    [dic setObject:strSelect_InvestorId forKey:@"InvestorID"];

    //set PayaAmount Array
    NSMutableArray *arrPayAmount_Temp=[[NSMutableArray alloc]init];
    for (int i=0; i<[arrCustomer_UnitList count];i++) {
        NSMutableDictionary *dic = [[arrCustomer_UnitList objectAtIndex:i]mutableCopy];
        NSString *PayAmount=[dic objectForKey:@"PayAmount"];
        if([PayAmount integerValue] > 0)
        {
            [arrPayAmount_Temp addObject:dic];
        }
        else if([Utility validateNumberString:PayAmount] == YES)
        {
            [arrPayAmount_Temp addObject:dic];
        }
    }
    
    //setPayAmount Unit Id
    NSArray *arrPayAmountUnitId=[arrPayAmount_Temp valueForKey:@"UnitID"];
    NSString *strPayAmountUnitId=[arrPayAmountUnitId componentsJoinedByString:@","];
    [dic setObject:strPayAmountUnitId forKey:@"UnitID"];
    
    //setPayAmount Unit Id
    NSArray *arrPayAmount=[arrPayAmount_Temp valueForKey:@"PayAmount"];
    NSString *strPayAmount=[arrPayAmount componentsJoinedByString:@","];
    [dic setObject:strPayAmount forKey:@"PaidAmount"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *result = [df stringFromDate:self.selectedDate];
    [dic setObject:result forKey:@"Date"];
    [dic setObject:strSelectProperty forKey:@"PropertyID"];
    [dic setObject:strSelect_PaymentModeId forKey:@"ModeOfPaymentTermID"];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    [dic setObject:UserID forKey:@"UserID"];
    
    NSData *data = UIImagePNGRepresentation(_btnTakePic.currentBackgroundImage);
    const unsigned char *bytes = [data bytes];
    NSUInteger length = [data length];
    NSMutableArray *byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++)
    {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    
    [dic setValue:byteArray forKey:@"ReceiptFile"];
    [dic setValue:[NSString stringWithFormat:@"%@.png",[Utility randomImageGenerator]] forKey:@"ReceiptFileName"];
    
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             if([arrData count] != 0)
             {
                 if([[[arrData objectAtIndex:0]objectForKey:@"success"] integerValue] == 1)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [WToast showWithText:@"Pleasew try agai!"];
                 }
             }
             else
             {
                 [WToast showWithText:@"Pleasew try agai!"];
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

-(void)apiCall_AddEditPayOut
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    NSString *UserID=[[NSUserDefaults standardUserDefaults]objectForKey:@"UsearID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,AddEditPayOut];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@"" forKey:@"InvestorPaymentReceiptID"];
    [dic setObject:strSelect_InvestorId forKey:@"InvestorID"];
    
    //set PayaAmount Array
    NSMutableArray *arrPayAmount_Temp=[[NSMutableArray alloc]init];
    for (int i=0; i<[arrCustomer_UnitList count];i++) {
        NSMutableDictionary *dic = [[arrCustomer_UnitList objectAtIndex:i]mutableCopy];
        NSString *PayAmount=[dic objectForKey:@"PayAmount"];
        if([PayAmount integerValue] > 0)
        {
            [arrPayAmount_Temp addObject:dic];
        }
        else if([Utility validateNumberString:PayAmount] == YES)
        {
            [arrPayAmount_Temp addObject:dic];
        }
    }
    
    //setPayAmount Unit Id
    NSArray *arrPayAmountUnitId=[arrPayAmount_Temp valueForKey:@"UnitID"];
    NSString *strPayAmountUnitId=[arrPayAmountUnitId componentsJoinedByString:@","];
    [dic setObject:strPayAmountUnitId forKey:@"UnitID"];
    
    //setPayAmount Unit Id
    NSArray *arrPayAmount=[arrPayAmount_Temp valueForKey:@"PayAmount"];
    NSString *strPayAmount=[arrPayAmount componentsJoinedByString:@","];
    [dic setObject:strPayAmount forKey:@"PaidAmount"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *result = [df stringFromDate:self.selectedDate];
    [dic setObject:result forKey:@"Date"];
    [dic setObject:strSelectProperty forKey:@"PropertyID"];
    [dic setObject:strSelect_PaymentModeId forKey:@"ModeOfPaymentTermID"];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    [dic setObject:UserID forKey:@"UserID"];
    
    NSData *data = UIImagePNGRepresentation(_btnTakePic.currentBackgroundImage);
    const unsigned char *bytes = [data bytes];
    NSUInteger length = [data length];
    NSMutableArray *byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++)
    {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    
    [dic setValue:byteArray forKey:@"ReceiptFile"];
    [dic setValue:[NSString stringWithFormat:@"%@.png",[Utility randomImageGenerator]] forKey:@"ReceiptFileName"];
    
    
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJson = [dicResponce objectForKey:@"d"];
             NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
             
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             if([arrData count] != 0)
             {
                 if([[[arrData objectAtIndex:0]objectForKey:@"success"] integerValue] == 1)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [WToast showWithText:@"Pleasew try agai!"];
                 }
             }
             else
             {
                 [WToast showWithText:@"Pleasew try agai!"];
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
    if(btntag == 1)
    {
        self.txtbtnProperty.text=strTitle;
        strSelectProperty=[[arrPropertyList objectAtIndex:rowIndex]objectForKey:@"PropertyID"];
    }
    else if(btntag == 2)
    {
        self.txtPaymentMode.text=strTitle;
        strSelect_PaymentModeId=[[arrPaymentModeType objectAtIndex:rowIndex]objectForKey:@"TermID"];

    }
    
    
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
    else if(textField.text.length != 0)
    {
        NSMutableDictionary *dic=[[arrCustomer_UnitList objectAtIndex:textField.tag]mutableCopy];
        [dic setObject:textField.text forKey:@"PayAmount"];
        [arrCustomer_UnitList removeObjectAtIndex:textField.tag];
        [arrCustomer_UnitList insertObject:dic atIndex:textField.tag];
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
    [self.view endEditing:YES];
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
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:2];
        lbl.text=[NSString stringWithFormat:@"%@",[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"]];
        
        NSString *isSelected=[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"isSelected"];
        if ([isSelected integerValue] == 1)
        {
            view.backgroundColor=[UIColor lightGrayColor];
        }
        else
        {
            view.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    }
    else
    {
        UnitDetailList_CollectionCell *cell=(UnitDetailList_CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
        cell.viewBackground.layer.borderWidth=1;
        cell.viewBackground.layer.cornerRadius=4;
        cell.viewBackground.clipsToBounds=YES;
        cell.viewBackground.layer.borderColor=[UIColor grayColor].CGColor;
        
        cell.lblUnit.text=@"0";
        cell.lblUnit.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"UnitNo"]];
       
        cell.lblPrice.text=@"0";
        cell.lblPrice.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"TotalPrice"]];
        
        cell.lblPaidAmount.text=@"0";
        if (![[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"paidAmount"] isKindOfClass:[NSNull class]])
        {
            cell.lblPaidAmount.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"paidAmount"]];
        }
        
        //textfield
        cell.txtEnterAmount.tag=indexPath.row;
        
        cell.txtEnterAmount.text=nil;
        
        NSString *strPayAmount=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"PayAmount"]];
        if(strPayAmount.length != 0 && ![strPayAmount isEqualToString:@"(null)"])
        {
            cell.txtEnterAmount.text=[NSString stringWithFormat:@"%@",[[arrCustomer_UnitList objectAtIndex:indexPath.row]objectForKey:@"PayAmount"]];
        }
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if(collectionView == self.collection_UnitListPopup)
    {
        strSelectUntiId=[[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"InvestorRoomID"]mutableCopy];
        
        NSString *RoomNo=[[[arrUnitList objectAtIndex:indexPath.row] objectForKey:@"RoomNo"]mutableCopy];
        [self.txtbtnSelectUnit setText:RoomNo];
        [self.viewUnitList_Popup setHidden:YES];
        
        
        //setselected flag
        for (int i=0;i<[arrUnitList count];i++)
        {
            NSMutableDictionary *dic=[[arrUnitList objectAtIndex:i]mutableCopy];
            NSString *InvestorRoomID=[[dic objectForKey:@"InvestorRoomID"]mutableCopy];
            
            if ([strSelectUntiId isEqualToString:InvestorRoomID])
            {
                [dic setObject:@"1" forKey:@"isSelected"];
                [arrUnitList removeObjectAtIndex:indexPath.row];
                [arrUnitList insertObject:dic atIndex:indexPath.row];
            }
            else
            {
                [dic setObject:@"0" forKey:@"isSelected"];
                [arrUnitList removeObjectAtIndex:i];
                [arrUnitList insertObject:dic atIndex:i];
            }
        }
        
        [self.collection_UnitListPopup reloadData];
        [self apiCall_GetCustomerByUnitNo:strSelectUntiId];
    }
    else
    {
    }
}

#pragma mark - actionSheet delegate

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.selectedDate = selectedDate;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *result = [df stringFromDate:self.selectedDate];
    
    self.txtSelectDate.text = result;
}

#pragma mark - UIImagePicker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    strSelectImage=@"1";
    UIImage *selectImage;
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        selectImage= info[UIImagePickerControllerEditedImage];
    }
    else
    {
        selectImage= info[UIImagePickerControllerOriginalImage];
    }
    
    [self.btnTakePic setBackgroundImage:selectImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.btnTakePic setAttributedTitle:nil forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    strSelectImage=@"0";
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIButton Action

- (IBAction)btnProperty:(id)sender {
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    [self.viewUnitList_Popup setHidden:NO];
}

- (IBAction)btnSelectDate:(id)sender {
    [self.view endEditing:YES];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2015];
    //  NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    // NSDate *maxDate = [NSDate date];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    
    //  [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    //  [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    //[self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    //[self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSCalendarUnitDay amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];

    
}

- (IBAction)btnPaymentMode:(id)sender {
    [self.view endEditing:YES];
    NSArray * arrimg = [[NSArray alloc] init];
    
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :[arrPaymentModeType valueForKey:@"Term"] :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnTakePic:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attach image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* pickFromGallery = [UIAlertAction actionWithTitle:@"Take a photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                                                {
                                                                    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                                                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                    picker.delegate = (id)self;
                                                                    [self presentViewController:picker animated:YES completion:NULL];
                                                                }
                                                                
                                                            }];
    UIAlertAction* takeAPicture = [UIAlertAction actionWithTitle:@"Choose from gallery"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                                             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             picker.delegate = (id)self;
                                                             picker.allowsEditing=YES;
                                                             [self presentViewController:picker animated:YES completion:NULL];
                                                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alertController addAction:pickFromGallery];
    [alertController addAction:takeAPicture];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)btnSave:(id)sender {
    [self.view endEditing:YES];
    if([Utility validateBlankField:self.txtbtnProperty.text])
    {
        [WToast showWithText:@"Please select property!"];
        return;
    }
    if([Utility validateBlankField:self.txtbtnSelectUnit.text])
    {
        [WToast showWithText:@"Please select unit!"];
        return;
    }
    
    NSString *is_enterPayAMount=@"0";
    for (int i=0; i<[arrCustomer_UnitList count];i++) {
        NSMutableDictionary *dic = [[arrCustomer_UnitList objectAtIndex:i]mutableCopy];
        NSString *PayAmount=[dic objectForKey:@"PayAmount"];
        if([PayAmount integerValue] > 0)
        {
            is_enterPayAMount=@"1";
            break;
        }
        else if([Utility validateNumberString:PayAmount] == YES)
        {
            is_enterPayAMount=@"1";
            break;
        }
    }
    
    if([is_enterPayAMount isEqualToString:@"0"])
    {
        [WToast showWithText:@"Please pay amount at least one unit!"];
        return;
    }

    if([Utility validateBlankField:self.txtSelectDate.text])
    {
        [WToast showWithText:@"Please select date!"];
        return;
    }
    if([Utility validateBlankField:self.txtPaymentMode.text])
    {
        [WToast showWithText:@"Please select payment mode!"];
        return;
    }
    
    if(![strSelectImage isEqualToString:@"1"])
    {
        [WToast showWithText:@"Please select image!"];
        return;
    }

    if([self.strNavigateToVC isEqualToString:@"payout"])
    {
        [self apiCall_AddEditPayOut];
    }
    else
    {
        [self apiCall_AddEditReceipt];
    }
}

- (IBAction)btnHome:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClose_UnitListPopup:(id)sender {
    [self.view endEditing:YES];
    [self.viewUnitList_Popup setHidden:YES];
}

- (IBAction)btnContinue_UnitListPopup:(id)sender {
    [self.view endEditing:YES];
}
@end
