//
//  FarmerViewModel.h
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Success)(NSString *msg);
typedef void(^Error)(NSString *msg);
@interface FarmerViewModel : NSObject
@property (nonatomic, strong) NSArray *dataSource;
- (void)getTruckListData:(NSString *)field :(Success)success;
- (void)getarrivedFieldData:(NSString *)field :(Success)success error:(Error) error;
- (void)uploadFieldImage:(NSString *)fielduserid drivernum:(NSString*)drivernum urls:(NSString *)urls success:(Success)success;
@end
