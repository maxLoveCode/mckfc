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
    layout.minimumLineSpacing = 0;
    self = [super initWithFrame:CGRectMake(0, 0, kScreen_Width, (rows+1)*itemHeight) collectionViewLayout:layout];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"report"];
    self.delegate = self;
    self.dataSource = self;
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}

#pragma mark uicollectionview datasource
-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (rows+1)*3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreen_Width/3, itemHeight) ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self dequeueReusableCellWithReuseIdentifier:@"report" forIndexPath:indexPath];
    
    for (UIView* subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width/3, itemHeight)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = COLOR_WithHex(0x565656);
    if (indexPath.item == 1) {
        label.text = @"入场";
    }
    else if(indexPath.item == 2){
        label.text = @"出厂";
    }
    else if(indexPath.item == 3){
        label.text = @"重量";
    }
    else if(indexPath.item == 4){
        if (_report) {
            label.text = [NSString stringWithFormat:@"%@吨", _report.weight[@"origin"]];
        }
    }
    else if(indexPath.item == 5){
        if (_report) {
            label.text = [NSString stringWithFormat:@"%@吨", _report.weight[@"factory"]];
        }
    }
    
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark uicollection view paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

@end
