//
//  ServerManager.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ServerManager.h"
#import "GifLoadingHUD.h"

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
        [GifLoadingHUD setGifWithImages:@[[UIImage imageNamed:@"gifloading_0"],[UIImage imageNamed:@"gifloading_1"],[UIImage imageNamed:@"gifloading_2"]]];
    });
    
    return sharedInstance;
}

- (NSString*)appendedURL:(NSString*)url
{
    return [NSString stringWithFormat:@"%@/%@", version, url];
}

#pragma mark http GET
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
   animated:(BOOL)animated
    success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
    failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    if (ServerDebugLog) {
        NSLog(@"GET: %@", [self appendedURL:URLString]);
    }
    if (animated) {
        [GifLoadingHUD showWithOverlay];
    }
    [self GET:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        if (ServerDebugLog) {
            NSLog(@"code:%@  info:%@",responseObject[@"code"],responseObject[@"msg"]);
        }
        if (animated) {
            [GifLoadingHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
        if (ServerDebugLog) {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark http POST
- (void)POST:(NSString * _Nonnull)URLString
  parameters:(nullable id)parameters
    animated:(BOOL)animated
     success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    if (ServerDebugLog) {
        NSLog(@"POST: %@", [self appendedURL:URLString]);
    }
    if (animated) {
        [GifLoadingHUD showWithOverlay];
    }
    [self POST:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    //show animates
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        if (ServerDebugLog) {
            NSLog(@"code:%@  info:%@",responseObject[@"code"],responseObject[@"msg"]);
        }
        if (animated) {
            [GifLoadingHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
        if (ServerDebugLog) {
            NSLog(@"%@",error);
        }
    }];
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

