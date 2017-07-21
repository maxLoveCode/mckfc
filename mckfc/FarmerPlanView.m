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
    NSArray *_imgArr;
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
    self.stats.departuretime = nil;
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
        
        titleText = @[@"种植区域",@"供应商名称",@"地块编号",@"目的地",@"运输时间"];
        _imgArr = @[@"供货城市",@"供应商名称",@"地块编号",@"目的地",@"运输时间"];
    }
    return _mainTableView;
}

- (CreatQRCodeView *)creatQRCodeView{
    if (!_creatQRCodeView) {
        self.creatQRCodeView = [[CreatQRCodeView alloc] init];
        _creatQRCodeView.frame = CGRectMake(0, 10, kScreen_Width, kScreen_Height - itemHeight * 7- 20);
    }
    return _creatQRCodeView;
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
        
        menuText =  @[@"计划二维码",@"录入运输单",@"工作记录",@"系统设置"];
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
        return [titleText count];
    }
    else if(self.type == FarmerPlanViewTypeRecordList)
    {
        if (section == 1) {
            return 1;
        }
        else return self.datasource.count;
    }else if(self.type == FarmerPlanViewTypeHistory)
        return self.datasource.count;
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LoadingCell* cell = [[LoadingCell alloc] init];
            cell.style = LoadingCellStyleSelection;
        
        cell.titleLabel.text = titleText[indexPath.row];
        cell.leftImageView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
        
        if (indexPath.row == 0) {
            if (!_stats.city) {
                cell.detailLabel.text = @"请选择城市";
            }
            else
                cell.detailLabel.text = _stats.city.name;
        }
        else if(indexPath.row == 1){
            if (!_stats.supplier) {
                cell.detailLabel.text = @"请选择供应商";
            }
            else
                cell.detailLabel.text = _stats.supplier.name;
        }
        else if(indexPath.row == 2){
            if (!_stats.field) {
                cell.detailLabel.text = @"请选择地块";
            }
            else
                cell.detailLabel.text = _stats.field.name;
        }
        else if(indexPath.row == 3){
            if (!_stats.factory) {
                cell.detailLabel.text = @"请选择工厂";
            }
            else
                cell.detailLabel.text = _stats.factory.name;
        }
        else
        {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            if(!_stats.departuretime)
            {
                cell.detailLabel.text = @"请选择时间";
            }
            else
            {
                cell.detailLabel.text = [dateFormatter stringFromDate:_stats.departuretime];
            }
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
        else if(self.type == FarmerPlanViewTypeOrder || self.type == FarmerPlanViewTypeDetail)
        {
            if (self.addRecordView != nil) {
                [cell.contentView addSubview:self.addRecordView];
            }
            if(self.type == FarmerPlanViewTypeDetail)
            {
                self.addRecordView.userInteractionEnabled = NO;
            }
            else
            {
                self.addRecordView.userInteractionEnabled = YES;
            }
        }
        else if(self.type == FarmerPlanViewTypeRecordList)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemHeight, itemHeight)];
            imageView.image = [UIImage imageNamed:@"add"];
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
         else if(self.type == FarmerPlanViewTypeHistory)
         {
             FarmerRecordCell* cell = [[FarmerRecordCell alloc] init];
             cell.content = self.datasource[indexPath.row];
             [cell.accessoryImage addTarget:self action:@selector(tapQrcode:) forControlEvents:UIControlEventTouchUpInside];
             cell.accessoryImage.tag = indexPath.row;
             return cell;
         } else if (self.type == FarmerPlanViewTypeCodeQR){
             self.creatQRCodeView.numberCode = [NSString stringWithFormat:@"%ld",(unsigned long)self.stats.field.fieldID];
             [cell.contentView addSubview:self.creatQRCodeView];
         }
        return cell;
    }
    else if(indexPath.section == 2)
    {
        FarmerRecordCell* cell = [[FarmerRecordCell alloc] init];
        cell.content = self.datasource[indexPath.row];
        [cell.accessoryImage addTarget:self action:@selector(tapQrcode:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryImage.tag = indexPath.row;
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
    if (indexPath.item == 0) {
        label.text = @"生成产地二维码";
    }else if(indexPath.item == 2){
        label.text = @"车辆登记记录";
    }else{
        label.text = menuText[indexPath.item];
    }
    
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
        } else if (self.type == FarmerPlanViewTypeCodeQR){
            return kScreen_Height - itemHeight * 7 - 30;
        }
        else if(self.type == FarmerPlanViewTypeQRCode)
        {
            return 350;
        }
        else if(self.type == FarmerPlanViewTypeOrder || self.type == FarmerPlanViewTypeDetail)
        {
            return itemHeight*8;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.type == FarmerPlanViewTypeDetail || self.type == FarmerPlanViewTypeOrder) {
        if (section == 1) {
            return 60;
        }
    }
    if (self.type == FarmerPlanViewTypeRecordList ) {
        if (section == 2) {
            return 60;
        }
    }
    return 0.01;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreen_Width-2*k_Margin)/2-1, kScreen_Width/3-1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1.0;
}

#pragma mark -selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        [self.planViewDelegate tableStats:tableView DidSelectIndex:indexPath.row];
    }
    else if(self.type == FarmerPlanViewTypeRecordList && indexPath.section == 1)
    {
//index = 10 when add record
        [self.planViewDelegate tableStats:tableView DidSelectIndex:10];
    }
    else if((self.type == FarmerPlanViewTypeRecordList && indexPath.section == 2) || self.type == FarmerPlanViewTypeCodeQR)
    {
        [self.planViewDelegate tableStats:tableView DidSelectIndex:201+indexPath.row];
    }
    else if(self.type == FarmerPlanViewTypeHistory && indexPath.section == 1)
    {
        [self.planViewDelegate tableStats:tableView DidSelectIndex:3001+indexPath.row];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.planViewDelegate menu:self DidSelectIndex:indexPath.item];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == FarmerPlanViewTypeRecordList && indexPath.section == 2) {
        return YES;
    }
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.planViewDelegate list:tableView DidDeleteRowAtIndexPath:indexPath];
    }
}

-(void)tapQrcode:(id)sender
{
    FarmerRecordCell* cell;
    NSIndexPath* indexPath;
    UIButton* btn = (UIButton*)sender;
    if(self.type == FarmerPlanViewTypeHistory)
    {
        indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:1];
        cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:2];
        cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
    }
    [self.planViewDelegate tableView:self.mainTableView DidSelectFarmerCell:cell];
}

@end
