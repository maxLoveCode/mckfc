//
//  HomepageViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface HomepageViewController : UIViewController

@property (assign, nonatomic) BOOL didLogin;
@property (assign, nonatomic) BOOL didEditProfile;

@property (nonatomic, strong) User* user;

@end
