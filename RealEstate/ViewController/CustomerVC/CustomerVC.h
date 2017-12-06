//
//  CustomerVC.h
//  RealEstate
//
//  Created by harikrishna patel on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


- (IBAction)btnBack:(id)sender;
- (IBAction)btnHome:(id)sender;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tblCustomerList;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong,nonatomic)NSString *strCompnyID;
@property (strong,nonatomic)NSString *strUserID;
- (IBAction)btnAddNewCustomer:(id)sender;

@end
