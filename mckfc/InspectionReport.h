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
@property (nonatomic, strong) NSNumber* status;

@property (nonatomic,assign) BOOL checkbig;
@property (nonatomic,assign) BOOL checkbug;
@property (nonatomic,assign) BOOL checkcolor;
@property (nonatomic,assign) BOOL checkdry;
@property (nonatomic,assign) BOOL checkearth;
@property (nonatomic,assign) BOOL checkgreen;
@property (nonatomic,assign) BOOL checkhollow;
@property (nonatomic,assign) BOOL checkhurt;
@property (nonatomic,assign) BOOL checkinner;
@property (nonatomic,assign) BOOL checkmal;
@property (nonatomic,assign) BOOL checkmix;
@property (nonatomic,assign) BOOL checkother;
@property (nonatomic,assign) BOOL checkrot;
@property (nonatomic,assign) BOOL checkscab;
@property (nonatomic,assign) BOOL checksmall;
@property (nonatomic,assign) BOOL checkwet;
@end
