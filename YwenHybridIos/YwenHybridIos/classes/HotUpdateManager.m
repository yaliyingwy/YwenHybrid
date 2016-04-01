//
//  HotUpdateManager.m
//  YwenHybridIos
//
//  Created by ywen on 15/12/29.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "HotUpdateManager.h"
#import "ZipArchive.h"


@implementation HotUpdateManager

+(HotUpdateManager *)sharedInstance {
    static HotUpdateManager *hotUpdateManager = nil;
    @synchronized(self) {
        if (hotUpdateManager == nil) {
            hotUpdateManager = [[self alloc] init];
            NSDictionary *hotUpdateDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_hotUpdateVersion];
            NSString *hotVersion = [hotUpdateDic objectForKey:CURRENT_VERSION];
            hotUpdateManager.currentHotVersion = hotVersion;
        }
    }
    return hotUpdateManager;
}

-(void)rollBack {
    // 简单粗暴的回滚掉热更新
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefault_hotUpdateVersion];
    _currentHotVersion = nil;
}

-(void)cleanOldHotFiles {
    NSLog(@"clear old files: %@", UPDATE_FOLDER);
    // 移除老版本的热更新文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (_currentHotVersion == nil) {
        if ([fileManager fileExistsAtPath:UPDATE_FOLDER]) {
            [fileManager removeItemAtPath: UPDATE_FOLDER  error:nil];
        }
        
    } else {
        NSError *error = nil;
        
        for (NSString *file in [fileManager contentsOfDirectoryAtPath:UPDATE_FOLDER error:&error]) {
            if (![file hasPrefix:_currentHotVersion]) {
                BOOL success = [fileManager removeItemAtPath:[UPDATE_FOLDER stringByAppendingPathComponent: file] error:&error];
                if (!success || error) {
                    NSLog(@"remove file failded %@, %@", file, error);
                }
            }
        }
    }
    
}

-(void)checkUpdate {
    NSString *urlStr = [ItunesUrl stringByAppendingString:self.appID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([infoDic isKindOfClass:[NSDictionary class]]) {
                NSArray *results = [infoDic objectForKey:@"results"];
                if ([results isKindOfClass:[NSArray class]]) {
                    NSDictionary *dic = results[0];
                    NSString *version = [dic objectForKey:@"version"];
                    NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
                    NSLog(@"version: %@, currentVersion: %@", version, CURRENT_VERSION);
                   
                    if ([version compare:CURRENT_VERSION] == NSOrderedDescending) {
                        [self.delegate hasNewVerion:trackViewUrl];
                    }
                }
            }
            
            
        }
    }];
    [task resume];
    
}



-(void)downloadFile:(NSString *)url wwwVersion:(NSString *)wwwVersion {
    //    下载zip文件
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSInteger statusCode = ((NSHTTPURLResponse *) response).statusCode;

        if (error == nil || statusCode > 299 || statusCode < 200) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:UPDATE_FOLDER]) {
                BOOL ret = [fm createDirectoryAtPath:UPDATE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
                if (!ret) {
                    NSLog(@"创建热更新目录失败");
                    return;
                }
            }
            
            NSString *zip = [UPDATE_FOLDER stringByAppendingPathComponent:@"hot.zip"];
            
            
            [data writeToFile:zip atomically:YES];
            
            
            NSString *www = [UPDATE_FOLDER stringByAppendingPathComponent:wwwVersion];
            
            if ([fm fileExistsAtPath:www]) {
                [fm removeItemAtPath: www error:nil];
            }
            ZipArchive *za = [[ZipArchive alloc] init];
            [za UnzipOpenFile:zip];
            BOOL result = [za UnzipFileTo: www overWrite: YES];
            [za UnzipCloseFile];
            if (!result) {
                NSLog(@"解压zip失败 %@", UPDATE_FOLDER);
                return;
            }
            
            NSDictionary *hotUpdateDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_hotUpdateVersion];
            if (hotUpdateDic == nil) {
                hotUpdateDic = @{};
            }
            NSMutableDictionary *newUpdateDic = [hotUpdateDic mutableCopy];
            [newUpdateDic setObject:wwwVersion forKey:CURRENT_VERSION];
            [[NSUserDefaults standardUserDefaults] setObject:newUpdateDic forKey:kUserDefault_hotUpdateVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"##### 热更新完成 下次启动使用最新程序 ####");
            [self.delegate hotUpdateDone];
        }
    }];
    
    [task resume];
    
}

-(void)ErrorMessage:(NSString *)msg {
    NSLog(@"zip error msg: %@", msg);
}

-(NSString *)wwwPath {
    if (_currentHotVersion != nil) {
        return [[UPDATE_FOLDER stringByAppendingPathComponent:_currentHotVersion] stringByAppendingPathComponent:@"www"];
    }
    else
    {
        return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"www"];
    }
}

@end
