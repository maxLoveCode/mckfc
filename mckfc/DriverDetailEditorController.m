//
//  DriverDetailEditorController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverDetailEditorController.h"
#import "DriverDetailEditorCell.h"

@implementation DriverDetailEditorController

-(void)viewDidLoad
{
    [self.tableView registerClass:[DriverDetailEditorCell class] forCellReuseIdentifier:@"editor"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell = [tableView dequeueReusableCellWithIdentifier:@"editor" forIndexPath:indexPath];
    return cell;
}

@end
