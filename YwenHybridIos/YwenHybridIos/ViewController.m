//
//  ViewController.m
//  YwenHybridIos
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "ViewController.h"
#import "HelloViewController.h"
#import <YwenKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView.backgroundColor = [UIColor redColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
    self.htmlPath = path;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"calljs" style:UIBarButtonItemStyleDone target:self action:@selector(testCallJs)];
    self.navigationItem.rightBarButtonItem = btn;
    
    self.hybridNav = self;
    self.hybridUI = self;
}

-(void)callFromJs:(NSString *)tag params:(NSDictionary *)params callback:(NSString *)callback {
    [super callFromJs:tag params:params callback:callback];
    if ([tag isEqualToString:@"testSuccess"]) {
        [self success:callback params:@{@"name": @"ywen"}];
    }
}

-(void)navPop:(NSInteger)index {
    NSInteger vcCount = self.navigationController.viewControllers.count;
    if (index < vcCount - 1) {
        UIViewController *toVC = self.navigationController.viewControllers[vcCount - 2 - index];
        [self.navigationController popToViewController:toVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)navPush:(NSDictionary *)params callback:(NSString *)callback {
    NSString *page = [params objectForKey:@"page"];
    if ([page isEqualToString:@"hello"]) {
        HelloViewController *helloVC = [HelloViewController new];
        [self.navigationController pushViewController:helloVC animated:YES];
    }
    [self success:callback params:@{}];
}


-(void)alert:(NSDictionary *)params callback:(NSString *)callback {
    NSString *title = [params objectForKey:@"title"];
    NSString *msg = [params objectForKey:@"msg"];
    NSArray *btns = [params objectForKey:@"btns"];
    
    [YwenAlert setTitle:title];
    
    __block __weak ViewController *weakSelf = self;
    
    [YwenAlert alert:msg vc:self confirmStr:btns[0] confirmCb:^{
        [weakSelf success:callback params:@{}];
    } cancelStr:btns.count > 1 ? btns[1] : @"取消" cancelCb:^{
        [weakSelf error:callback error:@"用户取消操作"];
    }];
}

-(void)toast:(NSDictionary *)params {
    NSString *type = [params objectForKey:@"type"];
    NSString *msg = [params objectForKey:@"msg"];
    NSTimeInterval time = 1.5;
    if ([params objectForKey:@"showTime"] != nil) {
        time = [[params objectForKey:@"showTime"] doubleValue];
    }
    
    if ([type isEqualToString:@"show"]) {
        NSInteger position;
        if ([[params objectForKey:@"position"] isEqualToString:@"center"]) {
            position = 0;
        }
        else
        {
            position = 1;
        }
        
        
        
        [Toast showToastWithContent:msg showTime:time postion:position];
    }
    else if ([type isEqualToString:@"success"])
    {
        [Toast showSuccess:msg];
    }
    else if ([type isEqualToString:@"error"])
    {
        [Toast showErr:msg];
    }
    
    
}

-(void)loading:(NSDictionary *)params {
    NSString *type = [params objectForKey:@"type"];
    NSString *msg = [params objectForKey:@"msg"];
    BOOL force = [[params objectForKey:@"force"] boolValue];
    
    if ([type isEqualToString:@"hide"]) {
        [Loading hide];
    }
    else
    {
        [Loading setTimeout:10];
        [Loading show:msg isForce:force];
        
    }
    
    
}

-(void) testCallJs {
    NSDictionary *params = @{
                             @"msg": @"hello hybrid!"
                             };
    
    [self callJS: params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
