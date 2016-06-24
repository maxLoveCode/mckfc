//
//  StatsView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "StatsView.h"

#define height 100

@interface StatsView()

@property (nonatomic, strong) NSDictionary* stats;

@end

@implementation StatsView

-(instancetype)initWithStats:(NSDictionary*)Stats
{
    self.stats = Stats;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect frame;
    frame = CGRectMake(0, 0, kScreen_Width, height);
    self = [super initWithFrame:frame collectionViewLayout:layout];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"stats"];
    
    _stats = @{@"运输次数":@"10",
               @"总里程数":@"100km",
               @"运输总重数":@"300"};
    self.backgroundColor = [UIColor whiteColor];
    self.scrollEnabled = NO;
    
    self.delegate = self;
    self.dataSource = self;
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreen_Width/3, height) ;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stats" forIndexPath:indexPath];
    
    for (UIView* view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width/3, height/2)];
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectOffset(title.frame, 0, height/2)];
    title.textColor = COLOR_TEXT_GRAY;
    title.font = [UIFont systemFontOfSize:13];
    
    
    detailLabel.textColor = [UIColor darkTextColor];
    detailLabel.font = [UIFont systemFontOfSize:14];
    
    title.textAlignment = NSTextAlignmentCenter;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:detailLabel];
    
    if (indexPath.item == 0) {
        title.text = @"运输次数";
        detailLabel.text = [NSString stringWithFormat:@"%@", _stats[@"transportTime"]];
    }
    else if (indexPath.item == 1){
        title.text = @"总里程数";
        detailLabel.text = [NSString stringWithFormat:@"%@", _stats[@"totalMile"]];
    }
    else if (indexPath.item == 2){
        title.text = @"总里程数";
        detailLabel.text = [NSString stringWithFormat:@"%@", _stats[@"totalWeight"]];
    }
    return cell;
}

-(void)setStatsFromDictionary:(NSDictionary *)stats
{
    NSLog(@"%@",stats);
    self.stats = stats;
    [self reloadData];
}

@end
