//
//  HomepageViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserView.h"
#import "ServerManager.h"
#import "LoginNav.h"
#import "LoadingStatsViewController.h"
#import "DriverDetailEditorController.h"

#import "TranspotationPlanViewController.h"
#import "QueueViewController.h"
#import "MsgListViewController.h"

#import "EditorNav.h"

#import "JPushService.h"

#import "rightNavigationItem.h"
#import "QRCodeReaderViewController.h"

#import "LoadingStats.h"
#import "nofityViewController.h"
#import "AlertHUDView.h"

#import "RedPocketButton.h"

@interface HomepageViewController : UIViewController

@property (assign, nonatomic) BOOL didLogin;
@property (assign, nonatomic) BOOL didEditProfile;

@property (nonatomic, strong) User* user;

@end
