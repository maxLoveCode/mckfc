//
//  CustomCalloutView.m
//  mckfc
//
//  Created by zc on 2017/9/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CustomCalloutView.h"
#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20

@interface CustomCalloutView()
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation CustomCalloutView


#define kArrorHeight        10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin , kPortraitMargin, kScreen_Width - 2 * 20, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    // 添加副标题，即商户地址
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin + kTitleHeight , kScreen_Width - 2 * 20, kTitleHeight + 30)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.subtitleLabel];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}


@end
