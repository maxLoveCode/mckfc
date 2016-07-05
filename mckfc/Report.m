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
    return @{@"weight":@"weight",
             @"quality":@"quality"
             };
}

+(NSInteger)numberOfProperties
{
    return 2;
    //return [[[MTLJSONAdapter JSONDictionaryFromModel:[Report class] error:nil] allKeys] count];
}

@end
