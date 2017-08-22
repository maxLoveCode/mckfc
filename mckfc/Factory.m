//
//  Factory.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/19.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Factory.h"

@implementation Factory

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"factoryid":@"id",
             @"name":@"name",
             @"pointx":@"pointx",
             @"pointy":@"pointy"};
}

-(NSString *)description
{
    return self.name;
}

+(NSValueTransformer *)factoryidJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber* number = (NSNumber*)value;
        return [NSString stringWithFormat:@"%@",number];
    }];
}


@end
