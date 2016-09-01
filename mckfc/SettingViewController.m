//
//  SettingViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/19.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginNav.h"
#import "QualityControlHomePage.h"
#import "SecurityHomePage.h"

@implementation SettingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view = self.tableView;
    
    self.title = @"系统设置";
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setting"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"setting" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            cell.textLabel.text = @"修改密码";
        }
        if (indexPath.row ==1) {
            cell.textLabel.text = @"退出登录";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginNav* loginVC = [[LoginNav alloc] init];
    UIViewController* vc = self.navigationController.viewControllers[0];

    if ([vc isKindOfClass:[QualityControlHomePage class]]) {
        QualityControlHomePage* qcvc = (QualityControlHomePage*)vc;
        qcvc.user = nil;
    }
    else if ([vc isKindOfClass:[SecurityHomePage class]])
    {
        SecurityHomePage* sc = (SecurityHomePage*)vc;
        sc.user = nil;
    }
    [self presentViewController:loginVC animated:NO completion:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"user_type"];
        [defaults removeObjectForKey:@"access_token"];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    if(indexPath.row == 0)
    {
        [loginVC navigateToFogotPass];
    }
}

@end
