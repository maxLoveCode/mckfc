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
#import "UIImageView+WebCache.h"

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
#define buttonWidth kScreen_Width-4*k_Margin

@interface UserView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* mainTableView;
@property (strong, nonatomic) StatsView* stats;

@end

@implementation UserView

-(instancetype)init
{
    self = [super init];
    [self addSubview:self.mainTableView];
    return self;
}

#pragma mark setters
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        CGRect frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _mainTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainTable"];
        _mainTableView.allowsSelection = NO;
    }
    return _mainTableView;
}

-(UIButton *)botBtn
{
    if (!_botBtn) {
        _botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_botBtn setTitle:@"《入厂须知》" forState: UIControlStateNormal];
        [_botBtn setTitleColor:COLOR_WithHex(0x565656) forState:UIControlStateNormal];
        [_botBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_botBtn setBackgroundColor:[UIColor clearColor]];
        
    }
    return _botBtn;
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
        CGFloat content = kScreen_Height-[self firstSectionHeight]- secondSection
        - 64 -40;
        if (content < topMargin*2+buttonHeight) {
            return topMargin*2+buttonHeight;
        }
        else
            return content;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainTable" forIndexPath:indexPath];
    if (indexPath.section ==0) {
        [self firstSection:cell];
    }
    else if (indexPath.section == 1){
        _stats = [[StatsView alloc] initWithStats:nil];
        [cell.contentView addSubview:_stats];
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
        [confirm setFrame:CGRectMake(2*k_Margin, topMargin,buttonWidth , buttonHeight)];
        [confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirm];
        
        
        [cell.contentView addSubview:self.botBtn];
        [self.botBtn sizeToFit];
        [self.botBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(confirm.bottom).with.offset(10);
            make.centerX.equalTo(confirm);
        }];
    }
    return cell;
}

#pragma mark layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark total itemHeight
-(CGFloat)firstSectionHeight
{
    return topMargin+avatarHeight+4*itemGap+2*titleFont+starHeight;
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
    [avatar setImage:[UIImage imageNamed:@"default_avatar"]];
    avatar.tag = 1000;
    circleView.center = avatar.center;
    avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvtar:)];
    [avatar addGestureRecognizer:tap];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(avatar.frame)+itemGap, kScreen_Width, titleFont)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:titleFont];
    nameLabel.tag = 1001;
    
    UILabel* carLabel = [[UILabel alloc] initWithFrame:
                         CGRectOffset(nameLabel.frame, 0, itemGap+CGRectGetHeight(nameLabel.frame))];
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.font = [UIFont systemFontOfSize:titleFont];
    carLabel.tag = 1002;
#ifdef DEBUG
    nameLabel.text= @"车主姓名";
    carLabel.text = @"车牌号";
#endif
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(k_Margin, CGRectGetMidY(carLabel.frame), 94, 0.5)];
    [leftView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width- k_Margin- 94, CGRectGetMidY(carLabel.frame), 94, 0.5)];
    [rightView setBackgroundColor:COLOR_WithHex(0xdddddd)];
    
    MCStarView* starView = [[MCStarView alloc] initWithCount:5];
    CGSize framesize = [starView sizeOfView];
    [starView setFrame:CGRectMake((kScreen_Width-framesize.width)/2, CGRectGetMaxY(carLabel.frame)+itemGap, framesize.width, framesize.height )];
    [starView setStarValue:2];
    starView.tag = 1005;
    [bgView addSubview:circleView];
    [bgView addSubview:avatar];
    [bgView addSubview:nameLabel];
    [bgView addSubview:carLabel];
    [bgView addSubview:starView];
    [bgView addSubview:leftView];
    [bgView addSubview:rightView];
    [cell.contentView addSubview:bgView];
}

-(void)confirmBtn
{
    [self.delegate didClickConfirm];
}

#pragma mark set content
-(void)setContentByUser:(User *)user
{
    UITableViewCell* firstCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIView* content = firstCell.contentView;
    UILabel* nameLabel = [content viewWithTag:1001];
    nameLabel.text = user.driver;
    if ([user.driver isEqualToString:@""]) {
        nameLabel.text = @"未命名司机";
    }
    
    MCStarView* star = [content viewWithTag:1005];
    [star setStarValue:user.star];
    
    UILabel* carlabel = [content viewWithTag:1002];
    carlabel.text = user.truckno;
    if ([carlabel.text isEqualToString:@""]) {
        carlabel.text = @"未填写车牌号";
    }
    
    
    UIImageView* avatar = [content viewWithTag:1000];
    [avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    [_stats setStatsFromDictionary:@{@"totalMile":user.totalmile,
                                     @"totalWeight":user.totalweight,
                                     @"transportTime":user.transporttime}];
}

-(void)tapAvtar:(id)sender
{
    [self.delegate didTapAvatar];
}

@end
