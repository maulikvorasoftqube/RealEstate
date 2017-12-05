//
//  loginVc.m
//  RealEstate
//
//  Created by MAC0008 on 04/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "loginVc.h"
#import "Globle.h"
@interface loginVc ()

@end

@implementation loginVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action

- (IBAction)btnLoginClicked:(id)sender
{
    [self LoginAPI];
}

#pragma mark - api call

-(void)LoginAPI
{
    if ([Utility isInterNetConnectionIsActive] == false)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",BASE_URL,LOGIN];
    
    [FTIndicator showProgressWithMessage:nil userInteractionEnable:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //[dic setObject:_txtUSername.text forKey:@"UserName"];
   // [dic setObject:_txtPAssword.text forKey:@"Password"];
    
    [dic setObject:@"ash" forKey:@"UserName"];
    [dic setObject:@"123" forKey:@"Password"];
  
    [Utility PostApiCall:strURL params:dic block:^(NSMutableDictionary *dicResponce, NSError *error)
     {
         [FTIndicator dismissProgress];
         
         if (!error)
         {
             NSString *strJSON  = [dicResponce objectForKey:@"d"];
             NSMutableDictionary *Dic = [Utility ConvertStringtoJSON:strJSON];
             NSMutableArray *ary = [Dic mutableCopy];
             
             HomeVC *homVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
             homVc.strProperty =[[ary objectAtIndex:0]objectForKey:@"PropertyID"];
             [self.navigationController pushViewController:homVc animated:YES];
         }
         else
         {
             UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:NODATA delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alrt show];
             return;
         }
         
     }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
