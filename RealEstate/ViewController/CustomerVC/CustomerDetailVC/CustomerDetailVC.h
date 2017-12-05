//
//  CustomerDetailVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerDetailVC : UIViewController

- (IBAction)btnBack:(id)sender;
- (IBAction)btnHome:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblTermandcondition;
@property (strong, nonatomic) IBOutlet UITableView *tblUnitDetailList;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;

@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader_TotalPaidAmount;

@end
