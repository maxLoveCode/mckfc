//
//  WorkRecordViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkRecordViewController.h"
#import "WorkRecordCell.h"
#import <JTCalendar/JTCalendar.h>
#import "WorkDetailViewController.h"

extern NSString *const reuseIdentifier;

@interface WorkRecordViewController()<UITableViewDelegate, UITableViewDataSource,JTCalendarDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic, strong) JTCalendarMenuView *calendarMenuView;
@property (nonatomic, strong) JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) UIView* calendarWrapperView;

@end

@implementation WorkRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.title = @"今日待办";
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
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workRecord"];
        
        [cell.contentView addSubview:self.calendarWrapperView];
        return cell;
    }
    else
    {
        WorkRecordCell *cell = [[WorkRecordCell alloc] init];
    
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

@end
