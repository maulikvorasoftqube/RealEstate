//
//  UploadDocumentVC.h
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"

@interface UploadDocumentVC : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}

@property (strong, nonatomic) NSMutableArray *arrDocType;
@property (strong, nonatomic) NSMutableArray *arrCusType;


- (IBAction)btnBack:(id)sender;
- (IBAction)btnHome:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectDocumentType;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDocumentType;
- (IBAction)btnSelectDocumentType:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectCustomerName;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCustomerName;
- (IBAction)btnSelectCustomerName:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnUploadImage;
- (IBAction)btnUploadImage:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnUploadDocument;
- (IBAction)btnUploadDocument:(id)sender;

@end
