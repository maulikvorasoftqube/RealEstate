//
//  DocumentListVC.m
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "DocumentListVC.h"
#import "Globle.h"
#import "UploadDocumentVC.h"
@interface DocumentListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrDocumentList,*arrDocumentList_Main;
    
    NSMutableArray *arrDocumentType;
    NSMutableArray *arrCustomerName;
    
    NSString *strSelectDocumentId,*strSelectCustomerId;
}
@end

@implementation DocumentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonData
{
    [self.viewFilter setHidden:YES];
    self.tblDocumentList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.btnAddNewDocument.layer.cornerRadius=20;
    self.btnAddNewDocument.clipsToBounds=YES;
    
    self.viewInnerFilter.layer.cornerRadius=4;
    self.viewInnerFilter.clipsToBounds=YES;
    
    self.btnSearch.layer.cornerRadius=4;
    self.btnSearch.clipsToBounds=YES;
    
    self.btnReset.layer.cornerRadius=4;
    self.btnReset.clipsToBounds=YES;
    
    [self.tblDocumentList reloadData];
    
    [Utility setRightViewOfTextField:self.txtCustomerName_Filter rightImageName:@"down_arrow"];
    [Utility setRightViewOfTextField:self.txtSelectDocument_Filter rightImageName:@"down_arrow"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    strSelectDocumentId=@"";
    strSelectCustomerId=@"";
    self.txtSelectDocument_Filter.text=@"";
    self.txtCustomerName_Filter.text=@"";
    
    [self apiCall_GetAllDocuments];
}

#pragma mark - Api call for

-(void)apiCall_GetAllDocuments
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,GetAllDocuments];
    
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
             
             NSMutableArray *arrData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
             
             [self processJSONData:arrData];
             if(arrData.count != 0)
             {
                 [self apiCall_OtherOptions];
             }
             //             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
             //                                                 sortDescriptorWithKey:@"WingName"
             //                                                 ascending:YES];
             //             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
             //             NSArray *sortedEventArray = [aryGetList
             //                                          sortedArrayUsingDescriptors:sortDescriptors];
             //             arrDocumentList = [sortedEventArray mutableCopy];
             
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
         
     }];
    
}

- (void)processJSONData:(NSMutableArray *)inputArray {
    
    
    NSArray *arrInvestorIDTemp = [inputArray valueForKeyPath:@"@distinctUnionOfObjects.InvestorID"];
    NSMutableArray *arrInvestorID=[[NSMutableArray alloc]init];
    for (NSString *strValue in arrInvestorIDTemp)
    {
        if([strValue isEqual:@"<NSNull>"] || [strValue isEqual:@"<null>"] || [strValue isKindOfClass:[NSNull class]])
        {
            //nothing
        }
        else
        {
            [arrInvestorID addObject:strValue];
        }
    }
    
    arrDocumentList = [[NSMutableArray alloc]init];
    arrDocumentList_Main = [[NSMutableArray alloc]init];
    for (NSString *strInvestorID in arrInvestorID)
    {
        NSMutableArray *arrRow=[[NSMutableArray alloc]init];
        NSString *FullName;
        for (NSMutableDictionary *dict in inputArray)
        {
            
            NSString *strInnerInvestorID=[dict objectForKey:@"InvestorID"];
            if([strInvestorID isEqualToString:strInnerInvestorID])
            {
                FullName=[dict objectForKey:@"FullName"];
                [arrRow addObject:dict];
            }
        }
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"DateOfSubmission"
                                            ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        NSArray *sortedEventArray = [arrRow
                                     sortedArrayUsingDescriptors:sortDescriptors];
        arrRow = [sortedEventArray mutableCopy];
        
        NSMutableDictionary *dicSectionRow=[[NSMutableDictionary alloc]init];
        [dicSectionRow setObject:strInvestorID forKey:@"InvestorID"];
        [dicSectionRow setObject:FullName forKey:@"FullName"];
        [dicSectionRow setObject:arrRow forKey:@"arrRow"];
        
        [arrDocumentList addObject:dicSectionRow];
        [arrDocumentList_Main addObject:dicSectionRow];
    }
    
    [self.tblDocumentList reloadData];
}

-(void)apiCall_OtherOptions
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,OtherOptions];
    
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
             
             arrCustomerName=[[NSMutableArray alloc]init];
             arrDocumentType=[[NSMutableArray alloc]init];
             
             arrCustomerName=[dicData objectForKey:@"Table1"];
             arrDocumentType=[dicData objectForKey:@"Table"];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
     }];
}

#pragma mark - UITableView Section Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrDocumentList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_section"];
    
    UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:1];
    if([[[arrDocumentList objectAtIndex:section]objectForKey:@"FullName"] isEqual:@"<NSNull>"] || [[[arrDocumentList objectAtIndex:section]objectForKey:@"FullName"] isEqual:@"<null>"] || [[[arrDocumentList objectAtIndex:section]objectForKey:@"FullName"] isKindOfClass:[NSNull class]])
    {
        //nothing
    }
    else
    {
        lbl.text= [[arrDocumentList objectAtIndex:section]objectForKey:@"FullName"];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[arrDocumentList objectAtIndex:section]objectForKey:@"arrRow"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell_row"];
    
    UIView *view=(UIView*)[cell.contentView viewWithTag:1];
    view.layer.cornerRadius=4;
    view.clipsToBounds=YES;
    
    NSString *DateOfSubmission= [[[[arrDocumentList objectAtIndex:indexPath.section]objectForKey:@"arrRow"] objectAtIndex:indexPath.row]objectForKey:@"DateOfSubmission"];
    
    NSString *finaldate=[Utility convertMiliSecondtoDate:@"dd-MM-yyyy" date:DateOfSubmission];
    
    UILabel *lbl=(UILabel*)[cell.contentView viewWithTag:3];
    lbl.text=finaldate;
    
    //===
    NSString *DocumentName= [[[[arrDocumentList objectAtIndex:indexPath.section]objectForKey:@"arrRow"] objectAtIndex:indexPath.row]objectForKey:@"DocumentName"];
    
    UIImageView *imgDoc=(UIImageView*)[cell.contentView viewWithTag:2];
    [imgDoc setImage:nil];
    [imgDoc setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,DocumentName]]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - NIDropDown Delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender title:(NSString *)strTitle tag:(long)btntag rowIndex:(long)rowIndex
{
    
    if(btntag == 1)
    {
        self.txtSelectDocument_Filter.text=strTitle;
        strSelectDocumentId=[[arrDocumentType objectAtIndex:rowIndex]objectForKey:@"TermID"];
    }
    else
    {
        self.txtCustomerName_Filter.text=strTitle;
        strSelectCustomerId=[[arrCustomerName objectAtIndex:rowIndex]objectForKey:@"InvestorID"];
    }
    [self rel];
}

-(void)rel{
    dropDown = nil;
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFilter:(id)sender {
    [self.viewFilter setHidden:NO];
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnAddNewDocument:(id)sender {
    UploadDocumentVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UploadDocumentVC"];
    vc.arrDocType=[arrDocumentType mutableCopy];
    vc.arrCusType=[arrCustomerName mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnClose_filterPopup:(id)sender {
    [self.viewFilter setHidden:YES];
}

- (IBAction)btnSelectDocument_Filter:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    arr=[[arrDocumentType valueForKey:@"Term"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 110;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}

- (IBAction)btnSelectCustomerName_Filter:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr=[[arrCustomerName valueForKey:@"FullName"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 110;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"up"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}

- (IBAction)btnSearch:(id)sender
{
    if(strSelectDocumentId.length != 0 && strSelectCustomerId.length != 0)
    {
        arrDocumentList=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrDocumentList_Main count]; i++)
        {
            NSMutableDictionary *dicSection=[[arrDocumentList_Main objectAtIndex:i]mutableCopy];
            NSString *InvestorID=[dicSection objectForKey:@"InvestorID"];
            if([InvestorID isEqualToString:strSelectCustomerId])
            {
                NSMutableArray *arrRow=[[dicSection objectForKey:@"arrRow"]mutableCopy];
                NSMutableArray *arrRowNew=[[NSMutableArray alloc]init];
                for (NSMutableDictionary *dicRow in arrRow)
                {
                    NSString *DocumentTypeID=[dicRow objectForKey:@"DocumentTypeID"];
                    if ([DocumentTypeID isEqualToString:strSelectDocumentId])
                    {
                        [arrRowNew addObject:dicRow];
                    }
                }
                
                NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"DateOfSubmission"
                                                    ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                NSArray *sortedEventArray = [arrRowNew
                                             sortedArrayUsingDescriptors:sortDescriptors];
                arrRowNew = [sortedEventArray mutableCopy];
                
                [dicSection setObject:arrRowNew forKey:@"arrRow"];
                if(arrRowNew.count != 0)
                {
                    [arrDocumentList addObject:dicSection];
                }
            }
        }
    }
    else if(strSelectDocumentId.length != 0)
    {
        arrDocumentList=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrDocumentList_Main count]; i++)
        {
            NSMutableDictionary *dicSection=[[arrDocumentList_Main objectAtIndex:i]mutableCopy];
            
            NSMutableArray *arrRow=[[dicSection objectForKey:@"arrRow"]mutableCopy];
            NSMutableArray *arrRowNew=[[NSMutableArray alloc]init];
            for (NSMutableDictionary *dicRow in arrRow)
            {
                NSString *DocumentTypeID=[dicRow objectForKey:@"DocumentTypeID"];
                if ([DocumentTypeID isEqualToString:strSelectDocumentId])
                {
                    [arrRowNew addObject:dicRow];
                }
            }
            
            NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"DateOfSubmission"
                                                ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
            NSArray *sortedEventArray = [arrRowNew
                                         sortedArrayUsingDescriptors:sortDescriptors];
            arrRowNew = [sortedEventArray mutableCopy];
            
            [dicSection setObject:arrRowNew forKey:@"arrRow"];
            if(arrRowNew.count != 0)
            {
                [arrDocumentList addObject:dicSection];
            }
        }
    }
    else if(strSelectCustomerId.length != 0)
    {
        arrDocumentList=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrDocumentList_Main count]; i++)
        {
            NSMutableDictionary *dicSection=[[arrDocumentList_Main objectAtIndex:i]mutableCopy];
            NSString *InvestorID=[dicSection objectForKey:@"InvestorID"];
            if([InvestorID isEqualToString:strSelectCustomerId])
            {
                [arrDocumentList addObject:dicSection];
            }
        }
    }
    
    [self.tblDocumentList reloadData];
    [self.viewFilter setHidden:YES];
}

- (IBAction)btnReset:(id)sender
{
    arrDocumentList=[[NSMutableArray alloc]init];
    arrDocumentList=[arrDocumentList_Main mutableCopy];
    strSelectDocumentId=@"";
    strSelectCustomerId=@"";
    self.txtSelectDocument_Filter.text=@"";
    self.txtCustomerName_Filter.text=@"";
    
    [self.tblDocumentList reloadData];
    [self.viewFilter setHidden:YES];
}

@end
