//
//  HotUpdateManager.m
//  YwenHybridIos
//
//  Created by ywen on 15/12/29.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "HotUpdateManager.h"
#import <ZipArchive.h>


@implementation HotUpdateManager

+(void)downloadFile:(NSString *)url wwwVersion:(NSString *)wwwVersion {
    //    下载zip文件
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *zipUrl = [NSURL URLWithString:url];
        NSError *error = nil;
        NSData *resdata = [NSData dataWithContentsOfURL:zipUrl options:0 error:&error];
        NSString *mainVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *latestUpdate = [NSString stringWithFormat:@"%@_%@", mainVersion, wwwVersion];
        if(!error)
        {
            NSString *targetPath = [UPDATE_FOLDER stringByAppendingPathComponent: latestUpdate];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
                NSLog(@"exit");
                //               update文件夹存在
            }else{
                BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
                if (bo) {
                    NSLog(@"update不存在 创建success");
                }else{
                    NSLog(@"update不存在 创建faile");
                    return;
                }
            }
            //            设置下载zip文件路径
            NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"www.zip"];
            //            zip写入Cashes
            [resdata writeToFile:zipPath options:0 error:&error];
            if(!error)
            {
                //                解压
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: targetPath overWrite: YES];
                    if (NO == ret){
                        NSLog(@"下载 失败");
                    }else{
                        [za UnzipCloseFile];
                        NSDictionary *hotUpdateDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_hotUpdateVersion];
                        if (hotUpdateDic == nil) {
                            hotUpdateDic = @{};
                        }
                        NSMutableDictionary *newUpdateDic = [hotUpdateDic mutableCopy];
                        [newUpdateDic setObject:latestUpdate forKey:mainVersion];
                        [[NSUserDefaults standardUserDefaults] setObject:newUpdateDic forKey:kUserDefault_hotUpdateVersion];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        NSLog(@"##### 热更新完成 下次启动使用最新程序 ####");
                        NSLog(@"热更新版本%@\n zipPath  \n %@ \n\n",latestUpdate,zipPath);
                    }
                }
                else
                {
                    NSLog(@"Error saving file %@",error);
                }
            }
            else
            {
                NSLog(@"Error downloading zip file: %@", error);
            }
        }
    });
}

+(NSString *)wwwPath {
    NSString *mainVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *hotUpdateDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_hotUpdateVersion];
    NSString *latestVersion = [hotUpdateDic objectForKey:mainVersion];
    if (latestVersion != nil) {
        return [[UPDATE_FOLDER stringByAppendingPathComponent:latestVersion] stringByAppendingPathComponent:@"www"];
    }
    else
    {
        return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"www"];
    }
}

@end
