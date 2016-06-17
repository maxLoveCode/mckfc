//
//  DriverDetailEditorController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverDetailEditorController.h"
#import "DriverDetailEditorCell.h"
#import "ServerManager.h"

@interface DriverDetailEditorController()
{
    NSArray* titleText;
    NSArray* detailText;
    NSInteger index;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ServerManager* server;

@end

@implementation DriverDetailEditorController

-(void)viewDidLoad
{
    self.title = @"车主信息";
    titleText = @[@"头像",
                  @"车牌号",
                  @"司机姓名",
                  @"身份证",
                  @"驾驶证号",
                  @"行驶证号"];
    
    detailText = @[@"",
                   @"请输入6位车牌号",
                   @"请输入司机姓名",
                   @"请输入18位身份证号",
                   @"请输入驾驶证号",
                   @"请输入行驶证号"];
    
    _server = [ServerManager sharedInstance];
    
    [self.tableView registerClass:[DriverDetailEditorCell class] forCellReuseIdentifier:@"editor"];
    
    [self.view addSubview:self.tableView];
    
#pragma mark gestures
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

#pragma mark navigationItem
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style: UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, [DriverDetailEditorCell heightForCell]*6) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

#pragma mark UITableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DriverDetailEditorCell heightForCell];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell;
    if (indexPath.row ==0 ) {
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleAvatar reuseIdentifier:@"editor"];
    }
    else if(indexPath.row ==1){
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleCarNumber reuseIdentifier:@"editor"];
    }
    else{
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStylePlain reuseIdentifier:@"editor"];
    }
    
    NSString* title = [titleText objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    
    NSString* detail = [detailText objectAtIndex:indexPath.row];
    if (![detail isEqualToString:@""]) {
        cell.detailLabel.text = detail;
        cell.detailLabel.delegate = self;
        cell.detailLabel.tag = indexPath.row;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString* detail = [detailText objectAtIndex:textField.tag];
    if ([textField.text isEqualToString:detail]) {
        textField.text = @"";
    }
    index = textField.tag;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* detail = [detailText objectAtIndex:textField.tag];
    if ([textField.text isEqualToString:@""]) {
        textField.text = detail;
    }
}

#pragma mark gesture
-(void)dismissKeyboard
{
    if (index!=0) {
        DriverDetailEditorCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell.detailLabel resignFirstResponder];
    }
}

#pragma mark save info
-(void)save
{
//    NSString* token;
//    NSString* carNo;
//    NSString* driverName;
//    NSString* carID;
//    NSString* driverNo;
//    NSString* licenseNo;
//    NSDictionary* params = @{
//                             @"token":token,
//                             @"carNo":carNo,
//                             @"driverName":driverName,
//                             @"carID":carID,
//                             @"driverNo":driverNo,
//                             @"licenseNo":licenseNo};
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
