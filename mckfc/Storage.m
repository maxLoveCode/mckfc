//
//  Storage.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/20.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "Storage.h"

@implementation Storage
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"storageid":@"id",
             @"name":@"name"};
}

-(NSString *)description
{
    return self.name;
}

+(NSValueTransformer *)storageidJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber* number = (NSNumber*)value;
        return [NSString stringWithFormat:@"%@",number];
    }];
}
@end
