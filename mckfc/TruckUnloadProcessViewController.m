//
//  TruckUnloadProcessViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TruckUnloadProcessViewController.h"
#import "LoadingCell.h"
#import "ServerManager.h"
#import "TruckArrivePicker.h"
#define itemHeight 44
#define buttonHeight 40
#define topMargin 60
#define buttonWidth kScreen_Width-4*k_Margin

@interface TruckUnloadProcessViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UIButton *comeBtn;

@end

@implementation TruckUnloadProcessViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirm];
    [self.confirm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom).with.offset(20);
        make.size.equalTo(CGSizeMake(buttonWidth, buttonHeight));
        make.centerX.equalTo(self.view);
    }];
    if ([self.workFlow.type isEqualToString:@"enter"]) {
        self.title = @"进厂称重";
        [self.tableView setFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*2+30)];
    }
    else
    {
        self.title = @"出厂称重";
        self.netWeight = [NSNumber numberWithFloat:0];
        self.finalWeight = [NSNumber numberWithFloat:0];
        [self.tableView setFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*4+30)];
    }
    self.weight = [NSNumber numberWithFloat:0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _server = [ServerManager sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.workFlow.type isEqualToString:@"leave"]) {
        [self requestEnterWeightSuccess:^{
            [self.tableView reloadData];
        }];
    }
}

- (UIButton *)enterBtn{
    if (!_enterBtn) {
        self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.frame = CGRectMake(20, 0, 150, itemHeight);
        _enterBtn.enabled = NO;
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formater stringFromDate:[NSDate date]];
        [ _enterBtn setTitle:dateString forState:UIControlStateNormal];
        [_enterBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _enterBtn;
}

- (UIButton *)comeBtn{
    if (!_comeBtn) {
        self.comeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _comeBtn.frame = CGRectMake(20, 0, 150, itemHeight);
        _comeBtn.enabled = NO;
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString* dateString = [formater stringFromDate:[NSDate date]];
        [ _comeBtn setTitle:dateString forState:UIControlStateNormal];
        [_comeBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        _comeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _comeBtn;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*3+20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"weight"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalcell"];
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确认" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
        //[_confirm setFrame:CGRectMake(2*k_Margin,topMargin+CGRectGetMaxY(self.tableView.frame),buttonWidth , buttonHeight)];
        [_confirm addTarget:self action:@selector(didConfirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.workFlow.type isEqualToString:@"enter"]) {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.workFlow.type isEqualToString:@"enter"]) {
        return 2;
    }
    else
    {
        if (section ==0) {
            return 1;
        }
        else
        {
            return 3;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [[LoadingCell alloc] init];
    cell.style = LoadingCellStyleDigitInput;
    if ([self.workFlow.type isEqualToString:@"enter"]) {
        if(indexPath.row == 0){
            cell.titleLabel.text = @"土豆重量";
            cell.digitInput.tag = 1;
            cell.digitInput.text = [NSString stringWithFormat:@"%@",_weight];
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
            [cell.contentView addSubview:self.enterBtn];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    else
    {
        if(indexPath.section == 0)
        {
            cell.titleLabel.text = @"进厂重量";
            cell.digitInput.tag = 1;
            cell.digitInput.text = [NSString stringWithFormat:@"%@",_weight];
        }
        else
        {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"出厂重量";
                cell.digitInput.tag = 2;
                
                cell.digitInput.text = [NSString stringWithFormat:@"%@",_finalWeight];
            }
            else if(indexPath.row == 1)
            {
                cell.titleLabel.text = @"净重";
                cell.digitInput.tag = 3;
                cell.digitInput.text = [NSString stringWithFormat:@"%@",_netWeight];
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
                [cell.contentView addSubview:self.comeBtn];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    cell.leftImageView.image = [UIImage imageNamed:@"土豆重量"];
    cell.digitInput.delegate = self;
    [cell.digitInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.workFlow.type isEqualToString:@"enter"]){
        if (indexPath.row == 1) {
            [self arrivedTruck:NO];
        }
    }else{
        if (indexPath.section == 1 && indexPath.row == 2) {
            [self arrivedTruck:YES];
        }
    }
}

#pragma mark header and footers
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark send confirm
-(void)didConfirm:(id)sender
{
    [self.tableView endEditing:YES];
    NSString* type;
    NSDictionary* params;
    if ([self.workFlow.type isEqualToString:@"enter"]) {
        type = @"truckEnter";
        params = @{@"token":_server.accessToken,
                   @"enterweight":_weight,
                   @"transportid":self.transportid,
                   @"entertime": [_enterBtn currentTitle]};
    }
    else
    {
        type = @"truckLeave";
        params = @{@"token":_server.accessToken,
                   @"enterweight":_weight,
                   @"leaveweight":_finalWeight,
                   @"netweight":_netWeight,
                   @"transportid":self.transportid,
                   @"leavetime": [_comeBtn currentTitle]};
    }
    NSLog(@"params%@", params);
    [_server POST:type parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark uitextfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    float weight = [textField.text floatValue];
    switch (textField.tag) {
        case 1:
            self.weight = [NSNumber numberWithFloat:weight];
            break;
        case 2:
            self.finalWeight = [NSNumber numberWithFloat:weight];
            break;
        case 3:
            self.netWeight = [NSNumber numberWithFloat:weight];
            break;
        default:
            break;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}

-(void)textFieldDidChange :(UITextField *) textField{
    //your code
    float weight = [textField.text floatValue];
    switch (textField.tag) {
        case 1:
            self.weight = [NSNumber numberWithFloat:weight];
            break;
        case 2:
            self.finalWeight = [NSNumber numberWithFloat:weight];
            break;
        case 3:
            self.netWeight = [NSNumber numberWithFloat:weight];
            break;
        default:
            break;
    }
}

-(void)requestEnterWeightSuccess:(void(^)(void))success
{
    [_server GET:@"getEnterWeight" parameters:@{@"transportid":self.transportid,
                                               @"token":_server.accessToken} animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                                                   if ((self.weight = [responseObject[@"data"] objectForKey:@"enterweight"])) {
                                                       success();
                                                   }
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   }];
}

#pragma mark- 车辆到厂
- (void)arrivedTruck:(BOOL)isArrived
{
   
    TruckArrivePicker* picker = [[TruckArrivePicker alloc] init];
    [picker show];
    __weak typeof(self) weakSelf = self;
    [picker setSelectBlock:^(NSDate *result) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formater stringFromDate:result];
        if (isArrived == NO) {
            [ weakSelf.enterBtn setTitle:dateString forState:UIControlStateNormal];
        }else{
            [weakSelf.comeBtn setTitle:dateString forState:UIControlStateNormal];
        }
      
    }];
    
}

@end
