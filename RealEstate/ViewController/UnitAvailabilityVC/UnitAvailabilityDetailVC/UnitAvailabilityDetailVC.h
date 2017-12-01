//
//  UnitAvailabilityDetailVC.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitAvailabilityDetailVC : UIViewController

- (IBAction)btnBack:(id)sender;
- (IBAction)btnHome:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collection_list;

@property (strong, nonatomic) IBOutlet UIView *viewDetail_popup;
- (IBAction)btnCloseDetail_Popup:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblName_Detail_popup;
@property (strong, nonatomic) IBOutlet UILabel *lblMobilenumber_Detail_popup;

@end
