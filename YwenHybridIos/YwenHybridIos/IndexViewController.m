//
//  IndexViewController.m
//  YwenHybridIos
//
//  Created by ywen on 15/12/10.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "IndexViewController.h"
#import "ViewController.h"
#import <YwenKit.h>

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, 300, 50)];
    [btn WY_SetBgColor:0x000000 title:@"点击跳转至事例页面" titleColor:0xffffff corn:2 fontSize:18];
    
    [btn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void) goNext {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
