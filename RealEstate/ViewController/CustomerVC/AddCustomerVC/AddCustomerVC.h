//
//  AddCustomerVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomerVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnSetImg;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (strong, nonatomic) IBOutlet UITextField *txtRefUserName;
@property (strong, nonatomic) IBOutlet UITextView *txtTermandConditin;

@property (strong, nonatomic) IBOutlet UIButton *btnIdProof;
- (IBAction)btnIdProof:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnsigned;
- (IBAction)btnsigned:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSave:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;

- (IBAction)btnHome:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *tblReferenceUserNameList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblReferenceUserNameList_Height;

@property (strong,nonatomic)NSMutableDictionary *DicEditCustomer;
@property(strong,nonatomic)NSString *strCheckAddEdit;
@property(strong,nonatomic)NSMutableArray *aryCustomerList;
@end
