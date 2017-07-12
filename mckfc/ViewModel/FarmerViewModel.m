//
//  FarmerViewModel.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/12.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerViewModel.h"
#import "ServerManager.h"
#import <YYModel.h>
#import "TruckListModel.h"
@interface FarmerViewModel()
@property (nonatomic, strong) ServerManager *server;
@end

@implementation FarmerViewModel
- (void)getTruckListData:(NSString *)field :(Success)success{
    self.server = [ServerManager sharedInstance];
    [_server GET:@"getTruckList" parameters:@{@"token":_server.accessToken,@"fieldid":field} animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *json = responseObject[@"data"];
        self.dataSource = [NSArray yy_modelArrayWithClass:[TruckListModel class] json:json];
        success(responseObject[@"msg"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)getarrivedFieldData:(NSString *)field :(Success)success error:(Error)error{
    self.server = [ServerManager sharedInstance];
    [_server POST:@"arriveField" parameters:@{@"token":_server.accessToken,@"fieldid":field} animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
         success(responseObject[@"msg"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
    }];

}


@end
