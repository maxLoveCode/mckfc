//
//  Package.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Package.h"

@implementation Package

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"packageid":@"id",
             @"name":@"name"};
}

-(NSString *)description
{
    return self.name;
}

+(NSValueTransformer *)packageidJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber* number = (NSNumber*)value;
        return [NSString stringWithFormat:@"%@",number];
    }];
}

@end
