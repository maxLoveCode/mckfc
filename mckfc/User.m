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
             @"star":@"star",
             @"stats":@[@"totalMile",@"totalWeight",@"transportTime"]};
}

-(instancetype)init
{
    self = [super init];
    self.mobile = @"";
    self.carNo = @"";
    self.driverNo = @"";
    self.cardID = @"";
    self.driverName = @"";
    self.licenseNo = @"";
    self.star = 0;
    self.stats = nil;
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"User: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}

-(BOOL)validation
{
    if ([self.mobile isEqualToString:@""] || [self.carNo isEqualToString:@""]
        ||[self.driverNo isEqualToString:@""] || [self.licenseNo isEqualToString:@""]
        ||[self.cardID isEqualToString:@""]) {
        return NO;
    }
    else
        return YES;
}

@end
