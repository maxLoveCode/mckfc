//
//  WorkRecordViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
// 历史记录页面，比代办多了一个日历

#import "WorkRecordViewController.h"
#import "WorkRecordCell.h"
#import <JTCalendar/JTCalendar.h>
#import "WorkDetailViewController.h"

#import "ServerManager.h"

#import "workRecord.h"

extern NSString *const reuseIdentifier;

@interface WorkRecordViewController()<UITableViewDelegate, UITableViewDataSource,JTCalendarDelegate, UISearchBarDelegate>
{
    NSString* keyWord;
}

@property (nonatomic, strong) UITableView* tableView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic, strong) JTCalendarMenuView *calendarMenuView;
@property (nonatomic, strong) JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) UIView* calendarWrapperView;

@property (strong, nonatomic) NSDate* selected;

@property (strong, nonatomic) ServerManager* server;

@property (nonatomic, strong) NSArray* recordArray;
@property (nonatomic, strong) NSMutableArray* searchResult;
@end

@implementation WorkRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.title = @"今日待办";
    
    _selected = [NSDate date];
    _server = [ServerManager sharedInstance];
    if(!_recordArray)
    {
        [self requestListWithDate:_selected];
    }
    
    keyWord = nil;
    [self addSearchController];
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

-(UIView*)calendarWrapperView
{
    if (!_calendarWrapperView) {
        _calendarWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, [WorkRecordCell HeightForWorkRecordCell])];
        _calendarManager = [JTCalendarManager new];
        self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
        self.calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarMenuView.frame), kScreen_Width, [WorkRecordCell HeightForWorkRecordCell]-CGRectGetMaxY(self.calendarMenuView.frame))];
        
        _calendarManager.delegate = self;
        [_calendarManager setMenuView:_calendarMenuView];
        [_calendarManager setContentView:_calendarContentView];
        [_calendarManager setDate:[NSDate date]];
        _calendarManager.settings.weekModeEnabled = YES;
        [_calendarManager reload];
        
        [_calendarWrapperView addSubview:self.calendarContentView];
        [_calendarWrapperView addSubview:self.calendarMenuView];
    }
    return _calendarWrapperView;
}

#pragma mark UITableview controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(keyWord!= nil && ![keyWord isEqualToString:@""] )
    {
        return 1+[_searchResult count];
    }
    else
        return 1+[_recordArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workRecord"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.calendarWrapperView];
        return cell;
    }
    else
    {
        WorkRecordCell *cell = [[WorkRecordCell alloc] init];
        if(keyWord!= nil && ![keyWord isEqualToString:@""])
        {
            cell.record = _searchResult[indexPath.section-1];
        }
        else
        {
            cell.record = _recordArray[indexPath.section-1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
        workRecord* record = _recordArray[indexPath.section-1];
        [detail setTransportid: [NSString stringWithFormat:@"%@",record.recordid]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark JTCalendar delegates
/*!
 * Used to customize the menuItemView.
 * Set text attribute to the name of the month by default.
 */
- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
{
    NSString *text = nil;
    
    if(date){
        NSCalendar *calendar = _calendarManager.dateHelper.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        
        static NSDateFormatter *dateFormatter = nil;
        if(!dateFormatter){
            dateFormatter = [_calendarManager.dateHelper createDateFormatter];
        }
        
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        
        text = [NSString stringWithFormat:@"%ld年 %@", (long)comps.year, [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString]];
    }
    
    UILabel* menu = (UILabel *)menuItemView;
    menu.textColor = COLOR_WithHex(0x565656);
    [(UILabel *)menuItemView setText:text];
}

#pragma mark prepare the date view
- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    view.textLabel.textColor = [UIColor blackColor];
    
    [view.circleView setBackgroundColor:[UIColor redColor]];
    return view;
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(UIView<JTCalendarDay> *)dayView
{
    NSDate* date = dayView.date;
    JTCalendarDayView* view = (JTCalendarDayView*) dayView;
    if ([calendar.dateHelper date:date isTheSameDayThan:_selected]) {
        view.textLabel.textColor= [UIColor whiteColor];
        view.circleView.hidden = NO;
    }
    else
    {
        view.textLabel.textColor= COLOR_WithHex(0x565656);
        view.circleView.hidden = YES;
    }
}

-(void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView
{
    
    if ([calendar.dateHelper date:dayView.date isTheSameDayThan:[NSDate date]])
    {
        self.navigationItem.title = @"今日待办";
    }
    else if([calendar.dateHelper date:dayView.date isEqualOrBefore:[NSDate date]])
    {
        self.navigationItem.title = @"历史记录";
    }
    else
    {
        self.navigationItem.title = @"工作计划";
    }
    
    self.selected = dayView.date;
    [self requestListWithDate:dayView.date];
        
    [calendar reload];
}

#pragma mark web request
-(void)requestListWithDate:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"date":dateString};
    [_server GET:@"getHistoryList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSError* error;
       // NSLog(@"%@",responseObject[@"data"]);
        NSDictionary* data = responseObject[@"data"];
        _recordArray = [MTLJSONAdapter modelsOfClass:[workRecord class] fromJSONArray:data[@"array"] error:&error];
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
    NSLog(@"%@",searchText);
    keyWord = searchText;
    if (keyWord && ![keyWord isEqualToString:@""]) {
        [self search];
    }
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
