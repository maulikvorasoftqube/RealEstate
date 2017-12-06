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
    HomeVC *homVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self.navigationController pushViewController:homVc animated:YES];
  //  [self LoginAPI];
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
         
             [self setLoginData_LOCALDB:[ary objectAtIndex:0]];
             HomeVC *homVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    
             NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[[ary objectAtIndex:0]objectForKey:@"CompanyID"],@"CompanyID",[[ary objectAtIndex:0]objectForKey:@"UserDisplayName"],@"UsearID", nil];
            
             homVc.strProperty =[[ary objectAtIndex:0]objectForKey:@"PropertyID"];
             
             [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"LoginData"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
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

-(void)setLoginData_LOCALDB:(NSMutableDictionary *)dic
{
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"CompanyID"] forKey:@"CompanyID"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"PropertyID"] forKey:@"PropertyID"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"RoleID"] forKey:@"RoleID"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"RoleType"] forKey:@"RoleType"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"UsearID"] forKey:@"UsearID"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"UserDisplayName"] forKey:@"UserDisplayName"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"UserName"] forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"UserType"] forKey:@"UserType"];
        [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"UserTypeID"] forKey:@"UserTypeID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
