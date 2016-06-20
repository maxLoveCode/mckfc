//
//  UserView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "UserView.h"
#import "StatsView.h"
#import "MCStarView.h"

#pragma mark constant
//first section
#define topMargin 60
#define avatarHeight 66
#define itemGap 20
#define titleFont 15
#define starHeight 22

//second section
#define secondSection 100

//third section
#define buttonHeight 40
#define buttonWidth 340

@interface UserView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* mainTableView;

@end

@implementation UserView

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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self firstSectionHeight];
    }
    else if(indexPath.section ==1){
        return secondSection;
    }
    else{
        return kScreen_Height-[self firstSectionHeight]- secondSection
            - tableView.sectionFooterHeight*2-tableView.sectionHeaderHeight*2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainTable" forIndexPath:indexPath];
    if (indexPath.section ==0) {
        [self firstSection:cell];
    }
    else if (indexPath.section == 1){
        StatsView* stats = [[StatsView alloc] initWithStats:nil];
        [cell.contentView addSubview:stats];
    }
    else
    {
        UIButton* confirm;
        confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:@"进行装载" forState:UIControlStateNormal];
        [confirm setBackgroundColor:COLOR_THEME];
        [confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        confirm.layer.cornerRadius = 3;
        confirm.layer.masksToBounds = YES;
        [confirm setFrame:CGRectMake((kScreen_Width-buttonWidth)/2, topMargin,buttonWidth , buttonHeight)];
        [confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirm];
    }
    return cell;
}

#pragma mark layoutSubviews
-(void)layoutSubviews
{
    [self addSubview:self.mainTableView];
}

#pragma mark total itemHeight
-(CGFloat)firstSectionHeight
{
    return topMargin+avatarHeight+4*itemGap+2*titleFont+starHeight;
}

#pragma mark firstSection
-(void)firstSection:(UITableViewCell*)cell
{
    UIImageView* avatar = [[UIImageView alloc] initWithFrame:
                           CGRectMake((kScreen_Width-avatarHeight)/2, topMargin, avatarHeight, avatarHeight)];
    avatar.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    avatar.layer.borderWidth = 1.5;
    avatar.layer.cornerRadius = avatarHeight/2;
    avatar.layer.masksToBounds = YES;
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(avatar.frame)+itemGap, kScreen_Width, titleFont)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:titleFont];
    
    
    UILabel* carLabel = [[UILabel alloc] initWithFrame:
                         CGRectOffset(nameLabel.frame, 0, itemGap+CGRectGetHeight(nameLabel.frame))];
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.font = [UIFont systemFontOfSize:titleFont];
    
#ifdef DEBUG
    nameLabel.text= @"车主姓名";
    carLabel.text = @"车牌号";
    avatar.image = [UIImage imageNamed:@"star"];
#endif
    
    MCStarView* starView = [[MCStarView alloc] initWithCount:5];
    CGSize framesize = [starView sizeOfView];
    [starView setFrame:CGRectMake((kScreen_Width-framesize.width)/2, CGRectGetMaxY(carLabel.frame)+itemGap, framesize.width, framesize.height )];
    [starView setStarValue:2];
    
    [cell.contentView addSubview:avatar];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:carLabel];
    [cell.contentView addSubview:starView];
}

-(void)confirmBtn
{
    [self.delegate didClickConfirm];
}

@end
