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
             
             @"avatar":@"avatar",
             @"mobile":@"mobile",
             @"truckno":@"truckno",
             @"driver":@"driver",
             @"idcard":@"idcard",
             @"driverno":@"driverno",
             @"licenseno":@"licenseno",
             @"star":@"star",
             
             @"totalmile":@"totalmile",
             @"totalweight":@"totalweight",
             @"transporttime":@"transporttime"
             };
}

-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"totalmile"]) {
        self.totalmile = 0;
    } else if ([key isEqualToString:@"totalweight"]) {
        self.totalweight = 0;
    } else if([key isEqualToString:@"transporttime"]){
        self.transporttime = 0;
    }else {
        [super setNilValueForKey:key];
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"User: %@", [MTLJSONAdapter JSONArrayFromModels:@[self] error:nil]];
}

-(BOOL)validation
{
   if ([self.truckno isEqualToString: @""] || !self.truckno)
   {
        return NO;
   }
   else
        return YES;
}

@end
