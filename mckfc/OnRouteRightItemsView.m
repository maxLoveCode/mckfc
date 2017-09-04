//
//  OnRouteRightItemsView.m
//  mckfc
//
//  Created by zc on 2017/8/28.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#define itemHeight 44
#define menuWidth 140
#import "OnRouteRightItemsView.h"

@interface OnRouteRightItemsView()<UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate>

@end

@implementation OnRouteRightItemsView


- (UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        [_markView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_markView addGestureRecognizer:tap];
    }
    return _markView;
}

-(UITableView *)popMenu
{
    if (!_popMenu) {
        CGFloat height;
            height = itemHeight*2;
        _popMenu = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width-menuWidth, 64, menuWidth, height) style:UITableViewStylePlain];
        [_popMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menu"];
        _popMenu.dataSource = self;
        _popMenu.delegate = self;
        [_popMenu setBackgroundColor:COLOR_WithHex(0xf3f3f3)];
        _popMenu.scrollEnabled = NO;
    }
    return _popMenu;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_Margin/2, 0, itemHeight, itemHeight)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, menuWidth-k_Margin, itemHeight)];
        if (indexPath.row == 0) {
            label.text = @"联系客服";
            imageView.image = [UIImage imageNamed:@"menuPhone"];
        }else{
            label.text = @"退出登录";
            imageView.image = [UIImage imageNamed:@"司机姓名"];
    }
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = COLOR_WithHex(0x565656);
    label.textAlignment = NSTextAlignmentRight;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.menuDelegate && [self.menuDelegate respondsToSelector:@selector(callPhone)]) {
            [self.menuDelegate callPhone];
        }
    }else{
        if (self.menuDelegate && [self.menuDelegate respondsToSelector:@selector(exitView)]) {
            [self.menuDelegate exitView];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return itemHeight;
}


- (void)addSubViews{
    [[UIApplication sharedApplication].keyWindow addSubview:self.markView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popMenu];
    
}

- (void)removeSubViews{
    [self.popMenu removeFromSuperview];
    [self.markView removeFromSuperview];
}

-(void)dismiss
{
    [self.popMenu removeFromSuperview];
    [self.markView removeFromSuperview];
}

@end
