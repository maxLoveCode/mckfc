//
//  TransportDetail.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TransportDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *departuretime; //发运时间
@property (nonatomic, copy) NSString *destination; //运输目的地
@property (nonatomic, copy) NSString *planarrivetime; //预计到达时间
@property (nonatomic, copy) NSString *planentertime; //计算卸货时间
@property (nonatomic, copy) NSNumber *pointx; //额外信息
@property (nonatomic, copy) NSNumber *pointy; //额外信息

@property (nonatomic, assign) NSInteger transportID; //id

@property (nonatomic, copy) NSString *factoryphone;

-(instancetype)initWithID:(NSInteger)transportID;

@end
