//
//  Globle.h
//  Gab
//
//  Created by Softqube on 02/06/17.
//  Copyright © 2017 me. All rights reserved.
//

#ifndef Globle_h
#define Globle_h

//thirdParty
#import "Utility.h"
#import "Reachability.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "MXParallaxHeader.h"
#import "DEMONavigationController.h"
#import "REFrostedViewController.h"
#import "CLTokenInputView.h"
#import "JBKenBurnsView.h"
#import "FTToastIndicator.h"
#import "FTProgressIndicator.h"
#import "FTNotificationIndicator.h"
#import "FTIndicator.h"
#import "DBOperation.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NIDropDown.h"
#import "CMPopTipView.h"
#import "NTMonthYearPicker.h"
#import "FTIndicator.h"
#import "FTToastIndicator.h"
#import "FTProgressIndicator.h"
#import "FTNotificationIndicator.h"


//viewcontroller
#import "LoginVC.h"
#import "HomeVC.h"
#import "ProfileVc.h"
#import "LeaveForApproveVc.h"
#import "LeaveDetail.h"
#import "AddEditLeaveVC.h"
#import "InterMedeiateViewcontroller.h"
#import "ToDoVc.h"
#import "MyTaskVc.h"
#import "WunderList.h"

//UITableView

#import "SingleStatusCell.h"
#import "TwoWithNotifyCell.h"
#import "AdminThreeBtnCell.h"
#import "EmployeeTwoBtnCell.h"

#import "LeaveCell.h"
#import "LeaveDetailCellTableViewCell.h"
#import "SecondForHRCell.h"
#import "ThirdForAdminCell.h"
#import "NotifyCell.h"
#import "MyTaskSectionCell.h"

///// in built

#import <CoreGraphics/CoreGraphics.h>

#pragma mark - API

//#define BASE_URL @"http://192.168.1.62/oms/api/"
//#define IMAGE_BASE_URL  @"http://192.168.1.62/oms/files/team_member/thumbnail/"

//#define BASE_URL @"http://192.168.1.1/oms/api/"
//#define IMAGE_BASE_URL  @"http://192.168.1.1/oms/files/team_member/thumbnail/"

//#define BASE_URL @"http://43.252.197.237/PHP/projects/oms/api/"
//#define IMAGE_BASE_URL  @"http://43.252.197.237/PHP/projects/oms/files/team_member/thumbnail/"

#define BASE_URL @"http://office.softqubes.com/api/"
#define IMAGE_BASE_URL @"http://office.softqubes.com/files/team_member/thumbnail/"

#define LOGIN @"Login"
#define REQUESTEDLEAVE @"RequestedLeaves"
#define LEAVEDE @"LeaveDetail"
#define LEAVEREQUEST @"LeaveRequest"
#define APPROLEAVE @"ApproveLeave"
#define APPROLEAVEREQ @"approveleaverequest"
#define FORGOTPASS @"forgot_password"
#define LOGOUT @"logout"
#define NOTIFY @"notify_other_team_member"
#define LEAVECANCEL @"CancelLeave"


#pragma mark - validation 

#define INTERNET @"No internet connection.."
#define SERVERNotResponding @"Server not responding!"
#define LOGINRIGHTUSER @"Please enter valid login user account"
#define SUCCESSMSG @"Please check your mail to reset your password"
#define REASON @"Please enter reason for leave"
#define CANCLELEAVE @"Are you sure want to cancel leave request"
#pragma mark - login toast

#define EMAIL  @"Please enter email"
#define VALIDEMAIL @"please enter valid email"
#define PASSWORD @"Please enter password"
#define PASSVALI @"Please password must be greater than 4 and less than 10"

#define SELECTDura @"Please select duration"
#define SELECTDATE @"Please select date"
#define SELECTTYPE @"Please select leave type"
#define SELECTWHICHTYPE @"Please select which half"
#define  SELCTREASO @"Please enter reason for leave"
#define SELECTTIll @"please select till date"
#define SELECTHOUR @"Please select leave hour"
#define DatevAl @"EndDate should not be before startdate"

#endif /* Globle_h */
