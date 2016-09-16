//
//  MsgTableViewCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MsgTableViewCell : UITableViewCell
{
    NSString* reuseID;
}

@property (nonatomic, strong) Message* message;

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* content;
@property (nonatomic, strong) UILabel* timeLabel;

@property (nonatomic, strong) UIView* gradientMask;

@property (nonatomic, assign) BOOL expand;

+ (CGFloat)heightForCell;
+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
- (CGFloat)fullTextHeight;

@end
