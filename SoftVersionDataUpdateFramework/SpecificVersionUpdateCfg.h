//
//  VersionUpdateCfg.h
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/7.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractDataUpdate.h"

/**
 *  版本更新配置
 */

@interface SpecificVersionUpdateCfg : NSObject

@property (nonatomic, strong) NSString *version;                    //版本
@property (nonatomic, strong) AbstractDataUpdate *abstractDataUpdate;//抽象数据更新类的子类

/**
 *  初始化
 *
 *  @param abstractDataUpdate 抽象数据更新类的子类
 *
 *  @return 版本更新配置
 */
- (instancetype)initWithAbstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate;

@end
