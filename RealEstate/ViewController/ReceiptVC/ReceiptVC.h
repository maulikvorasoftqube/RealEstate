//
//  ReceiptVC.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtbtnProperty;
@property (strong, nonatomic) IBOutlet UIButton *btnProperty;
- (IBAction)btnProperty:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtbtnSelectUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnUnit;
- (IBAction)btnUnit:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (strong, nonatomic) IBOutlet UICollectionView *collection_UnitDeailList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewUnitDetailList_Height;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectDate;
- (IBAction)btnSelectDate:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;

@property (strong, nonatomic) IBOutlet UITextField *txtPaymentMode;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentMode;
- (IBAction)btnPaymentMode:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnTakePic;
- (IBAction)btnTakePic:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSave:(id)sender;



- (IBAction)btnHome:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
