//
//  SoftUpdater.h
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/4.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//
//
//iOS软件更新思路
//
//
//更新版本字典 updateVersionDictionary
//{
//    1.2.6 DataUpdate_1_2_6
//    1.2.8 DataUpdate_1_2_8
//}
//
//历史版本数组   historyUpdateVersions
//1.2.4
//1.2.5
//1.2.6	更新数据库
//1.2.7
//1.2.8 	更新数据库
//
//lastTowToFinalVersions
//倒数第二个版本到当前版本
//1.2.7
//1.2.8
//如果只有一个历史版本,那么取当前版本
//1.2.8
//
//finalNeedUpdateVersions
//需要更新版本数组中找到 >倒数第二个版本 <=最新版本 的版本数组
//1.2.8

#import <Foundation/Foundation.h>

@class SoftVersionManager;
@protocol SoftVersionManagerDelegate <NSObject>

@optional
/**
 * 更新成功
 */
- (void)softVersionUpdateSuccess:(SoftVersionManager *)softVersion;

/**
 *  更新失败
 *
 *  @param softVersion 软件版本数据更新
 */
- (void)softVersionUpdateFail:(SoftVersionManager *)softVersion;

@end

/**
 *  软件版本数据更新
 *
 *  @author apem
 */

@interface SoftVersionManager : NSObject

@property (nonatomic, strong) NSArray *specificVersionUpdateArray;      //特定版本更新配置数组
@property (nonatomic, strong, readonly) NSString *currentVersion;       //当前版本号
@property (nonatomic, strong, readonly) NSArray *historyVersions;        //历史版本号
@property (nonatomic, strong) NSArray *needUpdateVersions;     //需要执行更新的版本数组

@property(nonatomic, assign, readonly) BOOL hasExecute;        //是否已经被执行了
@property (nonatomic, assign, readonly) BOOL hasUpdateSuccess;  //已经被更新成功
@property(nonatomic, assign) id<SoftVersionManagerDelegate> delegate;//委托

/**
 *  初始化
 *
 *  @param specificVersionUpdateArray 特定版本更新配置数组
 *  @param withDelegate               委托
 *  @return 软件版本数据更新
 */
- (instancetype)initWithSpecificVersionUpdateArray:(NSArray *)specificVersionUpdateArray withDelegate:(id<SoftVersionManagerDelegate>)delegate;

/**
 *  更新数据
 */
- (void)startUpdateData;


@end
