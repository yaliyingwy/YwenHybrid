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

@protocol HotUpdateDelegate <NSObject>

@required
-(void) checkHotUpdate;

@end

@interface HotUpdateManager : NSObject

+(void) downloadFile:(NSString *) url wwwVersion:(NSString *) wwwVersion;
+(NSString *) wwwPath;

@end
