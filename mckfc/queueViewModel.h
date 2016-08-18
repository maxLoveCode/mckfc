//
//  queueViewModel.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface queueViewModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* currenttime;
@property (nonatomic, strong) NSString* expecttime;
@property (nonatomic, strong) NSString* factoryphone;
@property (nonatomic, strong) NSString* queue;
@property (nonatomic, strong) NSString* queueno;
@property (nonatomic, strong) NSNumber* queueid;
@property (nonatomic, strong) NSArray* reportArray;
@property (nonatomic, strong) NSString* store;
@property (nonatomic, strong) NSString* storename;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* queuenotes;

@end
