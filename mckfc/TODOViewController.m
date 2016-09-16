//
//  TODOViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#import "WorkRecordViewController.h"
#import "WorkRecordCell.h"
#import "WorkDetailViewController.h"

#import "ServerManager.h"

#import "workRecord.h"
#import "TODOViewController.h"

extern NSString *const reuseIdentifier;

@interface TODOViewController()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSString* keyWord;
}

@property (nonatomic, strong) UITableView* tableView;


@property (strong, nonatomic) ServerManager* server;

@property (nonatomic, strong) NSArray* recordArray;
@property (nonatomic, strong) NSMutableArray* searchResult;
@end


@implementation TODOViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.title = @"今日待办";
    
    _server = [ServerManager sharedInstance];
    
    keyWord = nil;
    [self addSearchController];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestList];
}

#pragma mark setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        NSString *const reuseIdentifier = @"workRecord";
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

#pragma mark UITableview controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(keyWord!= nil && ![keyWord isEqualToString:@""] )
    {
        return [_searchResult count];
    }
    else
        return [_recordArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkRecordCell *cell = [[WorkRecordCell alloc] init];
    if(keyWord!= nil && ![keyWord isEqualToString:@""])
    {
        cell.record = _searchResult[indexPath.section];
    }
    else
    {
        cell.record = _recordArray[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark heights;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WorkRecordCell HeightForWorkRecordCell];
}

#pragma mark selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WorkRecordCell class]]) {
        WorkDetailViewController* detail = [[WorkDetailViewController alloc] init];
        workRecord* record;
        if(keyWord!= nil && ![keyWord isEqualToString:@""])
        {
            record = _searchResult[indexPath.section];
        }
        else
        {
            record = _recordArray[indexPath.section];
        }
        [detail setTransportid: [NSString stringWithFormat:@"%@",record.recordid]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark web request
-(void)requestList
{
    NSDictionary* params = @{@"token":_server.accessToken};
    [_server GET:@"getOrderList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSError* error;
        NSArray* data = responseObject[@"data"];
        NSLog(@"data:%@",data);
        _recordArray = [MTLJSONAdapter modelsOfClass:[workRecord class] fromJSONArray:data error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Add Search controller
-(void)addSearchController
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchBarAnimate:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    keyWord = searchText;
    if (keyWord && ![keyWord isEqualToString:@""]) {
        [self search];
    }
    else
    {
        [self.tableView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    keyWord = nil;
    [self.tableView reloadData];
}

-(void)search
{
    _searchResult = [[NSMutableArray alloc] init];
    for (workRecord* record in _recordArray) {
        if ([record matchAccordingToKey:keyWord]) {
            [_searchResult addObject:record];
        }
    }
    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tap)];
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    mask.tag = 88;
    [mask addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:mask];
}

-(void)tap
{
    for (UIView* view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if (view.tag == 88) {
            [view removeFromSuperview];
        }
    }
    [self.navigationController.view endEditing:YES];
}


-(void)searchBarAnimate:(id)sender
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5.0, 0.0, 300.0, 44.0)];
    if ([self.navigationItem.titleView isKindOfClass:[UIView class]]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationItem.titleView = NULL;
        }];
        keyWord = nil;
        [self.tableView reloadData];
    }
    else
    {
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
        searchBarView.autoresizingMask = 0;
        [searchBar setTranslucent:YES];
        [searchBar setTintColor:[UIColor clearColor]];
        searchBar.backgroundImage = [UIImage new];
        [searchBar setBackgroundColor:[UIColor clearColor]];
        searchBar.delegate = self;
        [searchBarView addSubview:searchBar];
        [searchBar setFrame:CGRectMake(250.0, 0.0, 50.0, 44.0)];
        [UIView animateWithDuration:0.5 animations:^{
            [searchBar setFrame:CGRectMake(5.0, 0.0, 300.0, 44.0)];
        }];
        if(keyWord!= nil && ![keyWord isEqualToString:@""] )
        {
            searchBar.text = keyWord;
        }
        self.navigationItem.titleView = searchBarView;
    }
}

@end
