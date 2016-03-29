//
//  HotUpdateManager.h
//  YwenHybridIos
//
//  Created by ywen on 15/12/29.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import <Foundation/Foundation.h>


//热更新
#define UPDATE_FOLDER [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"update"]  //存放www的升级目录

#define kUserDefault_hotUpdateVersion @"hotUpdateVersion"   //userdefault中存储的www版本号

#define ItunesUrl @"https://itunes.apple.com/lookup?id="

#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@protocol HotUpdateDelegate <NSObject>

@required
//热更新
-(void) checkHotUpdate;
-(void) hotUpdateDone;
//appstore程序更新
-(void) hasNewVerion:(NSString *) updateUrl;
@end

@interface HotUpdateManager : NSObject

+(HotUpdateManager *)sharedInstance;

@property (weak, nonatomic) id<HotUpdateDelegate> delegate;
@property (strong, nonatomic) NSString *appID;

-(void) downloadFile:(NSString *) url wwwVersion:(NSString *) wwwVersion;
-(NSString *) wwwPath;
-(void) checkUpdate;

@end
