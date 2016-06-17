//
//  DriverDetailEditorController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverDetailEditorController.h"
#import "DriverDetailEditorCell.h"

@interface DriverDetailEditorController()
{
    NSArray* titleText;
    NSArray* detailText;
}

@end

@implementation DriverDetailEditorController

-(void)viewDidLoad
{
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
    
    [self.tableView registerClass:[DriverDetailEditorCell class] forCellReuseIdentifier:@"editor"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

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
    }
    
    return cell;
}

@end
