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


//viewcontroller

#import "Utility.h"

//UITableView


///// in built

#import <CoreGraphics/CoreGraphics.h>

#pragma mark - API

#define BASE_URL @"http://symphonyirms.softcube.in/Services/apk_Booking.asmx"
#define IMAGE_BASE_URL @""


#pragma mark - Method

#define GetList @"GetAllBookingList"


#import "UITextView+Placeholder.h"
#import <AFNetworking.h>
#import <RealReachability.h>


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

#endif /* Globle_h */
