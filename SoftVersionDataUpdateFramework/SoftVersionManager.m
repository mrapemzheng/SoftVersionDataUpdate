//
//  SoftUpdater.m
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/4.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import "SoftVersionManager.h"
#import "SoftVersionConstant.h"
#import "SpecificVersionUpdateCfg.h"

//版本大小关系
typedef enum {
    VersionSizeRelationGreater = 1,         //大于
    VersionSizeRelationEqual = 0,           //等于
    VersionSizeRelationLess = -1            //小于
} VersionSizeRelation;

@interface SoftVersionManager ()

@property (nonatomic, strong) NSMutableDictionary *specificVersionUpdateDict;       //版本更新配置字典,以版本号为key

@end

@implementation SoftVersionManager

@synthesize hasExecute = _hasExecute;
@synthesize hasUpdateSuccess = _hasUpdateSuccess;

@synthesize historyVersions = _historyVersions;
@synthesize currentVersion = _currentVersion;
@synthesize specificVersionUpdateDict = _specificVersionUpdateDict;

- (instancetype)initWithSpecificVersionUpdateArray:(NSArray *)specificVersionUpdateArray withDelegate:(id<SoftVersionManagerDelegate>)delegate
{
    if (self = [super init]) {
        self.specificVersionUpdateArray = specificVersionUpdateArray;
        self.delegate = delegate;
        [self hasExecute];
        [self hasUpdateSuccess];
        [self currentVersion];
        
    }
    return self;
}

- (NSArray *)historyVersions
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //如果没有包含该缓存
    if (![ud objectForKey:kHistoryVersion]) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        [mutableArr addObject:currentVersion];
        [ud setObject:mutableArr forKey:kHistoryVersion];
    } else {
        NSMutableArray *mutableArr = [[ud objectForKey:kHistoryVersion] mutableCopy];
        //如果不包含当前版本
        if (![mutableArr containsObject:currentVersion]) {
            [mutableArr addObject:currentVersion];
            [ud setObject:mutableArr forKey:kHistoryVersion];
        }
    }
    _historyVersions = [ud objectForKey:kHistoryVersion];
    return _historyVersions;
}

- (NSString *)currentVersion
{
    if (!_currentVersion) {
        _currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _currentVersion;
}

- (void)setSpecificVersionUpdateArray:(NSArray *)specificVersionUpdateArray
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    _specificVersionUpdateArray = specificVersionUpdateArray;
    for (SpecificVersionUpdateCfg *specificVersionUpdateCfg in _specificVersionUpdateArray) {
        [mutableDict setObject:specificVersionUpdateCfg forKey:specificVersionUpdateCfg.version];
    }
    _specificVersionUpdateDict = mutableDict;
}

- (NSArray *)needUpdateVersions
{
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSArray *historyVersions = self.historyVersions;
    NSArray *specificUpdateVersions = [self.specificVersionUpdateDict allKeys];
    
    //历史版本不止一个,证明不是新安装的
    if (self.historyVersions.count > 1) {
        //倒数第二个版本号
        NSString *lastTwoVersion = [historyVersions objectAtIndex:historyVersions.count-1 - 1];
        
        for (NSString *version in specificUpdateVersions) {
            if ([self compareWithVersionFirst:version versionSecond:lastTwoVersion] == VersionSizeRelationGreater) {
                [mutableArr addObject:version];
            }
        }
    //新安装的,并且特定更新版本中包含这个版本
    } else if(historyVersions.count == 1 && [specificUpdateVersions containsObject:[historyVersions lastObject]]) {
        [mutableArr addObject:[historyVersions lastObject]];
    }
    
    _needUpdateVersions = mutableArr;
    
    return _needUpdateVersions;
}

- (void)setHasExecute:(BOOL)hasExecute
{
    _hasExecute = hasExecute;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_hasExecute] forKey:kSoftVersionHasExecuteFlag];
}

- (BOOL)hasExecute
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kSoftVersionHasExecuteFlag];
    _hasExecute = num ? num.boolValue : NO;
    return _hasExecute;
}

- (void)setHasUpdateSuccess:(BOOL)hasUpdateSuccess
{
    _hasUpdateSuccess = hasUpdateSuccess;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_hasUpdateSuccess] forKey:kSoftVersionhasUpdateSuccessFlag];
}

- (BOOL)hasUpdateSuccess
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kSoftVersionhasUpdateSuccessFlag];
    _hasUpdateSuccess = num ? num.boolValue : NO;
    return _hasUpdateSuccess;
}

- (void)startUpdateData
{
    if (!self.hasUpdateSuccess) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //需要执行更新的版本
            NSArray *needUpdateVersions = self.needUpdateVersions;
            SpecificVersionUpdateCfg *specificVersionUpdateCfg;
            for(NSInteger i = 0;i < needUpdateVersions.count;i ++) {
                specificVersionUpdateCfg = [self.specificVersionUpdateDict objectForKey:[needUpdateVersions objectAtIndex:i]];
                //只要还没有更新完毕就执行更新
                if (!specificVersionUpdateCfg.abstractDataUpdate.hasUpdate) {
                    [specificVersionUpdateCfg.abstractDataUpdate start];
                }
            }
            
            //设置已经执行
            self.hasExecute = YES;
            
            //判断是否全部执行成功
            BOOL ifHasUpdateSuccess = NO;
            for(NSInteger i = 0;i < needUpdateVersions.count;i ++) {
                specificVersionUpdateCfg = [self.specificVersionUpdateDict objectForKey:[needUpdateVersions objectAtIndex:i]];
                ifHasUpdateSuccess = specificVersionUpdateCfg.abstractDataUpdate.hasUpdate;
                if (ifHasUpdateSuccess == NO) {
                    break;
                }
            }
            //设置是否全部执行成功
            self.hasUpdateSuccess = ifHasUpdateSuccess;
            
            //如果执行成功,发出成功委托
            if(self.hasUpdateSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(softVersionUpdateSuccess:)]) {
                        [self.delegate softVersionUpdateSuccess:self];
                    }
                });
                
            //发出失败委托
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(softVersionUpdateFail:)]) {
                        [self.delegate softVersionUpdateFail:self];
                    }
                });
                
            }
            
        });
    }
    
    
}

#pragma mark - private methods

/**
 *  比较两个版本的大小关系
 *
 *  @param versionFirst  第一个版本
 *  @param versionSecond 第二个版本
 *
 *  @return 两个版本的大小关系
 *  @return 返回-1表示出错
 */
- (VersionSizeRelation)compareWithVersionFirst:(NSString *)versionFirst versionSecond:(NSString *)versionSecond
{
    VersionSizeRelation versionSizeRelation;
    NSArray *firstArr = [versionFirst componentsSeparatedByString:@"."];
    NSArray *secondArr = [versionSecond componentsSeparatedByString:@"."];
    
    NSInteger value1 = 0;
    NSInteger value2 = 0;
    for (NSInteger i = 0;i < firstArr.count; i ++) {
        value1 = [[firstArr objectAtIndex:i] integerValue];
        if (secondArr.count > i) {
            value2 = [[secondArr objectAtIndex:i] integerValue];
        } else {
            value2 = 0;
        }
        
        if (value1 > value2) {
            versionSizeRelation = VersionSizeRelationGreater;
            return versionSizeRelation;
        } else if(value1 < value2){
            versionSizeRelation = VersionSizeRelationLess;
            return versionSizeRelation;
        } else if(value1 == value2 && (i == (firstArr.count-1))) {
            versionSizeRelation = VersionSizeRelationEqual;
            return versionSizeRelation;
        }
    }
    
    return -1;
}

@end
