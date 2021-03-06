//
//  NewInspectionController.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/24.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "NewInspectionController.h"
#import "AlertHUDView.h"
#import "CauseRejectionViewController.h"
#import "ServerManager.h"
#import "InspectionReport.h"
#import "MakeConcessionsViewController.h"
@interface NewInspectionController ()<HUDViewDelegate>
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) InspectionReport* insepection;
@property (nonatomic, assign) BOOL checkTrueAndUplineBool;

@end
static NSString *NormalecellID = @"NormalecellID";
@implementation NewInspectionController{
    NSArray *_titleArr;
    NSArray *_imgArr;
    AlertHUDView *_alert;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkTrueAndUplineBool = YES;
    self.navigationItem.title = @"质检报告";
    self.tableView.rowHeight = 60;
    _server = [ServerManager sharedInstance];
    _titleArr = @[@"合格",@"拒收",@"让步接受",@"上线"];
    _imgArr = @[@"checktrue",@"checkfalse",@"让步接受",@"上线"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NormalecellID];
    [self showAlert];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestInspectionReport];
    
}

- (void)showAlert{
    _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleBool
              ];
    _alert.delegate = self;
    _alert.title.text = @"质检合格";
    _alert.detail.text = @"土豆质检合格";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    grayView.backgroundColor = COLOR_WithHex(0xdddddd);
    return grayView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NormalecellID];
    cell.imageView.image = [UIImage imageNamed:_imgArr[indexPath.section]];
    cell.textLabel.text = _titleArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";
    if (self.ischecked == YES) {
    if (indexPath.section == 0) {
        if ([_insepection.status isEqualToNumber:@0]){
            cell.detailTextLabel.text = @"验收合格";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }else if (indexPath.section == 1){
        if ([_insepection.status isEqualToNumber:@1]){
            cell.detailTextLabel.text = @"验收不合格";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }else if (indexPath.section ==2){
        if ([_insepection.status isEqualToNumber:@2]){
            cell.detailTextLabel.text = @"让步接受";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }else if (indexPath.section == 3){
        if ([_insepection.status isEqualToNumber:@3]){
            cell.detailTextLabel.text = @"已上线";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if ([self.type isEqualToString:self.mainType]) {
            _alert.title.text = @"质检合格";
            _alert.detail.text = @"土豆质检合格";
            self.checkTrueAndUplineBool = YES;
             [_alert show:_alert];
        }
    }
    if (indexPath.section == 1 ){
        CauseRejectionViewController *con = [[CauseRejectionViewController alloc] init];
        con.mainType = self.mainType;
        con.type = self.type;
        con.insepection = _insepection;
        con.transportid = self.transportid;
        [self.navigationController pushViewController:con animated:NO];
    }
    if (indexPath.section == 2) {
        MakeConcessionsViewController *makeCon = [[MakeConcessionsViewController alloc] init];
        makeCon.mainType = self.mainType;
        makeCon.type = self.type;
        makeCon.insepection = _insepection;
        makeCon.transportid = self.transportid;
        [self.navigationController pushViewController:makeCon animated:NO];
    }
    if (indexPath.section == 3) {
         if ([self.type isEqualToString:self.mainType]) {
        self.checkTrueAndUplineBool = NO;
        _alert.title.text = @"土豆质检";
        _alert.detail.text = @"是否上线";
        [_alert show:_alert];
        }
    }
}

- (void)didSelectConfirm{
    for(int idx = 0; idx < 16; idx++){
        BOOL isclick = NO;
        switch (idx) {
            case 0:
                _insepection.checkcolor = isclick;
                break;
            case 1:
                _insepection.checkmal = isclick;
                break;
            case 2:
                _insepection.checkdry = isclick;
                break;
            case 3:
                _insepection.checkrot = isclick;
                break;
            case 4:
                _insepection.checkgreen = isclick;
                break;
            case 5:
                _insepection.checkwet = isclick;
                break;
            case 6:
                _insepection.checkscab = isclick;
                break;
            case 7:
                _insepection.checksmall = isclick;
                break;
            case 8:
                _insepection.checkbug = isclick;
                break;
            case 9:
                _insepection.checkbig = isclick;
                break;
            case 10:
                _insepection.checkmix = isclick;
                break;
            case 11:
                _insepection.checkearth = isclick;
                break;
            case 12:
                _insepection.checkinner = isclick;
                break;
            case 13:
                _insepection.checkhurt = isclick;
                break;
            case 14:
                _insepection.checkhollow = isclick;
                break;
            case 15:
                _insepection.checkother = isclick;
                break;
            default:
                break;
        }
    }
    _insepection.refusecause = @"";
    if (self.checkTrueAndUplineBool == YES) {
        _insepection.status = @0;
    }else{
        _insepection.status = @3;
    }
    
    NSMutableDictionary* params =[[NSMutableDictionary alloc] initWithDictionary: [MTLJSONAdapter JSONDictionaryFromModel:_insepection error:nil]];
     [params addEntriesFromDictionary:@{@"type":self.mainType,
                                       @"token":_server.accessToken,
                                       @"transportid":self.transportid}];
    NSLog(@"-----params%@", params);
    [_server POST:@"truckCheck" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        self.ischecked = YES;
        NSLog(@"++++++%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [_alert dismiss:_alert];
}

#pragma mark -- 获得质检报告
-(void)requestInspectionReport
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"type":self.type,
                             @"transportid":self.transportid};
    [_server GET:@"getCheckReport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"responsObject%@", responseObject);
        _insepection = [MTLJSONAdapter modelOfClass:[InspectionReport class] fromJSONDictionary:responseObject[@"data"] error:nil];
        if ([_insepection.status isEqualToNumber:@1] || [_insepection.status isEqualToNumber:@2]) {
            self.ischecked = YES;
        }
        NSLog(@"%@",_insepection);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
