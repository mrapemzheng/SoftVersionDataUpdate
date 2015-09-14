//
//  DataUpdateOn_1_2_6.m
//  SoftVersionDataUpdate
//
//  Created by CHENG DE LUO on 15/9/14.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import "DataUpdateOn_1_2_6.h"

@implementation DataUpdateOn_1_2_6

//重写更新内容, 更新成功则返回YES, 反之则返回NO
//注意,这里必须是同步执行的
- (BOOL)updateData
{
    NSLog(@"正在更新版本%@", self.version);
    
    
    // 更新成功则返回YES, 反之则返回NO
    return YES;
}

@end
