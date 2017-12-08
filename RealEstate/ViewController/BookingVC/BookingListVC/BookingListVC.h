//
//  BookingListVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"
#import <ActionSheetPicker.h>

@interface BookingListVC : UIViewController

@property (nonatomic, strong) NSDate *selected_FromDate;
@property (nonatomic, strong) NSDate *selected_ToDate;

@property (nonatomic, strong) ActionSheetDatePicker *actionSheetPicker;

@property (nonatomic, strong) NSString *strNavigateToVC;

//Header
- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFilter;
- (IBAction)btnFilter:(id)sender;
- (IBAction)btnHome:(id)sender;


//Body
@property (strong, nonatomic) IBOutlet UITableView *tblBookingList;


//Popup
@property (strong, nonatomic) IBOutlet UIView *viewFilter_Popup;
@property (strong, nonatomic) IBOutlet UIView *viewInner_filterPopup;

@property (strong, nonatomic) IBOutlet UIButton *btnClose_FilterPopup;
- (IBAction)btnClose_FilterPopup:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectFromDate;
- (IBAction)btnSelectFromDate:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectToDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectTodate;
- (IBAction)btnSelectToDate:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)btnReset:(id)sender;

@end
