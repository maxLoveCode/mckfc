//
//  CommonMenuView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CommonMenuView.h"

#define menuItemWidth kScreen_Width/3 -2*k_Margin
#define imageSize 44

@interface CommonMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray* _titleArray;
}

@end

@implementation CommonMenuView

-(instancetype)init
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    self = [super initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, 2*kScreen_Width/3) collectionViewLayout:layout];
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"report"];
    self.delegate = self;
    self.dataSource = self;
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.scrollEnabled = NO;
    return self;
}

-(instancetype)initWithStyle:(MenuViewStyle)style
{
    self = [[CommonMenuView alloc] init];
    self.style = style;
    if (self.style != MenuViewStyleSecurityCheck) {
        _titleArray = @[@"到厂扫码",@"待收订单",@"工作记录",@"系统设置"];
    }
    else
    {
        _titleArray = @[@"到厂扫码",@"进场扫码",@"出场扫码",@"待收订单",@"工作记录",@"系统设置"];
    }
    return self;
}

#pragma mark uicollectionview datasource
-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.style != MenuViewStyleSecurityCheck) {
        return 4;
    }
    else
    {
        return 6;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.style != MenuViewStyleSecurityCheck) {
        return CGSizeMake((kScreen_Width-2*k_Margin)/2-0.5, kScreen_Width/3) ;
    }
    else
    {
        return CGSizeMake((kScreen_Width-2*k_Margin)/3-0.75, kScreen_Width/3) ;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [self dequeueReusableCellWithReuseIdentifier:@"report" forIndexPath:indexPath];
    
    CGRect frame = CGRectMake((CGRectGetWidth(cell.contentView.frame)-100)/2, k_Margin/2, imageSize, imageSize);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:_titleArray[indexPath.item]]];
    //imageView.center = cell.contentView.center;
    imageView.center = CGPointMake(cell.contentView.center.x, cell.contentView.center.y-20);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, CGRectGetWidth(cell.contentView.frame), 15)];
    label.text = _titleArray[indexPath.item];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_WithHex(0x565656);
    label.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:label];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

#pragma mark uicollection view paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}

#pragma mark select delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [_titleArray count] -2) {
        [self.menudelegate CommonMenuView:self didSelectWorkRecordWithType:self.style];
    }
    if (indexPath.item == [_titleArray count] -3) {
        [self.menudelegate CommonMenuView:self didSelectTODOWithType:self.style];
    }
    if (self.style == MenuViewStyleSecurityCheck) {
        if (indexPath.item <3 ) {
            [self.menudelegate CommonMenuView:self didSelectScanQRCode:self.style withIndex:indexPath.item];
        }
    }
    else
    {
        if (indexPath.item == 0) {
            [self.menudelegate CommonMenuView:self didSelectScanQRCode:self.style withIndex:indexPath.item];
        }
    }
}

@end
