//
//  Globle.h
//  Gab
//
//  Created by Softqube on 02/06/17.
//  Copyright © 2017 me. All rights reserved.
//

#ifndef Globle_h
#define Globle_h




//viewcontroller

#import "Utility.h"
#import "HomeVC.h"
#import "loginVc.h"
#import "UnitAvailabilityListVC.h"
#import "UnitAvailabilityDetailVC.h"

//UITableView cell

//collection cell

#import "CellUnitDetail.h"


/// framework

#import <CoreGraphics/CoreGraphics.h>

#pragma mark - API

#define BASE_URL @"http://symphonyirms.softcube.in/Services"

#define IMAGE_BASE_URL @"http://symphonyirms.softcube.in/Document/"


#pragma mark - Method

#define GetList @"/apk_Booking.asmx/GetUnitAvailabilityList"
#define LOGIN @"/apk_Login.asmx/Login"
#define GetAllBookingList @"/apk_Booking.asmx/GetAllBookingList"


//mac0001

#define GetAllDocuments @"/apk_Documents.asmx/GetAllDocuments"
#define OtherOptions @"/apk_Documents.asmx/OtherOptions"
#define AddEditDocument @"/apk_Documents.asmx/AddEditDocument"

//=======


//thirdParty

#import <AFNetworking.h>
#import <RealReachability.h>
#import "WToast.h"
#import <FTToastIndicator.h>
#import <AFNetworking.h>
#import <RealReachability.h>
#import <IQKeyboardManager.h>
#import <FTProgressIndicator.h>
#import <FTToastIndicator.h>
#import <FTIndicator.h>
#import "Reachability.h"


//====MAC0001
#import <UIImageView+AFNetworking.h>
#import "NIDropDown.h"
//





/*
 
 pod 'AFNetworking', '~> 3.0'
 pod 'MBProgressHUD', '~> 1.1.0'
 pod 'ActionSheetPicker-3.0', '~> 2.2.0'
 pod 'RealReachability'
 pod 'IQKeyboardManager'
 pod 'FTIndicator'
 end
 */
//AddEditBooking
//GetUnitAvailabilityList
//GetCurrentMonthBookingList
//AddEditDocument
//GetAllDocuments
//OtherOptions
//GetAllInvestors
//GetInvestorDetails
//AddEditInvestor
//Login
//GetAllOptions
//GetAllStatistics
//AddEditReceipt
//GetCollectionList
//GetCollectionListByDateWise
//GetCustomerByUnitNo
//AddEditPayOut

#pragma mark - validation

#define INTERNET @"No internet connection.."
#define NODATA @"No data available.."

#endif /* Globle_h */
