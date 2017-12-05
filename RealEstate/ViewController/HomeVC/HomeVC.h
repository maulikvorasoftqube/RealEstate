//
//  HomeVC.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

//
@property (strong, nonatomic) IBOutlet UILabel *lblCount1;
- (IBAction)btnCount1:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblCount2;
- (IBAction)btnCount2:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblCount3;
- (IBAction)btnCount3:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblCount4;
- (IBAction)btnCount4:(id)sender;

//
- (IBAction)btnUnitAvailability:(id)sender;
- (IBAction)btnReceipt:(id)sender;
- (IBAction)btnPayOut:(id)sender;
- (IBAction)btnCustomer:(id)sender;
- (IBAction)btnBooking:(id)sender;
- (IBAction)btnCollection:(id)sender;
- (IBAction)btnDocument:(id)sender;
@property (strong,nonatomic)NSString *strProperty;

@end
