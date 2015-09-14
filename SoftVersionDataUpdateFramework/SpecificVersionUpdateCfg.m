//
//  VersionUpdateCfg.m
//  KgOrderSys
//
//  Created by CHENG DE LUO on 15/9/7.
//  Copyright (c) 2015年 CHENG DE LUO. All rights reserved.
//

#import "SpecificVersionUpdateCfg.h"

@implementation SpecificVersionUpdateCfg

- (instancetype)initWithAbstractDataUpdate:(AbstractDataUpdate *)abstractDataUpdate
{
    if(self = [super init]) {
        _abstractDataUpdate = abstractDataUpdate;
        _version = _abstractDataUpdate.version;
    }
    return self;
}

@end
