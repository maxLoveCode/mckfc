//
//  UserView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "UserView.h"
#import "StatsView.h"

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
        return buttonHeight+topMargin+itemGap;
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
    return topMargin+avatarHeight+3*itemGap+2*titleFont+starHeight;
}

#pragma mark firstSection
-(void)firstSection:(UITableViewCell*)cell
{
    UIImageView* avatar = [[UIImageView alloc] initWithFrame:
                           CGRectMake((kScreen_Width-avatarHeight)/2, topMargin, avatarHeight, avatarHeight)];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(avatar.frame)+itemGap, kScreen_Width, titleFont)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:titleFont];
    
    
    UILabel* carLabel = [[UILabel alloc] initWithFrame:
                         CGRectOffset(nameLabel.frame, 0, itemGap)];
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.font = [UIFont systemFontOfSize:titleFont];
    
#ifdef DEBUG
    nameLabel.text= @"车主姓名";
    carLabel.text = @"车牌号";
#endif
    
    [cell.contentView addSubview:avatar];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:carLabel];
}

@end
