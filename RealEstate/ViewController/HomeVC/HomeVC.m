//
//  HomeVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "HomeVC.h"
#import "Globle.h"

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
-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Count Action

- (IBAction)btnCount1:(id)sender {
}
- (IBAction)btnCount2:(id)sender {
}
- (IBAction)btnCount3:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnCount4:(id)sender {
}

#pragma mark - Action

- (IBAction)btnUnitAvailability:(id)sender
{
    UnitAvailabilityListVC *unit = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitAvailabilityListVC"];
    unit.strPropertyID = _strProperty;
    [self.navigationController pushViewController:unit animated:YES];
}

- (IBAction)btnReceipt:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPayOut:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCustomer:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnBooking:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddBookingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCollection:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnDocument:(id)sender {
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"DocumentListVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
