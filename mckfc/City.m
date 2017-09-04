//
//  City.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "City.h"
#import "MTLJSONAdapter.h"

@implementation City

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"areaid":@"id",
             @"name":@"name",
             @"time":@"time"};
}

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    self.name = name;
    return self;
}

+(NSValueTransformer *)areaidJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if([value isKindOfClass:[NSNumber class]])
        {
            NSNumber* number = (NSNumber*)value;
            return [NSString stringWithFormat:@"%@",number];
        }
        else
            return value;
    }];
}

-(NSString *)description
{
    return self.name;
}

@end
