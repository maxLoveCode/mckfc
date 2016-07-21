//
//  Report.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Report.h"

@implementation Report
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"arrivetime":@"arrivetime",
             @"departuretime":@"departuretime",
             @"transportid":@"id",
             @"isrefuse":@"isrefuse",
             @"refusecause":@"refusecause",
             @"totaldistance":@"totaldistance",
             @"totalTime":@"totaltime",
             @"weight":@"weight",
             @"refusestatus":@"refusestatus"
             };
}

+(NSInteger)numberOfProperties
{
    return 1;
}

@end
