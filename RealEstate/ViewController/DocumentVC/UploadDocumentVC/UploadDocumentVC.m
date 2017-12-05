//
//  UploadDocumentVC.m
//  RealEstate
//
//  Created by harikrishna patel on 05/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "UploadDocumentVC.h"
#import "Globle.h"

@interface UploadDocumentVC ()

@end

@implementation UploadDocumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)commonData
{
    self.btnUploadImage.layer.borderWidth=1;
    self.btnUploadImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.btnUploadImage.layer.cornerRadius=4;
    self.btnUploadImage.clipsToBounds=YES;

    self.btnUploadDocument.layer.cornerRadius=4;
    self.btnUploadDocument.clipsToBounds=YES;

    [Utility setRightViewOfTextField:self.txtSelectDocumentType rightImageName:@"down_arrow"];
    
    [Utility setRightViewOfTextField:self.txtSelectCustomerName rightImageName:@"down_arrow"];
}

#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender {
}

- (IBAction)btnSelectDocumentType:(id)sender {
}

- (IBAction)btnSelectCustomerName:(id)sender {
}

- (IBAction)btnUploadImage:(id)sender {
}

- (IBAction)btnUploadDocument:(id)sender {
}
@end
