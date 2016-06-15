//
//  ServerManager.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ServerManager.h"

#ifdef DEBUG
#define _BASE_URL @"http://120.26.41.98/"
#else
#define _BASE_URL @"http://120.26.41.98/"
#endif

NSString *const b_URL = _BASE_URL;
NSString *const version = @"v1_0";

@implementation ServerManager

+ (id)sharedInstance {
    static dispatch_once_t once;
    static ServerManager *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] initWithBaseURL: [NSURL URLWithString:b_URL]];
    });
    
    return sharedInstance;
}

- (NSString*)appendedURL:(NSString*)url
{
    return [NSString stringWithFormat:@"%@/%@", version, url];
}

- (void)AnimatedGET:(NSString *)URLString
         parameters:(id)parameters
            success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
            failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    if ([self accessibility]) {
        [self GET:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
            
        }];
    }
}

- (void)AnimatedPOST:(NSString *)URLString
          parameters:(id)parameters
             success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
             failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    if ([self accessibility]) {
        [self POST:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //show animates
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    }
}

-(BOOL)accessibility
{
    if (!self.accessToken) {
        return NO;
    }
    else
        return YES;
}
@end

