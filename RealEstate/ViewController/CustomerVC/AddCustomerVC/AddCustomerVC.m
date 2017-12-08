//
//  AddCustomerVC.m
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "AddCustomerVC.h"
#import "Globle.h"

@interface AddCustomerVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSString *setImage;
    NSString *strReferenceID;
    NSMutableArray *arySearchNameListTemp,*arySearchTemp;
}
@end

@implementation AddCustomerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arySearchNameListTemp = [[NSMutableArray alloc]init];
    arySearchTemp = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_txtRefUserName];
    
    [self commonData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    self.btnIdProof.layer.borderWidth=1;
    self.btnIdProof.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnIdProof.layer.cornerRadius=4;
    self.btnIdProof.clipsToBounds=YES;
    
    self.btnsigned.layer.borderWidth=1;
    self.btnsigned.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnsigned.layer.cornerRadius=4;
    self.btnsigned.clipsToBounds=YES;
    
    self.txtTermandConditin.layer.borderWidth=1;
    self.txtTermandConditin.layer.borderColor=[UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:.4f].CGColor;
    self.txtTermandConditin.layer.cornerRadius=4;
    self.txtTermandConditin.clipsToBounds=YES;
    
    
    self.btnSave.layer.cornerRadius=4;
    self.btnSave.clipsToBounds=YES;
    
    self.tblReferenceUserNameList.layer.borderWidth=1;
    self.tblReferenceUserNameList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tblReferenceUserNameList.layer.cornerRadius=4;
    self.tblReferenceUserNameList.clipsToBounds=YES;
    
    self.tblReferenceUserNameList_Height.constant=0;
    
    self.tblReferenceUserNameList.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [Utility setRightViewOfTextField:self.txtRefUserName rightImageName:@"down_arrow"];
}

-(void)viewWillAppear:(BOOL)animated
{
    arySearchNameListTemp = [_aryCustomerList mutableCopy];
    arySearchTemp = [_aryCustomerList mutableCopy];
    
   
    if ([_strCheckAddEdit isEqualToString:@"Edit"])
    {
        NSLog(@"Dic=%@",_DicEditCustomer);
        [_btnSave setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        _txtName.text = [_DicEditCustomer objectForKey:@"FullName"];
        _txtMobileNo.text = [_DicEditCustomer objectForKey:@"MobileNo"];
       
        NSString *getTearmCondition = [NSString stringWithFormat:@"%@",[_DicEditCustomer objectForKey:@"TermsAndCondition"]];
        if ([getTearmCondition isEqualToString:@"<null>"])
        {
        }
        else
        {
            _txtTermandConditin.text = getTearmCondition;
        }
        
        NSString *getReference = [NSString stringWithFormat:@"%@",[_DicEditCustomer objectForKey:@"Reference"]];
        
        if ([getReference isEqualToString:@"<null>"])
        {
            
        }
        else
        {
            _txtRefUserName.text = [_DicEditCustomer objectForKey:@"Reference"];
            strReferenceID = [NSString stringWithFormat:@"%@",[_DicEditCustomer objectForKey:@"InvestorID"]];
        }
        
        
        UIImageView *imgDoc=[[UIImageView alloc]init];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        [indicator setCenter:self.btnIdProof.center];
        [_scrollView addSubview:indicator];
        
        UIActivityIndicatorView *indicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator1 startAnimating];
        [indicator1 setCenter:self.btnsigned.center];
       [_scrollView addSubview:indicator1];
        
        [imgDoc setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[_DicEditCustomer objectForKey:@"IDproofImage"]]]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
         {
            [self.btnIdProof setBackgroundImage:image forState:UIControlStateNormal];
             [_btnIdProof setAttributedTitle:@"" forState:UIControlStateNormal];
               [indicator removeFromSuperview];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
         {
             [_btnIdProof setAttributedTitle:@"Upload Photo" forState:UIControlStateNormal];
               [indicator removeFromSuperview];
        }];
        
        
        UIImageView *img1 = [[UIImageView alloc]init];
        [img1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[_DicEditCustomer objectForKey:@"IsSignedImage"]]]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
        {
            [self.btnsigned setBackgroundImage:image forState:UIControlStateNormal];
            [_btnsigned setAttributedTitle:@"" forState:UIControlStateNormal];
            [indicator1 removeFromSuperview];
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
        {
             [_btnsigned setAttributedTitle:@"Upload Photo" forState:UIControlStateNormal];
            [indicator1 removeFromSuperview];
        }];
        
    }
    else
    {
       [_btnSave setTitle:@"ADD" forState:UIControlStateNormal];
    }
    
}
#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == _txtRefUserName)
    {
        self.tblReferenceUserNameList_Height.constant=0;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _txtRefUserName)
    {
        self.tblReferenceUserNameList_Height.constant=0;
    }
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (_txtRefUserName.text.length == 0)
    {
        _aryCustomerList = [[NSMutableArray alloc]initWithArray:arySearchTemp];
        [_tblReferenceUserNameList reloadData];
        self.tblReferenceUserNameList_Height.constant=0;
    }
    else
    {
        NSMutableArray *ar = [[NSMutableArray alloc]initWithArray:arySearchTemp];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FullName contains[c] %@",_txtRefUserName.text];
        NSArray *result = [ar filteredArrayUsingPredicate:predicate];
        _aryCustomerList = [[NSMutableArray alloc]initWithArray:result];
        [_tblReferenceUserNameList reloadData];
        self.tblReferenceUserNameList_Height.constant=150;
    }
}
/*-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 if(textField == _txtRefUserName)
 {
 if (_txtRefUserName.text.length == 0)
 {
 _aryCustomerList = [[NSMutableArray alloc]initWithArray:arySearchTemp];
 [_tblReferenceUserNameList reloadData];
 self.tblReferenceUserNameList_Height.constant=0;
 }
 else
 {
 NSString *searchString = [_txtRefUserName.text stringByReplacingCharactersInRange:range withString:string];
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.FullName CONTAINS[c] %@", searchString];
 NSArray *filteredArray = [arySearchNameListTemp filteredArrayUsingPredicate:predicate];
 _aryCustomerList=[filteredArray mutableCopy];
 [_tblReferenceUserNameList reloadData];
 self.tblReferenceUserNameList_Height.constant=150;
 
 
 }
 }
 
 return YES;
 }*/


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryCustomerList.count;
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
    
    cell.textLabel.text = [[_aryCustomerList objectAtIndex:indexPath.row]objectForKey:@"FullName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    strReferenceID = [NSString stringWithFormat:@"%@",[[_aryCustomerList objectAtIndex:indexPath.row]objectForKey:@"InvestorID"]];
    _txtRefUserName.text = [NSString stringWithFormat:@"%@",[[_aryCustomerList objectAtIndex:indexPath.row]objectForKey:@"FullName"]];
    _tblReferenceUserNameList.hidden = YES;
}

#pragma mark - UIImagePicker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    
    if ([setImage isEqualToString:@"IdProof"])
    {
        [_btnIdProof setBackgroundImage:selectImage forState:UIControlStateNormal];
        [_btnIdProof setAttributedTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [_btnsigned setBackgroundImage:selectImage forState:UIControlStateNormal];
        [_btnsigned setAttributedTitle:@"" forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([setImage isEqualToString:@"IdProof"])
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - UIButton Action

- (IBAction)btnIdProof:(id)sender
{
    [self.view endEditing:YES];
    
    setImage = @"IdProof";
    
    /*
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     [self presentViewController:picker animated:YES completion:nil];
     // For picking image from gallery
     
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     [self presentViewController:picker animated:YES completion:nil];
     */
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attach image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* pickFromGallery = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                      {
                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                          {
                                              /*  UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                               picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                               picker.delegate = (id)self;
                                               [self presentViewController:picker animated:YES completion:NULL];*/
                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                              picker.delegate = self;
                                              picker.allowsEditing = YES;
                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                              [self presentViewController:picker animated:YES completion:nil];
                                              
                                          }
                                          
                                      }];
    
    UIAlertAction* takeAPicture = [UIAlertAction actionWithTitle:@"Choose from Liabrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       /* UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;picker.delegate = (id)self;
                                        [self presentViewController:picker animated:YES completion:NULL];*/
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       picker.delegate = self;
                                       picker.allowsEditing = YES;
                                       picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                       [self presentViewController:picker animated:YES completion:nil];
                                       
                                   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                             {
                             }];
    
    [alertController addAction:pickFromGallery];
    [alertController addAction:takeAPicture];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btnsigned:(id)sender
{
    [self.view endEditing:YES];
    
    setImage = @"Signed";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attach image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* pickFromGallery = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                      {
                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                          {
                                              UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                              picker.delegate = (id)self;
                                              [self presentViewController:picker animated:YES completion:NULL];
                                              
                                          }
                                          
                                      }];
    UIAlertAction* takeAPicture = [UIAlertAction actionWithTitle:@"Choose from Liabrary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                       picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                       picker.delegate = (id)self;
                                       [self presentViewController:picker animated:YES completion:NULL];
                                       
                                   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * action)
                             {
                             }];
    
    [alertController addAction:pickFromGallery];
    [alertController addAction:takeAPicture];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btnSave:(id)sender
{
    // validation
    //call api
    
    if ([_strCheckAddEdit isEqualToString:@"Edit"])
    {
        [self.view endEditing:YES];
        
        if ([Utility isInterNetConnectionIsActive] == false)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        
        if ([Utility validateBlankField:_txtName.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NAME delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        if ([Utility validateBlankField:_txtMobileNo.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:MOBILENUMBER delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        if ([Utility validateBlankField:_txtRefUserName.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTREF delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"FullName contains[c] %@",
                                        _txtRefUserName.text];
        
        
        NSArray *searchResults = [arySearchTemp  filteredArrayUsingPredicate:resultPredicate];
        
        if (searchResults.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTREFVALID delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        else
        {
        }
        UIImage *org1 = _btnIdProof.currentBackgroundImage;
        UIImage *imgCompressed1 = [self compressImage:org1];
        
        //  NSData *data = UIImagePNGRepresentation(_btnIdProof.currentBackgroundImage);
        NSData *data1 = UIImagePNGRepresentation(imgCompressed1);
        const unsigned char *bytes1 = [data1 bytes];
        NSUInteger length1 = [data1 length];
        NSMutableArray *byteArray11 = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < length1; i++)
        {
            [byteArray11 addObject:[NSNumber numberWithUnsignedChar:bytes1[i]]];
        }
        
        if (byteArray11.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:IDPROOF delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        else
        {
        }
        
        UIImage *org = _btnsigned.currentBackgroundImage;
        UIImage *imgCompressed = [self compressImage:org];
        
        NSData *data = UIImagePNGRepresentation(imgCompressed);
        const unsigned char *bytes = [data bytes];
        NSUInteger length = [data length];
        NSMutableArray *byteArray =  [NSMutableArray array];
        
        for (NSUInteger i = 0; i < length; i++)
        {
            [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
        }
        
        if (byteArray.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SIGNATUREPIC delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        
        [self AddEditCustomer];
    }
    else
    {
        [self.view endEditing:YES];
        
        if ([Utility isInterNetConnectionIsActive] == false)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        
        if ([Utility validateBlankField:_txtName.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NAME delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        if ([Utility validateBlankField:_txtMobileNo.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:MOBILENUMBER delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        if ([Utility validateBlankField:_txtRefUserName.text])
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTREF delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"FullName contains[c] %@",
                                        _txtRefUserName.text];
        
        
        NSArray *searchResults = [arySearchTemp  filteredArrayUsingPredicate:resultPredicate];
        
        if (searchResults.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SELECTREFVALID delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        else
        {
        }
        UIImage *org1 = _btnIdProof.currentBackgroundImage;
        UIImage *imgCompressed1 = [self compressImage:org1];
        
        //  NSData *data = UIImagePNGRepresentation(_btnIdProof.currentBackgroundImage);
        NSData *data1 = UIImagePNGRepresentation(imgCompressed1);
        const unsigned char *bytes1 = [data1 bytes];
        NSUInteger length1 = [data1 length];
        NSMutableArray *byteArray11 = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < length1; i++)
        {
            [byteArray11 addObject:[NSNumber numberWithUnsignedChar:bytes1[i]]];
        }
        
        if (byteArray11.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:IDPROOF delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        else
        {
        }
        
        UIImage *org = _btnsigned.currentBackgroundImage;
        UIImage *imgCompressed = [self compressImage:org];
        
        NSData *data = UIImagePNGRepresentation(imgCompressed);
        const unsigned char *bytes = [data bytes];
        NSUInteger length = [data length];
        NSMutableArray *byteArray =  [NSMutableArray array];
        
        for (NSUInteger i = 0; i < length; i++)
        {
            [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
        }
        
        if (byteArray.count == 0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:SIGNATUREPIC delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            return;
        }
        [self AddEditCustomer];
    }
    
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - API add customer

-(void)AddEditCustomer
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,AddEditInvestor];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([_strCheckAddEdit isEqualToString:@"Edit"])
    {
        [dic setObject:[_DicEditCustomer objectForKey:@"InvestorID"] forKey:@"InvestorID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"InvestorID"];
    }
     //  NSData *data = UIImagePNGRepresentation(_btnIdProof.currentBackgroundImage);
    UIImage *org1 = _btnIdProof.currentBackgroundImage;
    UIImage *imgCompressed1 = [self compressImage:org1];
    NSData *data1 = UIImagePNGRepresentation(imgCompressed1);
    const unsigned char *bytes1 = [data1 bytes];
    NSUInteger length1 = [data1 length];
    NSMutableArray *byteArray11 = [NSMutableArray array];
    for (NSUInteger i = 0; i < length1; i++)
    {
        [byteArray11 addObject:[NSNumber numberWithUnsignedChar:bytes1[i]]];
    }
    [dic setValue:[NSString stringWithFormat:@"%@.png",[Utility randomImageGenerator]] forKey:@"IDProofFileName"];
    [dic setValue:byteArray11 forKey:@"IDProof"];
    
    
    UIImage *org = _btnsigned.currentBackgroundImage;
    UIImage *imgCompressed = [self compressImage:org];
    NSData *data = UIImagePNGRepresentation(imgCompressed);
    const unsigned char *bytes = [data bytes];
    NSUInteger length = [data length];
    NSMutableArray *byteArray =  [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++)
    {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    [dic setValue:[NSString stringWithFormat:@"%@.png",[Utility randomImageGenerator]] forKey:@"BCardFileName"];
    [dic setValue:byteArray forKey:@"BCardFile"];
    [dic setObject:_txtName.text forKey:@"Name"];
    [dic setObject:_txtMobileNo.text forKey:@"MobileNo"];
    [dic setObject:strReferenceID forKey:@"RefID"];
    [dic setObject:_txtRefUserName.text forKey:@"RefName"];
    [dic setObject:_txtTermandConditin.text forKey:@"TermConditions"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyID"] forKey:@"CompanyID"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"UsearID"] forKey:@"UserID"];
    
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

#pragma mark - Image Compress

-(UIImage *)compressImage:(UIImage *)image
{
    
    NSData *imgData = UIImagePNGRepresentation(image); //1 it represents the quality of the image.
    // NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    //   NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}


@end
