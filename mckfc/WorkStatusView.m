//
//  WorkStatusView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkStatusView.h"

#define highlighted COLOR_WithHex(0x565656)
#define normal COLOR_TEXT_GRAY

@interface WorkStatusView()
{
    NSArray *titleArray;
}

@end

@implementation WorkStatusView

-(instancetype)init
{
    self = [super init];
    
    titleArray = @[@"到厂",@"进厂",@"卸货",@"质检",@"出厂"];
    CGFloat labelWidth = 30;
    CGFloat viewWidth = kScreen_Width - 2*k_Margin;
    CGFloat spacing = (viewWidth-labelWidth*5)/(5-1);
    for (NSInteger i =0; i<5 ; i++) {
        UILabel* label = [[UILabel alloc] init];
        CGRect labelFrame = CGRectMake((spacing+labelWidth)*i, 0, labelWidth, 25);
        [label setFrame:labelFrame];
        label.tag = 100+i;
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = COLOR_TEXT_GRAY;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIImageView* imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(CGRectGetMidX(label.frame)-8, CGRectGetMaxY(label.frame)-2, 16, 16)];
        imageView.image = [UIImage imageNamed:@"uncheck"];
        imageView.tag = 1000+i;
        [self addSubview:imageView];
        
        if(i!=4)
        {
            UIView* cons = [[UIView alloc] init];
            [cons setFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, CGRectGetMidY(imageView.frame), spacing-10, 1)];
            [cons setBackgroundColor:COLOR_THEME];
            [self addSubview:cons];
        }
    }
    return self;
}

@end
