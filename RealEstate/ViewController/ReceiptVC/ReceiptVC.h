//
//  ReceiptVC.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"

@interface ReceiptVC : UIViewController <NIDropDownDelegate>
{
    NIDropDown *dropDown;
}

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) ActionSheetDatePicker *actionSheetPicker;
@property (nonatomic, strong) NSString *strNavigateToVC;
@property (strong, nonatomic) IBOutlet UILabel *lblHeaderTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtbtnProperty;
@property (strong, nonatomic) IBOutlet UIButton *btnProperty;
- (IBAction)btnProperty:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtbtnSelectUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnUnit;
- (IBAction)btnUnit:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (strong, nonatomic) IBOutlet UICollectionView *collection_UnitDeailList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewUnitDetailList_Height;//232

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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblSelectUnitList_Height;//150
@property (strong, nonatomic) IBOutlet UITableView *tblSelectUnit;


//unitlist popup
@property (strong, nonatomic) IBOutlet UIView *viewUnitList_Popup;
@property (strong, nonatomic) IBOutlet UIView *viewInnerUnitList_Popup;
@property (strong, nonatomic) IBOutlet UIButton *btnClose_UnitListPopup;
- (IBAction)btnClose_UnitListPopup:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtSearchUnitList;
@property (strong, nonatomic) IBOutlet UICollectionView *collection_UnitListPopup;

@property (strong, nonatomic) IBOutlet UIButton *btnContinue_UnitListPopup;
- (IBAction)btnContinue_UnitListPopup:(id)sender;


@end
