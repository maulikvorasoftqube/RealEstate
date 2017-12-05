//
//  DocumentListVC.h
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>


//Header
- (IBAction)btnBack:(id)sender;
- (IBAction)btnFilter:(id)sender;
- (IBAction)btnHome:(id)sender;

//Boday
@property (strong, nonatomic) IBOutlet UITableView *tblDocumentList;

@property (strong, nonatomic) IBOutlet UIButton *btnAddNewDocument;
- (IBAction)btnAddNewDocument:(id)sender;


//Filter popup
@property (strong, nonatomic) IBOutlet UIView *viewFilter;
@property (strong, nonatomic) IBOutlet UIView *viewInnerFilter;
- (IBAction)btnClose_filterPopup:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtSelectDocument_Filter;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDocument_Filter;
- (IBAction)btnSelectDocument_Filter:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomerName_Filter;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCustomerName_Filter;
- (IBAction)btnSelectCustomerName_Filter:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)btnReset:(id)sender;


@end
