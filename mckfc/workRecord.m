//
//  workRecord.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "workRecord.h"

@implementation workRecord

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"driver":@"driver",
             @"recordid":@"id",
             @"reportArray":@"report",
             @"storename":@"storename",
             @"transportno":@"transportno",
             @"truckno":@"truckno"};
}

@end
