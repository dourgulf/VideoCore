//
//  LiveKeeper.h
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/7/13.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface LiveKeeper : NSObject

- (instancetype)initWithURL:(NSURL *)pushURL;

@property (assign, nonatomic) NSInteger maxRecoverCount;                        // 最多连续恢复多少次?
@property (assign, nonatomic, getter=isUserStartedLive) BOOL userStartedLive;   // 用户是否已经开播(不表示推流的任何状态情况)
@property (assign, nonatomic, getter=isRecoving) BOOL recoving;                 // 是否正在恢复开播
@property (assign, nonatomic, getter=isPushBroken) BOOL pushBroken;             // 推流是否中断了

@property (readonly, nonatomic) RACSubject *shoultRecover;             // 需要回复直播的信号
@property (readonly, nonatomic) RACSubject *recoverToomuch;            // 连续失败太多, 无法恢复的信号
@property (readonly, nonatomic) RACSubject *recoverTimeout;            // 恢复超时

@end
