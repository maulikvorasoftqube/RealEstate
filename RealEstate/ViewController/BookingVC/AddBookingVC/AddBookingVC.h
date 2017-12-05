//
//  AddBookingVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookingVC : UIViewController
- (IBAction)btnBack:(id)sender;
- (IBAction)btnHome:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectProperty;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectProperty;
- (IBAction)btnSelectProperty:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectBlock;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectBlock;
- (IBAction)btnSelectBlock:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectUnit;
- (IBAction)btnSelectUnit:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectdateofbooking;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectdateofbooking;
- (IBAction)btnSelectdateofbooking:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectCustomerName;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSave:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnAddNewCustomer;
- (IBAction)btnAddNewCustomer:(id)sender;

//tbl customername list

@property (strong, nonatomic) IBOutlet UITableView *tblCustomerNameList;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblCustomerNameList_Height;



//tbl Unit Price list

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewUnitPriceList_Height;
@property (strong, nonatomic) IBOutlet UITableView *tblUnitPriceList;


@end
