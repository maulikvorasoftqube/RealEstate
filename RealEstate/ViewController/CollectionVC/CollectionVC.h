//
//  CollectionVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewtblHeader;

//Header
- (IBAction)btnBack:(id)sender;
- (IBAction)btnFilter:(id)sender;
- (IBAction)btnHome:(id)sender;



// Boday
@property (strong, nonatomic) IBOutlet UITableView *tblCollectionList;



//Filter Popup
@property (strong, nonatomic) IBOutlet UIView *viewFilterPopup;
@property (strong, nonatomic) IBOutlet UIView *viewInnerPopup;
- (IBAction)btnClose_filter:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectBlock;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectBlock;
- (IBAction)btnSelectBlock:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectFromDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectfromdate;
- (IBAction)btnSelectfromdate:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtselecttodate;
@property (strong, nonatomic) IBOutlet UIButton *btnselecttodate;
- (IBAction)btnselecttodate:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtEnterdue;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterPaidAmount;

- (IBAction)btnSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnReset:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;


@end
