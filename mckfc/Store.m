//
//  Store.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Store.h"

@implementation Store

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"storeID":@"id",
             @"name":@"name"};
}

-(NSString *)description
{
    return self.name;
}


@end
