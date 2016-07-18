//
//  InspectionViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "InspectionViewController.h"
#import "LoadingCell.h"
#import "ServerManager.h"
#import "InspectionReport.h"

#import "DynamicHeightTextCell.h"
#import "rejectionSelectableCell.h"

#define itemHeight 44
#define buttonHeight 40
#define topMargin 60
#define buttonWidth kScreen_Width-4*k_Margin

@interface InspectionViewController ()<UITextViewDelegate>
{
    CGFloat inspectionResultHeight;
    CGFloat situationDetailHeight;

}

@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) UIBarButtonItem* rightItem;
@property (nonatomic, strong) InspectionReport* insepection;

@end

@implementation InspectionViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"质检报告";
    [self.view addSubview:self.tableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (!self.workFlow.auth) {
        self.tableView.allowsSelection = NO;
    }
    _server = [ServerManager sharedInstance];
    [self requestInspectionReport];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"weight"];
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
        [_confirm setFrame:CGRectMake(2*k_Margin,topMargin,buttonWidth , buttonHeight)];
    }
    return _confirm;
}

-(UIBarButtonItem *)rightItem
{
    if (!_rightItem) {
       _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成编辑" style: UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    }
    return _rightItem;
}

-(void)initializeHeight
{
    inspectionResultHeight = itemHeight*2;
    situationDetailHeight = itemHeight*2;
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, itemHeight)];
    [textView setText:_insepection.result];
    CGSize size = [textView sizeThatFits:CGSizeMake(kScreen_Width-2*k_Margin, FLT_MAX)];
    if (size.height > itemHeight) {
        inspectionResultHeight = itemHeight+size.height;
    }
    [textView setText:_insepection.comments];
    CGSize size2 = [textView sizeThatFits:CGSizeMake(kScreen_Width-2*k_Margin, FLT_MAX)];
    if (size2.height > itemHeight) {
        situationDetailHeight = itemHeight+size2.height;
    }
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==2) {
        return 1;
    }
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LoadingCell* cell = [[LoadingCell alloc] init];
            cell.style = LoadingCellStylePlain;
            if ([self.workFlow.type isEqualToString:@"checkone"]) {
                cell.titleLabel.text = @"质检一";
            }
            else
            {
                cell.titleLabel.text = @"质检二";
            }
            cell.leftImageView.image = [UIImage imageNamed:@"inspection"];
            return cell;
        }
        else if(indexPath.row ==1)
        {
            DynamicHeightTextCell* cell = [[DynamicHeightTextCell alloc] init];
            if (!self.workFlow.auth) {
                cell.contentLabel.userInteractionEnabled = NO;
            }
            cell.contentLabel.delegate = self;
            cell.titleLabel.text = @"检验成果:";
            cell.contentLabel.text = _insepection.result;
            cell.contentLabel.tag = 0;
            
            if (inspectionResultHeight > itemHeight+CGRectGetHeight(cell.contentLabel.frame)) {
                [cell.contentLabel setFrame:CGRectMake(CGRectGetMinX(cell.contentLabel.frame), CGRectGetMinY(cell.contentLabel.frame), kScreen_Width-2*k_Margin,inspectionResultHeight-itemHeight)];
            }
            
            return cell;
        }
        else
        {
            DynamicHeightTextCell* cell = [[DynamicHeightTextCell alloc] init];
            
            if (!self.workFlow.auth) {
                cell.contentLabel.userInteractionEnabled = NO;
            }
            
            cell.contentLabel.delegate = self;
            cell.titleLabel.text = @"情况说明:";
            cell.contentLabel.text = _insepection.comments;
            cell.contentLabel.tag = 1;
            
            if (situationDetailHeight > itemHeight+CGRectGetHeight(cell.contentLabel.frame)) {
                [cell.contentLabel setFrame:CGRectMake(CGRectGetMinX(cell.contentLabel.frame), CGRectGetMinY(cell.contentLabel.frame), kScreen_Width-2*k_Margin,situationDetailHeight-itemHeight)];
            }
            
            return cell;
        }
    }
    else if(indexPath.section == 1)
    {
        rejectionSelectableCell* cell = [[rejectionSelectableCell alloc] init];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"拒收部分";
            
            if([self.insepection.status integerValue] == 1)
            {
                UIImageView* view = (UIImageView*)cell.accessoryView;
                view.image = [UIImage imageNamed:@"check"];
            }
            
            return cell;
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = @"拒收全部";
            
            if([self.insepection.status integerValue] == 2)
            {
                UIImageView* view = (UIImageView*)cell.accessoryView;
                view.image = [UIImage imageNamed:@"check"];
            }
            
            return cell;
        }
        else
        {
            LoadingCell* loadingcell = [[LoadingCell alloc] init];
            loadingcell.titleLabel.text = @"拒收原因:";
            loadingcell.style = LoadingCellStyleTextField;
            loadingcell.leftImageView.image = [UIImage imageNamed:@"grayRejection"];
            loadingcell.textField.delegate = self;
            loadingcell.textField.text = self.insepection.refusecause;
            return loadingcell;
        }
    }
    else
    {
        
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:self.confirm];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return itemHeight;
        }
        else if(indexPath.row ==1){
            return inspectionResultHeight;
        }
        else
        {
            return situationDetailHeight;
        }
    }
    if (indexPath.section == 2) {
        return buttonHeight+2*topMargin;
    }
    if (indexPath.section == 1&& indexPath.row ==2) {
        return itemHeight*2;
    }
    return itemHeight;
}

#pragma mark requestReport
-(void)requestInspectionReport
{
    //NSString* type;
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"type":@"1",
                             @"transportid":self.transportid};
    [_server GET:@"getCheckReport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"responsObject%@", responseObject);
        _insepection = [MTLJSONAdapter modelOfClass:[InspectionReport class] fromJSONDictionary:responseObject[@"data"] error:nil];
        
        [self initializeHeight];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark UITextview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag != 3) {
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }
    NSIndexPath* indexPath;
    if (textView.tag == 0) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        self.rightItem.tag = 0;
    }
    else if(textView.tag == 1){
        indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        self.rightItem.tag = 1;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag !=3) {
        [self.tableView beginUpdates]; // This will cause an animated update of
        [self.tableView endUpdates];
        CGSize size = [textView sizeThatFits:CGSizeMake(kScreen_Width-2*k_Margin, FLT_MAX)];
        if (size.height <= itemHeight) {
            
        }
        else
        {
            if (textView.tag == 0) {
                inspectionResultHeight = size.height+itemHeight;
            }
            else if(textView.tag == 1){
                situationDetailHeight = size.height+itemHeight;
            }
            [textView setFrame:CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMinY(textView.frame), kScreen_Width-2*k_Margin, size.height)];
            [textView layoutIfNeeded];
        }
    }
}

-(void)dismissKeyboard:(id)sender
{
    UIBarButtonItem * button = (UIBarButtonItem*)sender;
    NSIndexPath* indexPath;
    if (button.tag == 0) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    else
    {
       indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    DynamicHeightTextCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.contentLabel endEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
