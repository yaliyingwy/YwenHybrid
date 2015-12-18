//
//  NSDictionary+YwenJson.m
//  YwenHybridIos
//
//  Created by ywen on 15/12/9.
//  Copyright © 2015年 ywen. All rights reserved.
//

#import "NSDictionary+YwenJson.h"

@implementation NSDictionary (YwenJson)

-(NSString *)ywenJson {
    NSString *json = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
    return json;
}

@end
