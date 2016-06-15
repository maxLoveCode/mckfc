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

@property (nonatomic, copy) NSString *carNo;  //车牌号
@property (nonatomic, copy) NSString *driverName; //司机姓名
@property (nonatomic, copy) NSString *cardID;  //身份证
@property (nonatomic, copy) NSString *driverNo; //驾驶证号
@property (nonatomic, copy) NSString *licenseNo; //行驶证号

@end
