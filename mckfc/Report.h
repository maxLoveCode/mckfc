//
//  Report.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Report : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSDictionary* weight;

@property (nonatomic, copy) NSString* arrivetime;
@property (nonatomic, copy) NSString* departuretime;
@property (nonatomic, copy) NSNumber* transportid;

@property (nonatomic, assign) BOOL isrefuse;
@property (nonatomic, copy) NSString* refusecause;

@property (nonatomic, copy) NSNumber* totaldistance;

@property (nonatomic, copy) NSString* totalTime;


+(NSInteger)numberOfProperties;

@end
