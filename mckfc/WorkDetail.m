//
//  WorkDetail.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkDetail.h"

@implementation WorkDetail

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"avatar":@"avatar",
             @"departuretime":@"departuretime",
             @"planarrivetime":@"planarrivetime",
             @"driver":@"driver",
             @"fieldno":@"fieldno",
             @"mobile":@"mobile",
             @"report":@"report",
             @"transportid":@"transportid",
             @"weight":@"weight",
             @"transportno":@"transportno",
             @"truckno":@"truckno",
             @"vendorname":@"vendorname",
             };
}

@end
