//
//  YwenViewController.h
//  YwenHybridIos
//
//  Created by ywen on 15/11/18.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HybridDelegate <NSObject>

@required
-(void) callFromJs:(NSString *) tag params:(NSDictionary *) params callback:(NSString *) callback;

@end

@interface YwenViewController : UIViewController <UIWebViewDelegate, HybridDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *htmlPath;

-(void) callJS:(NSString *) msg;
-(void) releaseWebView;

@end
