//
//  queueViewModel.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "queueViewModel.h"

@implementation queueViewModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"currenttime":@"currenttime",
             @"expecttime":@"expecttime",
             @"factoryphone":@"factoryphone",
             @"queue":@"queue",
             @"queueno":@"queueno",
             @"reportArray":@"report",
             @"store":@"store",
             @"storename":@"storename",
             @"time":@"time",
             };
}

@end
