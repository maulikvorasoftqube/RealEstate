//
//  UnitAvailabilityListVC.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitAvailabilityListVC : UIViewController

//
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;

- (IBAction)btnHome:(id)sender;

//
@property (strong, nonatomic) IBOutlet UITableView *tblUnitList;
@property (strong,nonatomic)NSString *strPropertyID;

@end
