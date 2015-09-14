//
//  SoftVersionConstant.h
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/7.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

/**
 *  版本更新常量
 *
 *  @author apem
 */

#ifndef KgOrderSys_SoftVersionConstant_h
#define KgOrderSys_SoftVersionConstant_h

#define kHistoryVersion @"HistoryVersion"   //历史版本key (NSUserDefault)

//软件更新已经执行过标志
#define kSoftVersionHasExecuteFlag ([NSString stringWithFormat:@"SoftVersionHasExecuteFlag_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]])

//软件更新已经更新成功标志
#define kSoftVersionhasUpdateSuccessFlag [NSString stringWithFormat:@"SoftVersionhasUpdateSuccessFlag_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

#endif
