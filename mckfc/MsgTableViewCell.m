//
//  MsgTableViewCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#define cellEstimateHeight 130.0f
#define titleLabelHeight 32.0f
#define timeLabelHeight 22.0f

#import "MsgTableViewCell.h"

@implementation MsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reuseID = reuseIdentifier;
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.timeLabel];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, titleLabelHeight));
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(k_Margin);
            make.right.equalTo(self.contentView).with.offset(-k_Margin);
            make.bottom.equalTo(self.timeLabel.top);
        }];
        
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, timeLabelHeight));
            make.top.equalTo(self.title.bottom);
            make.left.equalTo(self.contentView).with.offset(k_Margin);
            make.right.equalTo(self.contentView).with.offset(-k_Margin);
            make.bottom.equalTo(self.content.top);
        }];
        
        [self.content makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, cellEstimateHeight-titleLabelHeight-timeLabelHeight-10));
            make.top.equalTo(self.timeLabel.bottom);
            make.left.equalTo(self.contentView).with.offset(k_Margin);
            make.right.equalTo(self.contentView).with.offset(-k_Margin);
            make.bottom.equalTo(self.content.bottom);
        }];
    }
    return self;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"消息标题";
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textColor = COLOR_WithHex(0x565656);
    }
    return _title;
}

-(UILabel *)content
{
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.text = @"读取中...";
        
        _content.font = [UIFont systemFontOfSize:16];
        _content.textColor = COLOR_WithHex(0x565656);
        _content.numberOfLines = 0;
    }
    return _content;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"创建时间";
        
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _timeLabel;
}

-(UIView *)gradientMask
{
    if (!_gradientMask) {
        CGFloat height = 50;
        _gradientMask = [[UIView alloc] initWithFrame:CGRectMake(0, cellEstimateHeight - height, kScreen_Width, height)];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _gradientMask.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0].CGColor, (id)[UIColor whiteColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(kScreen_Width/2, 0.0f);
        gradientLayer.endPoint = CGPointMake(kScreen_Width/2, 0.6f);
        [_gradientMask.layer insertSublayer:gradientLayer atIndex:0];
    }
    return _gradientMask;
}

-(void)setMessage:(Message *)message
{
    self->_message = message;
    self.title.text = message.title;
    self.content.text = message.content;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [formatter stringFromDate:message.createDate];
    
    CGSize size = [MsgTableViewCell findHeightForText:self.content.text havingWidth:kScreen_Width-2*k_Margin andFont:self.content.font];
    //NSLog(@"%lf, %i", size.height, cellEstimateHeight-titleLabelHeight-timeLabelHeight-10);
    CGFloat originHeight = cellEstimateHeight-titleLabelHeight-timeLabelHeight-10;
    if (size.height > originHeight) {
        [self.contentView addSubview:self.gradientMask];
    }
    else
    {
        [self.gradientMask removeFromSuperview];
    }
}

-(void)setExpand:(BOOL)expand
{
    self->_expand = expand;
    if (self.expand) {
        if ([self fullTextHeight] > cellEstimateHeight) {
            [self expandContent];
        }
    }
    else
    {
        if ([self fullTextHeight] > cellEstimateHeight) {
            [self hideContent];
        }
    }
}

+ (CGFloat)heightForCell
{
    return cellEstimateHeight;
}

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

- (CGFloat)fullTextHeight
{
    CGFloat textHeight = [MsgTableViewCell findHeightForText:self.content.text havingWidth:kScreen_Width-2*k_Margin andFont:self.content.font].height;
    CGFloat originHeight = cellEstimateHeight-titleLabelHeight-timeLabelHeight-10;
    if (textHeight > originHeight) {
        return cellEstimateHeight + (textHeight - originHeight);
    }
    else
        return cellEstimateHeight;
}

-(void)expandContent
{
    CGFloat textHeight = [MsgTableViewCell findHeightForText:self.content.text havingWidth:kScreen_Width-2*k_Margin andFont:self.content.font].height;
    [self.content remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, textHeight));
        make.top.equalTo(self.timeLabel.bottom);
        make.left.equalTo(self.contentView).with.offset(k_Margin);
        make.right.equalTo(self.contentView).with.offset(-k_Margin);
        make.bottom.equalTo(self.content.bottom);
    }];
    [self setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    if (self.gradientMask && self.gradientMask.hidden == NO) {
        self.gradientMask.hidden = YES;
    }
}

-(void)hideContent
{
    [self.content remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, cellEstimateHeight-titleLabelHeight-timeLabelHeight-10));
        make.top.equalTo(self.timeLabel.bottom);
        make.left.equalTo(self.contentView).with.offset(k_Margin);
        make.right.equalTo(self.contentView).with.offset(-k_Margin);
        make.bottom.equalTo(self.content.bottom);
    }];
    [self setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    if (!self.gradientMask.superview) {
        [self.contentView addSubview:self.gradientMask];
    }
    if (self.gradientMask.hidden == YES) {
        self.gradientMask.hidden = NO;
    }
}

@end
