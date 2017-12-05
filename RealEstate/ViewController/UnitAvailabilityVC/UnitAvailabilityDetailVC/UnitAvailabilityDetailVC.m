//
//  UnitAvailabilityDetailVC.m
//  RealEstate
//
//  Created by harikrishna patel on 01/12/17.
//  Copyright © 2017 Softqube. All rights reserved.
//

#import "UnitAvailabilityDetailVC.h"
#import "Globle.h"

@interface UnitAvailabilityDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *aryTotal,*aryFilterWingData;
    int countAvailable,countBook;
    NSMutableArray *arySectionList1;
    NSMutableDictionary *dc1;
    NSMutableDictionary *dicAdd;
    NSArray *groupNames ;
}
@end

@implementation UnitAvailabilityDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryFilterWingData = [[NSMutableArray alloc]init];
    arySectionList1 = [[NSMutableArray alloc]init];
    //dicDetails
    
    [self commonData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Datta and %@",_dicDetails);
    
    aryTotal = [_dicDetails objectForKey:@"Table1"];
    _lbHeaderTitle.text = [NSString stringWithFormat:@"%@ %lu",_strWingNAME,(unsigned long)aryTotal.count];
    
    NSMutableArray *aryTotal1 = [_dicDetails objectForKey:@"Table1"];
    
    for (NSMutableDictionary *di in aryTotal1)
    {
        NSString *getID = [NSString stringWithFormat:@"%@",[di objectForKey:@"WingID"]];
        
        if ([_strWingID isEqualToString:getID])
        {
            [aryFilterWingData addObject:di];
        }
    }
  
    NSArray *groups = [aryFilterWingData valueForKeyPath:@"@distinctUnionOfObjects.FloorID"];
    NSMutableArray *arySectionList = [[NSMutableArray alloc]init];

    for (int i =0; i<groups.count; i++)
    {
        NSString *groupId = [NSString stringWithFormat:@"%@",[groups objectAtIndex:i]];
        dc1 = [[NSMutableDictionary alloc]init];
        groupNames = [aryFilterWingData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FloorID = %@", groupId]];
        NSArray *gr = [groupNames valueForKeyPath:@"@distinctUnionOfObjects.FloorName"];

        NSMutableDictionary *dicGroup = [[NSMutableDictionary alloc]init];
        NSMutableArray *aryReplaceGroup = [groupNames mutableCopy];
        
        for (int j=0;j<groupNames.count;j++)
        {
            dicGroup = [[groupNames objectAtIndex:j]mutableCopy];
            
            NSString *strCheck = [NSString stringWithFormat:@"%@",[[groupNames objectAtIndex:j]objectForKey:@"IsBooked"]];
            
            if ([strCheck isEqualToString:@"0"])
            {
                countAvailable++;
                [dicGroup setObject:@"Available" forKey:@"Color"];
               
                
            }
            else
            {
                countBook++;
               [dicGroup setObject:@"Booked" forKey:@"Color"];
                
            }
            [aryReplaceGroup replaceObjectAtIndex:j withObject:dicGroup];
        }
        groupNames = [[NSArray alloc]initWithArray:aryReplaceGroup];
        [dc1 setObject:[NSString stringWithFormat:@"%d/%d",countBook,countAvailable] forKey:@"Count"];
        countBook =0;
        countAvailable =0;
        [dc1 setObject:[NSString stringWithFormat:@"%@",[gr objectAtIndex:0]] forKey:@"FloorName"];
        arySectionList = [groupNames mutableCopy];
        [dc1 setObject:arySectionList forKey:@"List"];
        [arySectionList1 addObject:dc1];
        
    }
    NSLog(@"Ary=%@",arySectionList1);
}
-(void)commonData
{
    //collection header layout frame
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    _collection_list = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    layout.headerReferenceSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width, 40.0);
    
    // register UICollectionHeaderView
    [_collection_list registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell_section"];
    
    //detail popup
    self.viewDetail_popup.hidden=YES;
    
}

#pragma mark - CollectionView Header
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return arySectionList1.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        CellUnitDetail *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell_section" forIndexPath:indexPath];
        
        headerView.lbBuildingNo.text = [[arySectionList1 objectAtIndex:indexPath.section]objectForKey:@"FloorName"];
        headerView.lbAvailableBlock.text = [[arySectionList1 objectAtIndex:indexPath.section]objectForKey:@"Count"];
        
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = [[[arySectionList1 objectAtIndex:section]objectForKey:@"List"]count];
    return row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell_row" forIndexPath:indexPath];
    
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:1];
    
    NSMutableArray *aryList = [[arySectionList1 objectAtIndex:indexPath.section]objectForKey:@"List"];
    
    lb.text = [NSString stringWithFormat:@"%@",[[aryList objectAtIndex:indexPath.row]objectForKey:@"RoomNo"]];
    UIView *viewColorBack = (UIView *)[cell.contentView viewWithTag:2];
    
    //NSString *ColorCheck = [NSString stringWithFormat:@"%@",[[aryList objectAtIndex:indexPath.row]objectForKey:@"Color"]];
    
    /* if ([ColorCheck isEqualToString:@"Available"])
     {
     
     [viewColorBack setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:186.0/255.0 blue:123.0/255.0 alpha:1.0]];
     }
     else
     {
     [viewColorBack setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
     
     }*/
    
    NSString *ColorCheck1 = [NSString stringWithFormat:@"%@",[[aryList objectAtIndex:indexPath.row]objectForKey:@"IsBooked"]];
    
    if ([ColorCheck1 isEqualToString:@"1"])
    {
         [viewColorBack setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]];
       
    }
    else
    {
       
         [viewColorBack setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:186.0/255.0 blue:123.0/255.0 alpha:1.0]];
    }
  
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strAvailable = [NSString stringWithFormat:@"%@",[[[[arySectionList1 objectAtIndex:indexPath.section]objectForKey:@"List"]objectAtIndex:indexPath.row]objectForKey:@"IsBooked"]];
    
    
    if ([strAvailable isEqualToString:@"0"])
    {
      
    }
    else
    {
        //redirect viewcontroller
        self.viewDetail_popup.hidden=NO;
        [self.view bringSubviewToFront:self.viewDetail_popup];
        NSString *roomID = [NSString stringWithFormat:@"%@",[[[[arySectionList1 objectAtIndex:indexPath.section]objectForKey:@"List"]objectAtIndex:indexPath.row]objectForKey:@"RoomID"]];
        
        NSMutableArray *aryNameDetail = [_dicDetails objectForKey:@"Table2"];
        
        for (NSMutableDictionary *d in aryNameDetail)
        {
            NSString *comRoomID = [NSString stringWithFormat:@"%@",[d objectForKey:@"RoomID"]];
            
            if ([roomID isEqualToString:comRoomID])
            {
                _lblName_Detail_popup.text = [NSString stringWithFormat:@"%@",[d objectForKey:@"FullName"]];
                _lblMobilenumber_Detail_popup.text = [NSString stringWithFormat:@"%@",[d objectForKey:@"MobileNo"]];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CGFloat f = [[UIScreen mainScreen]bounds].size.width/4;
        return CGSizeMake(f-10, f-40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsetsMake(CGFloat top, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    UIEdgeInsets insets=UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}
#pragma mark - UIButton Action

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHome:(id)sender
{
    
}

- (IBAction)btnCloseDetail_Popup:(id)sender
{
    self.viewDetail_popup.hidden=YES;
}
@end
