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
             @"serialno":@"serialno",
             @"packagename":@"packagename",
             @"varietyname":@"varietyname",
             @"storagetime":@"storagetime",
             @"locationpointy":@"locationpointy",
             @"locationpointx":@"locationpointx"
             };
}

-(void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"weight"]) {
        self.weight = 0;
    }
    else
        [super setNilValueForKey:key];
}

@end
