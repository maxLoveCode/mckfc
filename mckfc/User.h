//
//  User.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/13.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *truckno;  //车牌号
@property (nonatomic, copy) NSString *driver; //司机姓名
@property (nonatomic, copy) NSString *idcard;  //身份证
@property (nonatomic, copy) NSString *driverno; //驾驶证号

@property (nonatomic, copy) NSString* region; //地区部分
@property (nonatomic, copy) NSString* cardigits; //数字部分

@property (nonatomic, copy) NSString *licenseno; //行驶证号

//the user statistics
@property (nonatomic, assign) NSNumber *totalmile;
@property (nonatomic, assign) NSNumber *totalweight;
@property (nonatomic, assign) NSNumber *transporttime;

@property (nonatomic, copy) NSString *avatar; //头像
@property (nonatomic, assign) NSUInteger star; //评星

//user enumerate type
//check constant file for the enumerate list
@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, assign) NSUInteger transportstatus;
@property (nonatomic, assign) NSUInteger transportid;

//if needs to read the factory
@property (nonatomic, copy) NSString* factorynotes;

@property (nonatomic, copy) NSString* redrule;
@property (nonatomic, copy) NSString* reward;

-(instancetype)init;

-(BOOL)validation;

@end
