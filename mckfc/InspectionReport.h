//
//  InspectionReport.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface InspectionReport : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* comments;
@property (nonatomic, copy) NSString* refusecause;
@property (nonatomic, copy) NSString* result;
@property (nonatomic, assign) NSNumber* status;

@end
