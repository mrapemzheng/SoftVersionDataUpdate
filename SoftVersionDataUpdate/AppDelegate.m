//
//  AppDelegate.m
//  SoftVersionDataUpdate
//
//  Created by CHENG DE LUO on 15/9/14.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import "AppDelegate.h"
#import "DataUpdateOn_1_2_6.h"
#import <SoftVersionDataUpdateFramework/SoftVersionDataUpdateFramework.h>

@interface AppDelegate ()<AbstractDataUpdateDelegate, SoftVersionManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //数据更新内容======================================================
    DataUpdateOn_1_2_6 *update_1_2_6 = [[DataUpdateOn_1_2_6 alloc] initWithVersion:@"1.2.6" delegate:self];
    
    SpecificVersionUpdateCfg *versionCfg1 = [[SpecificVersionUpdateCfg alloc] initWithAbstractDataUpdate:update_1_2_6];
    SoftVersionManager *softVersion = [[SoftVersionManager alloc] initWithSpecificVersionUpdateArray:[NSArray arrayWithObjects:versionCfg1, nil] withDelegate:self];
    
    //如果还没有更新成功, 并且有可用更新
    if (!softVersion.hasUpdateSuccess && softVersion.needUpdateVersions.count != 0) {
        [softVersion startUpdateData];
    }     
    //=============================================================
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - AbstractDataUpdateDelegate

/**
 * 更新成功
 */
- (void)didUpdateSuccess:(AbstractDataUpdate *)abstractDataUpdate
{
    NSLog(@"更新一个版本成功");
}

/**
 *  更新失败
 *
 *  @param abstractDataUpdate  软件数据更新基类
 */
- (void)didUpdateFail:(AbstractDataUpdate *)abstractDataUpdate
{
    NSLog(@"更新一个版本失败");
}

/**
 *  完成其中一个
 *
 *  @param msg  信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate didFinishOneOfThese:(NSString *)msg
{
    NSLog(@"完成其中一个版本中的一个");
}

/**
 *  失败了一个
 *
 *  @param msg 信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate  didFailOneOfThese:(NSString *)msg
{
    NSLog(@"失败了其中一个版本中的一个");
}

/**
 * 开始其中一个
 *
 *  @param msg 信息
 */
- (void)abstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate  willBeginOneOfThese:(NSString *)msg
{
    NSLog(@"开始了其中一个版本中的一个");
}

#pragma mark - SoftVersionManagerDelegate

/**
 * 更新成功
 */
- (void)softVersionUpdateSuccess:(SoftVersionManager *)softVersion
{
    NSLog(@"所有版本更新成功");
}

/**
 *  更新失败
 *
 *  @param softVersion 软件版本数据更新
 */
- (void)softVersionUpdateFail:(SoftVersionManager *)softVersion
{
    NSLog(@"部分版本更新失败");
}

@end
