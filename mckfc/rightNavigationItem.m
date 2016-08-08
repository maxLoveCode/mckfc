//
//  rightNavigationItem.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#define itemHeight 44
#define menuWidth 140

#import "rightNavigationItem.h"

@interface rightNavigationItem () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL show;

@end

@implementation rightNavigationItem

-(instancetype)initCutomItem
{
    self = [super initWithImage:[UIImage imageNamed:@"popUp"] style:UIBarButtonItemStyleDone target:self action:@selector(selectBtn:)];
    _show = NO;
    self.ItemStyle = navItemStyleTransport;
    return self;
}

-(UITableView *)popMenu
{
    if (!_popMenu) {
        _popMenu = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width-menuWidth, 64, menuWidth, itemHeight*2) style:UITableViewStylePlain];
        [_popMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menu"];
        _popMenu.dataSource = self;
        _popMenu.delegate = self;
        [_popMenu setBackgroundColor:COLOR_WithHex(0xf3f3f3)];
        _popMenu.scrollEnabled = NO;
    }
    return _popMenu;
}

-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
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
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(k_Margin/2, 0, itemHeight, itemHeight)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, menuWidth-k_Margin, itemHeight)];
    if (self.ItemStyle == navItemStyleTransport) {
        if (indexPath.row == 0) {
            label.text = @"取消订单";
            imageView.image = [UIImage imageNamed:@"menuCancel"];
        }
        else
        {
            label.text = @"联系工厂";
            imageView.image = [UIImage imageNamed:@"menuPhone"];
        }

    }
    else
    {
        if (indexPath.row == 0) {
            label.text = @"扫二维码";
            imageView.image = [UIImage imageNamed:@"生成二维码"];
        }
        else
        {
            label.text = @"退出登录";
            imageView.image = [UIImage imageNamed:@"menuPhone"];
        }
    }
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = COLOR_WithHex(0x565656);
    label.textAlignment = NSTextAlignmentRight;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:imageView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return itemHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate MenuView:self selectIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)selectBtn:(id)sender
{
    if (_show) {
        [self dismiss];
    }
    else{
        _show = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.mask];
        [[UIApplication sharedApplication].keyWindow addSubview:self.popMenu];
    }
}

-(void)dismiss
{
    if (_show) {
        [self.popMenu removeFromSuperview];
        [self.mask removeFromSuperview];
        _show = NO;
    }
}


@end
