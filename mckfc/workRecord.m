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

-(BOOL)matchAccordingToKey:(NSString*)key
{
    return [self.driver containsString:key] ||
            ([self.recordid integerValue] == [key integerValue]) ||
            [self.storename containsString:key] ||
            [self.transportno containsString:key] ||
            [self.truckno containsString:key];
}

@end
