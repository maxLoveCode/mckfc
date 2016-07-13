//
//  CarPlateRegionSelector.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/13.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CarPlateRegionSelector.h"

#define itemSize 40

@interface CarPlateRegionSelector()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation CarPlateRegionSelector

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:CGRectMake(0, 20, kScreen_Width, kScreen_Height-20) collectionViewLayout:layout];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = COLOR_WithHex(0xf3f3f3);
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"regions"];
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_regions count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemSize, itemSize) ;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(k_Margin, k_Margin, 0, k_Margin); // top, left, bottom, right
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"regions" forIndexPath:indexPath];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemSize, itemSize)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _regions[indexPath.item];
    [cell.contentView addSubview:label];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        _selectBlock(_regions[indexPath.item]);
        [self removeFromSuperview];
    }
}

-(void)show
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

@end
