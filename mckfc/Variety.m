//
//  Variety.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/20.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Variety.h"

@implementation Variety
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"varietyid":@"id",
             @"name":@"name"};
}

-(NSString *)description
{
    return self.name;
}

+(NSValueTransformer *)varietyidJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber* number = (NSNumber*)value;
        return [NSString stringWithFormat:@"%@",number];
    }];
}
@end
