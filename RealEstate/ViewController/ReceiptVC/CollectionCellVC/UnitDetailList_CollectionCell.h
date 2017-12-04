//
//  UnitDetailList_CollectionCell.h
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitDetailList_CollectionCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPaidAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtEnterAmount;



@end
