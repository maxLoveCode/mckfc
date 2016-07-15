//
//  WorkFlow.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkFlow.h"

@implementation WorkFlow

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"content":@"content",
             @"time":@"time",
             @"title":@"title",
             @"type":@"type",
             @"auth":@"auth",
             @"ischecked":@"ischecked"};
}

@end
