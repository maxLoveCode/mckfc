//
//  LoadingStats.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/29.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LoadingStats : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *supplier; //供应商名称

@property (nonatomic, copy) NSString *placeNo; //地块编号
@property (nonatomic, copy) NSNumber *weight;
@property (nonatomic, copy) NSDate *startTime; //开始日期
@property (nonatomic, copy) NSString *extraInfo; //额外信息

-(instancetype)init;

@end
