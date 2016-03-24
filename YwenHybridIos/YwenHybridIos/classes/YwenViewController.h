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

@required



@end

@protocol HybridNavDelegate <NSObject>

@required
-(void) navPop:(NSInteger) index;
-(void) navPush:(NSDictionary *) params callback:(NSString *) callback;

@end

@protocol HybridCommandDelegate <NSObject>

-(void) commanFromJs:(NSString *) tag params:(NSDictionary *) params callback:(NSString *) callback;

@end

@protocol HybridUIDelegate <NSObject>

@required
-(void) alert: (NSDictionary *) params callback:(NSString *) callback;
-(void) toast: (NSDictionary *) params;
-(void) loading: (NSDictionary *) params;


@end


@interface YwenViewController : UIViewController <UIWebViewDelegate, HybridDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *htmlPath;
@property (strong, nonatomic) NSDictionary *params;
@property (weak, nonatomic) id<HybridNavDelegate> hybridNav;
@property (weak, nonatomic) id<HybridUIDelegate> hybridUI;
@property (weak, nonatomic) id<HybridCommandDelegate> hybridCommand;

-(void) loadPage;
-(void) callJS:(NSDictionary *) params;
-(void) releaseWebView;
-(void) success: (NSString *) callback params: (NSDictionary *) params;
-(void) error: (NSString *) callback error: (NSString *) error;

@end
