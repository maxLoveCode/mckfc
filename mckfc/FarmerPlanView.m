//
//  FarmerPlanView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#define itemHeight 44

#define imageSize 44

#import "FarmerPlanView.h"
#import "LoadingCell.h"

#import "Masonry.h"

@interface FarmerPlanView ()<UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray* titleText;
    NSArray* menuText;
}

@property (nonatomic, strong) UICollectionView* menuView;

@end

@implementation FarmerPlanView

-(instancetype)init
{
    self = [super init];
    self.type = FarmerPlanViewTypeMenu;
    self.stats = [[LoadingStats alloc] init];
    [self addSubview:self.mainTableView];
    
    return self;
}

#pragma mark properties
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
        
        titleText = @[@"供货城市",@"供应商名称",@"地块编号",@"运输时间"];
    }
    return _mainTableView;
}

-(UICollectionView *)menuView
{
    if (!_menuView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2;
        _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(k_Margin, 10, kScreen_Width-2*k_Margin, 2*kScreen_Width/3) collectionViewLayout:layout];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        [_menuView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [_menuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"menu"];
        
        menuText =  @[@"生成二维码",@"录入运输单",@"工作记录",@"系统设置"];
    }
    return _menuView;
}

#pragma mark tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.type == FarmerPlanViewTypeRecordList)
        return 3;
    else
        return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LoadingCell* cell = [[LoadingCell alloc] init];
        if (indexPath.row != 3) {
            cell.style = LoadingCellStyleSelection;
        }
        else
        {
            cell.style = LoadingCellStyleDatePicker;
        }
        
        cell.titleLabel.text = titleText[indexPath.row];
        cell.leftImageView.image = [UIImage imageNamed:titleText[indexPath.row]];
        
        if (indexPath.row == 0) {
            cell.detailLabel.text = _stats.city.name;
        }
        else if(indexPath.row == 1){
            cell.detailLabel.text = _stats.supplier.name;
        }
        else if(indexPath.row == 2){
            cell.detailLabel.text = _stats.field.name;
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menu"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.type == FarmerPlanViewTypeMenu) {
            [cell.contentView addSubview:self.menuView];
        }
        else if(self.type == FarmerPlanViewTypeQRCode)
        {
            if (self.qrCodeView != nil) {
                [cell.contentView addSubview:self.qrCodeView];
            }
        }
        else if(self.type == FarmerPlanViewTypeOrder)
        {
            if (self.addRecordView != nil) {
                [cell.contentView addSubview:self.addRecordView];
            }
        }
        else if(self.type == FarmerPlanViewTypeRecordList)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemHeight, itemHeight)];
            imageView.image = [UIImage imageNamed:@"menuCancel"];
            UILabel* label = [[UILabel alloc] init];
            label.text = @"添加运输单";
            label.textColor = COLOR_WithHex(0x565656);
            [label sizeToFit];
            UIView* wrapper = [[UIView alloc] init];
            
            [wrapper addSubview:imageView];
            [wrapper addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.right).with.offset(10);
                make.centerY.equalTo(imageView);
            }];
            
            [wrapper sizeToFit];
            [cell.contentView addSubview:wrapper];
            
            [wrapper mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(imageView.frame.size.width+label.frame.size.width+10, itemHeight));
                make.center.equalTo(cell.contentView);
            }];
            
        }
        return cell;
    }
    else if(indexPath.section == 2)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
        return cell;
    }
    return nil;
}

#pragma mark UICollectionView delegate and datasources
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frame = CGRectMake((CGRectGetWidth(cell.contentView.frame)-100)/2, k_Margin/2, imageSize, imageSize);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:menuText[indexPath.item]]];
    imageView.center = CGPointMake(cell.contentView.center.x, cell.contentView.center.y-20);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, CGRectGetWidth(cell.contentView.frame), 15)];
    label.text = menuText[indexPath.item];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_WithHex(0x565656);
    label.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:label];

    
    return cell;
}

#pragma mark constraints
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return itemHeight;
    }
    else{
        
        if (self.type == FarmerPlanViewTypeMenu) {
            return 2*kScreen_Width/3+19;
        }
        else if(self.type == FarmerPlanViewTypeQRCode)
        {
            return 350;
        }
        else if(self.type == FarmerPlanViewTypeOrder)
        {
            return itemHeight*5;
        }
        else if(self.type == FarmerPlanViewTypeRecordList)
        {
            if (indexPath.section == 1) {
                return itemHeight*2;
            }
            else return itemHeight;
        }
        else
            return itemHeight;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreen_Width-2*k_Margin)/2-1, kScreen_Width/3-1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        [self.delegate tableStats:tableView DidSelectIndex:indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menu:self DidSelectIndex:indexPath.item];
}

@end
