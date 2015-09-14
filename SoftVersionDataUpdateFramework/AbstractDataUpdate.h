//
//  AbstractDataUpdate.h
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/5.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AbstractDataUpdate;
@protocol AbstractDataUpdateDelegate <NSObject>

@optional
/**
 * 更新成功
 */
- (void)didUpdateSuccess:(AbstractDataUpdate *)abstractDataUpdate;

/**
 *  更新失败
 *
 *  @param abstractDataUpdate  软件数据更新基类
 */
- (void)didUpdateFail:(AbstractDataUpdate *)abstractDataUpdate;

/**
 *  完成其中一个
 *
 *  @param msg  信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate didFinishOneOfThese:(NSString *)msg;

/**
 *  失败了一个
 *
 *  @param msg 信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate  didFailOneOfThese:(NSString *)msg;

/**
 * 开始其中一个
 *
 *  @param msg 信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate  willBeginOneOfThese:(NSString *)msg;



@end

/**
 *  软件更新基类
 *
 *  @author apem
 *  @abstract 抽象基类(需要被继承使用)
 */

@interface AbstractDataUpdate : NSObject

@property (nonatomic, strong, readonly) NSString *version;              //版本
@property (nonatomic, assign) BOOL hasUpdate;                           //是否已经更新好了
@property (nonatomic, assign) id<AbstractDataUpdateDelegate> delegate;  //委托

/**
 *  初始化
 *
 *  @param version  版本号
 *  @param delegate 委托
 *
 *  @return 软件更新基类
 */
- (instancetype)initWithVersion:(NSString *)version delegate:(id<AbstractDataUpdateDelegate>)delegate;

/**
 *  更新数据 (执行内容必须是同步的)
 *
 *  @abstract 抽象 (需要被重写)
 *
 *  @return 更新是否成功
 */
- (BOOL)updateData;

/**
 *  开始
 */
- (void)start;

#pragma mark - life cycle of AbstractDataUpdate

/**
 *  已经更新完数据
 */
- (void)didUpdateData;

/**
 *  安装更新失败
 */
- (void)didFailToUpdateData;

/**
 *  已经更新了其中一块
 *
 *  @param msg 信息
 */
- (void)didFinishOneOfThese:(NSString *)msg;

/**
 *  即将更新其中一块
 *
 *  @param msg 信息
 */
- (void)willBeginOneOfThese:(NSString *)msg;

/**
 *  失败了其中一块
 *
 *  @param msg 信息
 */
- (void)didFailOneOfThese:(NSString *)msg;

@end
