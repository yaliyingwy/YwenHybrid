//
//  YwenViewController.m
//  YwenHybridIos
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "YwenViewController.h"
#import "NSDictionary+YwenJson.h"

@interface YwenViewController ()

@end

@implementation YwenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [UIWebView new];
    _webView.frame = self.view.bounds;
    _webView.delegate = self;
    
    
     self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:_webView];
}

-(void)setHtmlPath:(NSString *)htmlPath {
    _htmlPath = htmlPath;
    NSURL *url = [NSURL URLWithString:htmlPath];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    if ([url.scheme isEqualToString:@"ywen"]) {
        NSArray *queryList = [[url.query stringByRemovingPercentEncoding] componentsSeparatedByString:@"&"];
        NSString *paramStr = [queryList[0] componentsSeparatedByString:@"="][1];
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[paramStr dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        NSString *callback = nil;
        
        if (queryList.count > 1) {
            callback = [queryList[1] componentsSeparatedByString:@"="][1];
        }
        
        [self callFromJs:url.host params:params callback:callback];
        
        return NO;
    }
    else
    {
        return YES;
    }
    
}

-(void)callFromJs:(NSString *)tag params:(NSDictionary *)params callback:(NSString *)callback {
    
    NSLog(@"tag: %@, params: %@, callback: %@", tag, params, callback);
    if ([tag isEqualToString:@"pop"]) {
        [self.hybridNav navPop:[[params objectForKey:@"index"] integerValue]];
    }
    else if ([tag isEqualToString:@"push"])
    {
        [self.hybridNav navPush:params callback:callback];
    }
    else if ([tag isEqualToString:@"alert"])
    {
        [self.hybridUI alert:params callback:callback];
    }
    else if ([tag isEqualToString:@"loading"])
    {
        [self.hybridUI loading:params];
    }
    else if ([tag isEqualToString:@"toast"])
    {
        [self.hybridUI toast:params];
    }
    
    
}


-(void)success:(NSString *)callback params:(NSDictionary *)params {
    NSString *js;
    if (params != nil) {
        NSDictionary *paramDic = @{
                                   @"code": @"0000",
                                   @"params": params
                                   };
        NSString *json = [paramDic ywenJson];
        js = [NSString stringWithFormat:@"(function(){window.ywenHybrid.cbs['%@']('%@')})()", callback, json];
    }
    else
    {
        js = [NSString stringWithFormat:@"(function(){window.ywenHybrid.cbs['%@']()})()", callback];
    }
   
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)error:(NSString *)callback error:(NSString *)error {
    NSDictionary *paramDic = @{
                               @"code": @"0001",
                               @"error": error ? error : @"error"
                               };
    NSString *json = [paramDic ywenJson];
    NSString *js = [NSString stringWithFormat:@"(function(){window.ywenHybrid.cbs['%@']('%@')})()", callback, json];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

-(void)releaseWebView {
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    self.webView = nil;
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self isMovingFromParentViewController] || [self isBeingDismissed]) {
        [self releaseWebView];
    }
}

-(void)callJS:(NSDictionary *)params {
    NSString *msg = [params ywenJson];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ywenHybrid.callJs('%@')", msg]];
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
