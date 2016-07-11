//
//  Field.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Field.h"

@implementation Field

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"fieldID":@"id",
             @"name":@"name"};
}

-(NSString *)description
{
    return self.name;
}

@end
