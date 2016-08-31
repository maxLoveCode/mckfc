//
//  RedPocketButton.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "RedPocketButton.h"
#define animationTime 0.25

@implementation RedPocketButton
{
    UIView* background;
}

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
    [self attachRedPocketView];
}

-(void)attachRedPocketView
{
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [background setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [[UIApplication sharedApplication].keyWindow addSubview:background];
    
    UIImageView* detail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPocketDetail"]];
    [background addSubview:detail];
    [detail setFrame:CGRectMake(0, -kScreen_Width, kScreen_Width, kScreen_Width)];
    detail.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [detail addGestureRecognizer:tap];
    
    [UIView animateWithDuration:animationTime animations:^{
        [detail setFrame:CGRectMake(0, kScreen_Height/2, kScreen_Width, kScreen_Width)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animationTime+0.1 animations:^{
            [detail setFrame:CGRectMake(0, kScreen_Height/2-kScreen_Width/2-40, kScreen_Width, kScreen_Width)];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:animationTime-0.1 animations:^{
                [detail setFrame:CGRectMake(0, kScreen_Height/2-kScreen_Width/2, kScreen_Width, kScreen_Width)];
            }];
        }];
    }];
}

-(void)dismiss:(id)sender
{
    [background removeFromSuperview];
}

@end
