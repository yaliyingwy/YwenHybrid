//
//  ViewController.m
//  YwenHybridIos
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "ViewController.h"

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
}

-(void) testCallJs {
    [self callJS:@"msg from native"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
