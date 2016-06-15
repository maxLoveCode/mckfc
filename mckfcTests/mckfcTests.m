//
//  mckfcTests.m
//  mckfcTests
//
//  Created by 华印mac-001 on 16/6/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface mckfcTests : XCTestCase

@property (nonatomic, strong) User* user;

@end

@implementation mckfcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary *JSONDictionary = @{
                                     @"driverName": @"john",
                                     @"mobile": @"13816279957"
                                     };
    _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:JSONDictionary error:nil];
    NSLog(@"%@",[_user description]);
    XCTAssertNotNil(_user, @"loginVC should contain a view");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
