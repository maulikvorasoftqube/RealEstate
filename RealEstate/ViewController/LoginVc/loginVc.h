//
//  loginVc.h
//  RealEstate
//
//  Created by MAC0008 on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginVc : UIViewController
- (IBAction)btnLoginClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtUSername;
@property (strong, nonatomic) IBOutlet UITextField *txtPAssword;

@end
