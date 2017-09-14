//
//  WorkDetail.h
//  mckf@"":@"",c
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WorkDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, copy) NSString* departuretime;
@property (nonatomic, copy) NSString* planarrivetime;
@property (nonatomic, copy) NSString* driver;
@property (nonatomic, copy) NSString* fieldno;
@property (nonatomic, copy) NSString* mobile;

@property (nonatomic, copy) NSArray* report;

@property (nonatomic, copy) NSNumber* transportid;
@property (nonatomic, copy) NSNumber* weight;
@property (nonatomic, copy) NSNumber *locationpointy;
@property (nonatomic, copy) NSNumber *locationpointx;

@property (nonatomic, copy) NSString* transportno;
@property (nonatomic, copy) NSString* truckno;
@property (nonatomic, copy) NSString* vendorname;
@property (nonatomic, copy) NSString* serialno;
@property (nonatomic, copy) NSString* packagename;
@property (nonatomic, copy) NSString* varietyname;

@property (nonatomic, copy) NSString* storagetime;

@end
