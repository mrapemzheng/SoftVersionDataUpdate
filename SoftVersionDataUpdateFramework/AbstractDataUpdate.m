//
//  AbstractDataUpdate.m
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/5.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import "AbstractDataUpdate.h"

#define kHasUpdate @"HasUpdate"

@implementation AbstractDataUpdate

@synthesize hasUpdate = _hasUpdate;

- (instancetype)initWithVersion:(NSString *)version delegate:(id<AbstractDataUpdateDelegate>)delegate
{
    if(self = [super init]) {
        _version = version;
        _delegate = delegate;
        
        //设置是否已经更新
        [self hasUpdate];
        
    }
    return self;
}

- (void)setHasUpdate:(BOOL)hasUpdate
{
    _hasUpdate = hasUpdate;
    NSString *userdefaultkey = [NSString stringWithFormat:@"%@_%@", kHasUpdate, self.version];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_hasUpdate] forKey:userdefaultkey];
}

- (BOOL)hasUpdate
{
    NSString *userdefaultkey = [NSString stringWithFormat:@"%@_%@", kHasUpdate, self.version];
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultkey];
    _hasUpdate = num ? [num boolValue] : NO;
    return _hasUpdate;
}

- (BOOL)updateData
{
    
    return YES;
}

/**
 *  开始
 */
- (void)start
{
    BOOL isSuccess = [self updateData];
    if (isSuccess) {
        [self didUpdateData];
        
    } else {
        [self didFailToUpdateData];
        
    }
}

#pragma mark - life cycle of AbstractDataUpdate

- (void)didUpdateData
{
    //设置NSUserDefault更新标志
    [self setHasUpdate:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateSuccess:)]) {
            [self.delegate didUpdateSuccess:self];
        }
    });
    
}

- (void)didFailToUpdateData
{
    //设置NSUserDefault更新标志
    [self setHasUpdate:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateFail:)]) {
            [self.delegate didUpdateFail:self];
        }
    });
}

- (void)didFinishOneOfThese:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(abstractDataUpdate:didFinishOneOfThese:)]) {
            [self.delegate abstractDataUpdate:self didFinishOneOfThese:msg];
        }
    });
}

- (void)willBeginOneOfThese:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(abstractDataUpdate:willBeginOneOfThese:)]) {
            [self.delegate abstractDataUpdate:self willBeginOneOfThese:msg];
        }
    });
}

- (void)didFailOneOfThese:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(abstractDataUpdate:didFailOneOfThese:)]) {
            [self.delegate abstractDataUpdate:self didFailOneOfThese:msg];
        }
    });
}

@end
