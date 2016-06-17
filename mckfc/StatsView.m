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
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stats" forIndexPath:indexPath];
    
    
    
    return cell;
}

@end
