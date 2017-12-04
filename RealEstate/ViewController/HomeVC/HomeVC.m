//
//  HomeVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Count Action

- (IBAction)btnCount1:(id)sender {
}
- (IBAction)btnCount2:(id)sender {
}
- (IBAction)btnCount3:(id)sender {
}
- (IBAction)btnCount4:(id)sender {
}

#pragma mark - Action

- (IBAction)btnUnitAvailability:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"UnitAvailabilityListVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnReceipt:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPayOut:(id)sender {
}

- (IBAction)btnCustomer:(id)sender {
}

- (IBAction)btnBooking:(id)sender {
}

- (IBAction)btnCollection:(id)sender {
}

- (IBAction)btnDocument:(id)sender {
}

@end
