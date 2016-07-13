//
//  LiveKeeper.m
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/7/13.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import "LiveKeeper.h"
#import "AFNetworkReachabilityManager.h"
#import "YYTextWeakProxy.h"

// 默认最多连续重连
static const NSUInteger kDefaultMaxRecoverCount = 3;
// 2分钟
static const NSTimeInterval kBrokenRecoverTimeout = 2 * 60;

@interface LiveKeeper ()

@property (copy, nonatomic) NSURL *pushURL;
@property (strong, nonatomic) RACSubject *shoultRecover;
@property (strong, nonatomic) RACSubject *recoverToomuch;
@property (strong, nonatomic) RACSubject *recoverTimeout;
@property (weak, nonatomic) NSTimer *recoverTimer;

@end

@implementation LiveKeeper {
    NSInteger _recoverCounter;
    AFNetworkReachabilityManager *_reachability;
    NSTimer *_brokenRecoverTimer;
}

- (instancetype)initWithURL:(NSURL *)pushURL;
{
    self = [super init];
    if (self) {
        _userStartedLive = NO;
        _recoving = NO;
        _pushBroken = NO;
        _recoverCounter = 0;
        _maxRecoverCount = kDefaultMaxRecoverCount;
        _pushURL = pushURL;
        [self createSignals];
        [self startNetworkMonitor];
    }
    return self;
}

- (void)dealloc {
    [self stopNetworkMonitor];
    [self stopBrokenRecoverTimer];
}

- (BOOL)needRecover {
    if (self.isPushBroken && self.isUserStartedLive && !self.isRecoving) {
        return YES;
    }
    return NO;
}

- (BOOL)isRecoverToomuch {
    return _recoverCounter > _maxRecoverCount;
}

- (void)setRecoving:(BOOL)recoving {
    _recoving = recoving;
    if (recoving) {
        _recoverCounter++;
        [self stopBrokenRecoverTimer];
    }
}

- (void)setPushBroken:(BOOL)pushBroken {
    _pushBroken = pushBroken;
    if (!pushBroken) {
        // 重连已经恢复了, 重置次数
        _recoverCounter = 0;
    }
    else {
        [self startBrokenRecoverTimer];
    }
}

- (void)createSignals {
    self.shoultRecover = [RACSubject subject];
    self.recoverToomuch = [RACSubject subject];
    self.recoverTimeout = [RACSubject subject];
}

- (void)startBrokenRecoverTimer {
    YYTextWeakProxy *proxy = [YYTextWeakProxy proxyWithTarget:self];
    _brokenRecoverTimer = [NSTimer scheduledTimerWithTimeInterval:kBrokenRecoverTimeout
                                                           target:proxy
                                                         selector:@selector(onBrokenRecoverTimeout)
                                                         userInfo:nil
                                                          repeats:NO];
}
- (void)stopBrokenRecoverTimer {
    [_brokenRecoverTimer invalidate];
    _brokenRecoverTimer = nil;
}

- (void)onBrokenRecoverTimeout {
    [self.recoverTimeout sendNext:@(YES)];
}

- (void)startNetworkMonitor {
    _reachability = [AFNetworkReachabilityManager managerForDomain:[self.pushURL host]];
    [_reachability startMonitoring];
    @weakify(self);
    [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        [self checkRecoverStatus];
    }];
}

- (void)stopNetworkMonitor {
    [_reachability stopMonitoring];
}

- (void)checkRecoverStatus {
    if ([_reachability isReachable]) {
         if ([self isRecoverToomuch]) {
             [self.recoverToomuch sendNext:@(YES)];
         }
         else if ([self needRecover]) {
             [self.shoultRecover sendNext:@(YES)];
         }
    }
}

@end
