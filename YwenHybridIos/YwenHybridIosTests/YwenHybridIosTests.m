//
//  YwenHybridIosTests.m
//  YwenHybridIosTests
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YwenViewController.h"
#import "HotUpdateManager.h"


@interface YwenHybridIosTests : XCTestCase <HotUpdateDelegate>
@property (strong, nonatomic) dispatch_semaphore_t sem;

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
    vc.params = @{@"name": @"ywen", @"cn": @"嘉陵江"};
    [vc loadPage];
}

-(void) testUpdate {
    HotUpdateManager *updater = [HotUpdateManager sharedInstance];
    updater.appID = @"1002017965";
    updater.delegate = self;
    self.sem = dispatch_semaphore_create(0);
    [updater checkUpdate];
    
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
}

-(void) testHotUpdate {
    [self checkHotUpdate];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)hasNewVerion:(NSString *)updateUrl {
    NSLog(@"updateUrl: %@", updateUrl);
    dispatch_semaphore_signal(self.sem);
}

-(void)checkHotUpdate {
    HotUpdateManager *updater = [HotUpdateManager sharedInstance];
    updater.delegate = self;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefault_hotUpdateVersion];
    self.sem = dispatch_semaphore_create(0);
    NSLog(@"www path before: %@", [updater wwwPath]);
    [updater downloadFile:@"http://192.168.29.45:8001/update?version=0.0.1" wwwVersion:@"0.0.1"];
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
}

-(void)hotUpdateDone {
    NSLog(@"hot update done, www path %@", [[HotUpdateManager sharedInstance] wwwPath]);
    dispatch_semaphore_signal(self.sem);
    
}

@end
