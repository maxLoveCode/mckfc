//
//  LoadingStats.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/29.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LoadingStats : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *supplier;

@property (nonatomic, copy) NSString *placeNo;
@property (nonatomic, strong) NSMutableDictionary *inspections;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSString *extraInfo;

-(instancetype)init;

@end
