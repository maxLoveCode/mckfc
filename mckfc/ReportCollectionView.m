//
//  ReportCollectionView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//


#import "ReportCollectionView.h"
#import "Report.h"

#define rows [Report numberOfProperties]
#define itemHeight 44


@implementation ReportCollectionView

-(instancetype)init
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:CGRectMake(0, 0, kScreen_Width, rows*itemHeight) collectionViewLayout:layout];
    self.delegate = self;
    self.dataSource = self;
    return self;
}

-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (rows+1)*3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self dequeueReusableCellWithReuseIdentifier:@"report" forIndexPath:indexPath];
    
    return cell;
}
@end
