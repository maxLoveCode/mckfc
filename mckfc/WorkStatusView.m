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
    CGFloat width;
}

@end

@implementation WorkStatusView

-(instancetype)init
{
    self = [super init];
    

    return self;
}

-(void)setData:(NSArray *)data
{
    self->_data = data;
    
    CGFloat labelWidth = 36;
    if (width == 0) {
        width = kScreen_Width - 2*k_Margin;
    }
    CGFloat viewWidth = width;
    CGFloat spacing = (viewWidth-labelWidth*[data count])/([data count]-1);
    for (NSInteger i =0; i<[data count] ; i++) {
        UILabel* label = [[UILabel alloc] init];
        CGRect labelFrame = CGRectMake((spacing+labelWidth)*i, 0, labelWidth, 25);
        [label setFrame:labelFrame];
        label.tag = 100+i;
        label.text = [_data[i] objectForKey:@"title"];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = COLOR_TEXT_GRAY;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIImageView* imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(CGRectGetMidX(label.frame)-8, CGRectGetMaxY(label.frame)-2, 16, 16)];
        if ([[_data[i] objectForKey:@"ischecked"] integerValue] == 0) {
            imageView.image = [UIImage imageNamed:@"uncheck"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"check"];
        }
        imageView.tag = 1000+i;
        [self addSubview:imageView];
        
        if(i!=[data count]-1)
        { 
            UIView* cons = [[UIView alloc] init];
            [cons setFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, CGRectGetMidY(imageView.frame), spacing-10, 1)];
            [cons setBackgroundColor:COLOR_THEME];
            [self addSubview:cons];
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    width = frame.size.width;
}

@end
