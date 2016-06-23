//
//  User.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/13.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "User.h"

@implementation User

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mobile":@"mobile",
             @"carNo":@"carNo",
             @"driverName":@"driverName",
             @"cardID":@"cardId",
             @"driverNo":@"driverNo",
             @"licenseNo":@"licenseNo",
             @"star":@"star"};
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"User: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}

-(BOOL)validation
{
    return YES;
}

@end
