//
//  RedPocketButton.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "RedPocketButton.h"

@implementation RedPocketButton

-(instancetype)init
{
    self = [super init];
    [self setImage:[UIImage imageNamed:@"redPocket"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)attachToView:(UIView*)view
{
    [view addSubview:self];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 60));
        make.right.equalTo(view.right).with.offset(-10);
        make.bottom.equalTo(view.bottom).with.offset(-20);
    }];
}

-(void)didTapButton:(id)sender
{
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [background setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [[UIApplication sharedApplication].keyWindow addSubview:background];
    
    UIImageView* detail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPocketDetail"]];
    [background addSubview:detail];
    [detail makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width, kScreen_Width));
        make.centerX.equalTo(background.centerX);
        make.centerY.equalTo(background.centerY);
    }];
}

@end
