//
//  CommonUserView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CommonUserView.h"
#import "UIImageView+WebCache.h"

//first section
#define topMargin 60
#define avatarHeight 66
#define itemGap 20
#define titleFont 15

@interface CommonUserView()<UITableViewDelegate, UITableViewDataSource ,MenuDelegate>


@property (nonatomic, assign) NSString* user_type;

@end

@implementation CommonUserView

#pragma mark setters
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        CGRect frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _mainTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainTable"];
    }
    return _mainTableView;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainTable" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView* subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    if (indexPath.section ==0) {
        [self firstSection:cell];
        return cell;
    }
    else
    {
        _user_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"];
        if([_user_type isEqualToString:MKUSER_TYPE_SECURITY])
        {
             _menu = [[CommonMenuView alloc] initWithStyle:MenuViewStyleSecurityCheck];
        }
        else
        {
             _menu = [[CommonMenuView alloc] initWithStyle:MenuViewStyleQualityCheck];
        }
        [_menu setFrame:CGRectOffset(_menu.frame, 0, topMargin/2)];
        _menu.menudelegate = self;
        [cell.contentView addSubview:_menu];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self firstSectionHeight];
    }
    else{
        return topMargin*2+2*kScreen_Width/3;
//        return kScreen_Height-[self firstSectionHeight]
//        - tableView.sectionFooterHeight*2-tableView.sectionHeaderHeight*2
//        - 64 - 75;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0.01;
    }
    else
        return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark firstSection
-(void)firstSection:(UITableViewCell*)cell
{
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    bgView.image = [UIImage imageNamed:@"home_bg"];
    bgView.userInteractionEnabled = YES;
    
    UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, avatarHeight+4, avatarHeight+4)];
    circleView.layer.cornerRadius = (avatarHeight+4)/2;
    [circleView setBackgroundColor:[UIColor whiteColor]];
    circleView.layer.masksToBounds = YES;
    
    UIImageView* avatar = [[UIImageView alloc] initWithFrame:
                           CGRectMake((kScreen_Width-avatarHeight)/2, topMargin, avatarHeight, avatarHeight)];
    avatar.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    avatar.layer.borderWidth = 1.5;
    avatar.layer.cornerRadius = avatarHeight/2;
    avatar.layer.masksToBounds = YES;
    [avatar sd_setImageWithURL:[NSURL URLWithString:_user.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    circleView.center = avatar.center;
    
    avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvtar:)];
    [avatar addGestureRecognizer:tap];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(avatar.frame)+itemGap, kScreen_Width, titleFont)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:titleFont];
    nameLabel.text= _user.driver; //原来只有司机，后面才换的所有人都用 user，所以叫 user.name 更好
    
    UILabel* Occupation = [[UILabel alloc] initWithFrame:
                         CGRectOffset(nameLabel.frame, 0, itemGap+CGRectGetHeight(nameLabel.frame))];
    Occupation.textAlignment = NSTextAlignmentCenter;
    Occupation.font = [UIFont systemFontOfSize:titleFont];
    Occupation.text = @"职位";
    if (self.user.type == [MKUSER_TYPE_SECURITY integerValue]) {
        Occupation.text = @"门卫";
    }
    else
    {
        Occupation.text = @"质检人员";
    }
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(k_Margin, CGRectGetMidY(Occupation.frame), 94, 0.5)];
    [leftView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width- k_Margin- 94, CGRectGetMidY(Occupation.frame), 94, 0.5)];
    [rightView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    
    [bgView addSubview:circleView];
    [bgView addSubview:avatar];
    [bgView addSubview:nameLabel];
    [bgView addSubview:Occupation];
    [bgView addSubview:leftView];
    [bgView addSubview:rightView];
    [cell.contentView addSubview:bgView];
}

#pragma mark total itemHeight
-(CGFloat)firstSectionHeight
{
    return topMargin+avatarHeight+4*itemGap+2*titleFont;
}

#pragma mark layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.mainTableView];
}

-(void)CommonMenuView:(CommonMenuView *)menu didSelectWorkRecordWithType:(MenuViewStyle)style
{
    [self.delegate navigateToWorkRecord];
}

-(void)CommonMenuView:(CommonMenuView *)menu didSelectScanQRCode:(MenuViewStyle)style withIndex:(NSInteger)index
{
    [self.delegate navigateToQRScannerWithItem:index];
}

-(void)CommonMenuView:(CommonMenuView *)menu didSelectTODOWithType:(MenuViewStyle)style
{
    [self.delegate navigateToTODO];
}

-(void)CommonMenuView:(CommonMenuView *)menu didSelectSettingWithType:(MenuViewStyle)style
{
    [self.delegate navigateToSetting];
}

-(void)tapAvtar:(id)sender
{
    [self.delegate didTapAvatar];
}


@end
