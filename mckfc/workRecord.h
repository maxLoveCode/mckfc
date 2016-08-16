//
//  workRecord.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface workRecord : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* driver;
@property (nonatomic, strong) NSNumber* recordid;
@property (nonatomic, strong) NSArray* reportArray;
@property (nonatomic, strong) NSString* storename;
@property (nonatomic, strong) NSString* transportno;
@property (nonatomic, strong) NSString* truckno;

-(BOOL)matchAccordingToKey:(NSString*)key;

@end
