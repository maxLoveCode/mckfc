//
//  InspectionReport.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "InspectionReport.h"

@implementation InspectionReport

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"comments":@"comments",
             @"refusecause":@"refusecause",
             @"result":@"result",
             @"status":@"refusestatus"};
}


@end
