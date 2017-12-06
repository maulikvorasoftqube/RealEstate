//
//  UploadDocumentVC.m
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "UploadDocumentVC.h"
#import "Globle.h"

@interface UploadDocumentVC ()
{
    NSMutableArray *arrDocumentType;
    NSMutableArray *arrCustomerName;
    
    NSString *strSelectDocumentId,*strSelectCustomerId,*strSelectImage;
}
@end

@implementation UploadDocumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    self.btnUploadImage.layer.borderWidth=1;
    self.btnUploadImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnUploadImage.layer.cornerRadius=4;
    self.btnUploadImage.clipsToBounds=YES;

    self.btnUploadDocument.layer.cornerRadius=4;
    self.btnUploadDocument.clipsToBounds=YES;

    [Utility setRightViewOfTextField:self.txtSelectDocumentType rightImageName:@"down_arrow"];
    
    [Utility setRightViewOfTextField:self.txtSelectCustomerName rightImageName:@"down_arrow"];
    
    
    arrDocumentType=[self.arrDocType mutableCopy];
    arrCustomerName=[self.arrCusType mutableCopy];
    
    if(self.dicSelectedDoc != nil)
    {
        [self.btnSelectCustomerName setUserInteractionEnabled:NO];
        [self.btnUploadImage setAttributedTitle:nil forState:UIControlStateNormal];
        
        strSelectCustomerId=[self.dicSelectedDoc objectForKey:@"InvestorID"];
        strSelectDocumentId=[self.dicSelectedDoc objectForKey:@"DocumentTypeID"];
        
        self.txtSelectCustomerName.text=[self.dicSelectedDoc objectForKey:@"FullName"];
        self.txtSelectDocumentType.text=[self.dicSelectedDoc objectForKey:@"DocumentType"];
        
        NSString *DocumentName=[self.dicSelectedDoc objectForKey:@"DocumentName"];
        UIImageView *imgDoc=[[UIImageView alloc]init];
        [imgDoc setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,DocumentName]]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [self.btnUploadImage setBackgroundImage:image forState:UIControlStateNormal];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        }];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Api call for

-(void)apiCall_AddEditDocument
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *CompanyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyID"];
    NSString *PropertyID=[[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyID"];
    NSString *UserID=[[NSUserDefaults standardUserDefaults]objectForKey:@"UsearID"];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",BASE_URL,AddEditDocument];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(self.dicSelectedDoc != nil)
    {
        [dic setObject:[self.dicSelectedDoc objectForKey:@"DocumentID"] forKey:@"DocumentID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"DocumentID"];
    }
    [dic setObject:strSelectCustomerId forKey:@"InvestorID"];
    [dic setObject:strSelectDocumentId forKey:@"TermID"];
    [dic setObject:self.txtSelectDocumentType.text forKey:@"Term"];
    [dic setObject:PropertyID forKey:@"PropertyID"];
    [dic setObject:CompanyID forKey:@"CompanyID"];
    [dic setObject:UserID forKey:@"UserID"];
    
    NSData *data = UIImagePNGRepresentation(_btnUploadImage.currentBackgroundImage);
    const unsigned char *bytes = [data bytes];
    NSUInteger length = [data length];
    NSMutableArray *byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++)
    {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    
    [dic setValue:byteArray forKey:@"DocumentFile"];
    [dic setValue:[NSString stringWithFormat:@"%@.png",[Utility randomImageGenerator]] forKey:@"DocumentName"];
    
    
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
        self.txtSelectDocumentType.text=strTitle;
        strSelectDocumentId=[[arrDocumentType objectAtIndex:rowIndex]objectForKey:@"TermID"];
        
    }
    else
    {
        self.txtSelectCustomerName.text=strTitle;
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

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnSelectDocumentType:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    NSArray * arrimg = [[NSArray alloc] init];
    arr=[[arrDocumentType valueForKey:@"Term"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrimg :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

- (IBAction)btnSelectCustomerName:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr=[[arrCustomerName valueForKey:@"FullName"]mutableCopy];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

- (IBAction)btnUploadImage:(id)sender {
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

- (IBAction)btnUploadDocument:(id)sender {
    if(strSelectDocumentId.length == 0)
    {
        [WToast showWithText:@"Please select document type"];
        return;
    }
    
    if(strSelectCustomerId.length == 0)
    {
        [WToast showWithText:@"Please select customer"];
        return;
    }
    
    if([strSelectImage isEqualToString:@"0"])
    {
        [WToast showWithText:@"Please select document image"];
        return;
    }
    
    [self apiCall_AddEditDocument];
    
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
   
    [self.btnUploadImage setBackgroundImage:selectImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    [self.btnUploadImage setAttributedTitle:nil forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    strSelectImage=@"0";
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
