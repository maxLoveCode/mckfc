//
//  ServerManager.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ServerManager.h"
#import "GifLoadingHUD.h"
#import "AlertHUDView.h"

#ifdef DEBUG
#define _BASE_URL @"http://120.26.41.98/"
#else
#define _BASE_URL @"http://120.26.41.98/"
#endif

NSString *const b_URL = _BASE_URL;
NSString *const version = @"v1_0";

@interface ServerManager ()<HUDViewDelegate>

@property AlertHUDView *alert;

@end

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

#pragma mark http GET
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
   animated:(BOOL)animated
    success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
    failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    self.successCode = 10000;
    
    if (ServerDebugLog) {
        NSLog(@"GET: %@", [self appendedURL:URLString]);
    }
    if (animated) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleNetworking];
        _alert.delegate = self;
        [_alert show:_alert];
    }
    [self GET:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        if (ServerDebugLog) {
            NSLog(@"code:%@  info:%@  successcode %lu",responseObject[@"code"],responseObject[@"msg"], (unsigned long)self.successCode);
        }
        if (animated) {
            if ([responseObject[@"code"] integerValue] == self.successCode) {
                [_alert dismiss:_alert];
            }
            else
            {
                
            }
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
    self.successCode = 10000;
    
    if (ServerDebugLog) {
        NSLog(@"POST: %@", [self appendedURL:URLString]);
    }
    if (animated) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleNetworking];
        _alert.delegate = self;
        [_alert show:_alert];
    }
    [self POST:[self appendedURL:URLString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    //show animates
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        if (ServerDebugLog) {
            NSLog(@"code:%@  info:%@  successcode %lu",responseObject[@"code"],responseObject[@"msg"], (unsigned long)self.successCode);
        }
        if (animated) {
            if ([responseObject[@"code"] integerValue] == self.successCode) {
                [_alert dismiss:_alert];
            }
            else
            {
                [_alert failureWithMsg:_alert msg:responseObject[@"msg"]];
            }
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

-(void)didSelectConfirm
{
    if (self.alert) {
        [self.alert removeFromSuperview];
    }
}
@end

