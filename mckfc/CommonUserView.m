//
//  CommonUserView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CommonUserView.h"
#import "CommonMenuView.h"

//first section
#define topMargin 60
#define avatarHeight 66
#define itemGap 20
#define titleFont 15

@interface CommonUserView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* mainTableView;

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
    if (indexPath.section ==0) {
        [self firstSection:cell];
    }
    else
    {
        CommonMenuView* menu = [[CommonMenuView alloc] initWithStyle:MenuViewStyleSecurityCheck];
        //CommonMenuView* menu = [[CommonMenuView alloc] initWithStyle:MenuViewStyleQualityCheck];
        [menu setFrame:CGRectOffset(menu.frame, 0, CGRectGetMidY(cell.contentView.frame)-CGRectGetMidY(menu.frame))];
        [cell.contentView addSubview:menu];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self firstSectionHeight];
    }
    else{
        return kScreen_Height-[self firstSectionHeight]
        - tableView.sectionFooterHeight*2-tableView.sectionHeaderHeight*2
        - 64 - 75;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0.01;
    }
    else
        return tableView.sectionHeaderHeight;
}

#pragma mark firstSection
-(void)firstSection:(UITableViewCell*)cell
{
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    bgView.image = [UIImage imageNamed:@"home_bg"];
    
    UIImageView* avatar = [[UIImageView alloc] initWithFrame:
                           CGRectMake((kScreen_Width-avatarHeight)/2, topMargin, avatarHeight, avatarHeight)];
    avatar.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    avatar.layer.borderWidth = 1.5;
    avatar.layer.cornerRadius = avatarHeight/2;
    avatar.layer.masksToBounds = YES;
    [avatar setImage:[UIImage imageNamed:@"default_avatar"]];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(avatar.frame)+itemGap, kScreen_Width, titleFont)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:titleFont];
    nameLabel.text= @"张三";
    
    UILabel* Occupation = [[UILabel alloc] initWithFrame:
                         CGRectOffset(nameLabel.frame, 0, itemGap+CGRectGetHeight(nameLabel.frame))];
    Occupation.textAlignment = NSTextAlignmentCenter;
    Occupation.font = [UIFont systemFontOfSize:titleFont];
    Occupation.text = @"门卫";
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(k_Margin, CGRectGetMidY(Occupation.frame), 94, 0.5)];
    [leftView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width- k_Margin- 94, CGRectGetMidY(Occupation.frame), 94, 0.5)];
    [rightView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    
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

@end
