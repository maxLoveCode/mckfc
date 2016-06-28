//
//  ServerManager.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ServerManager : AFHTTPSessionManager

@property (nonatomic, copy)  NSString* _Nonnull accessToken;
@property (nonatomic, assign) NSUInteger successCode;


extern NSString  * _Nonnull const b_URL;
extern NSString  * _Nonnull const version;

+ (_Nonnull id)sharedInstance;
- (NSString* _Nonnull)appendedURL:(NSString* _Nonnull)url;

- (void)POST:(NSString * _Nonnull)URLString
          parameters:(nullable id)parameters
            animated:(BOOL)animated
             success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
             failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)GET:(NSString * _Nonnull)URLString
 parameters:(nullable id)parameters
   animated:(BOOL)animated
    success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)upLoadImageData:(UIImage * _Nonnull)image forSize:(CGSize)size
                success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end

