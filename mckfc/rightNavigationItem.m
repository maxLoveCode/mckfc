//
//  rightNavigationItem.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#define itemHeight 44

#import "rightNavigationItem.h"

@implementation rightNavigationItem

-(instancetype)initCutomItem
{
    self = [super initWithImage:[UIImage imageNamed:@"check"] style:UIBarButtonItemStyleDone target:self action:@selector(selectBtn:)];
    return self;
}

-(UITableView *)popMenu
{
    if (!_popMenu) {
        _popMenu = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width-180-k_Margin, 0, 180, itemHeight*2) style:UITableViewStylePlain];
        [_popMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menu"];
        _popMenu.dataSource = self;
        _popMenu.delegate = self;
    }
    return _popMenu;
}

-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_mask addSubview:self.popMenu];
        [_mask addGestureRecognizer:tap];
    }
    return _mask;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemHeight, itemHeight)];
    imageView.image = [UIImage imageNamed:@"check"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, itemHeight)];
    label.text = @"取消订单";
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:imageView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
}

-(void)selectBtn:(id)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
}

-(void)dismiss
{
    [self.mask removeFromSuperview];
}


@end
