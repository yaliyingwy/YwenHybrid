//
//  YwenHybridIosTests.m
//  YwenHybridIosTests
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YwenViewController.h"

@interface YwenHybridIosTests : XCTestCase

@end

@implementation YwenHybridIosTests

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
    YwenViewController *vc = [YwenViewController new];
    vc.htmlPath = @"http://www.baidu.com";
    vc.params = @{@"name": @"ywen"};
    [vc loadPage];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
