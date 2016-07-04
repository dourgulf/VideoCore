//
//  ConnectionKeeper.m
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/6/29.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import "ConnectionKeeper.h"

@implementation ConnectionKeeper {
    id<VCSessionDelegate> _superDelegate;
}

-(void)dealloc {
    _liveSession.delegate = nil;
    _superDelegate = nil;
}

-(void)setLiveSession:(VCSimpleSession *)liveSession {
    _liveSession = liveSession;
    _superDelegate = _liveSession.delegate;
    _liveSession.delegate = self;
}

#pragma mark - Video session
- (void)connectionStatusChanged:(VCSessionState) state {
    dispatch_async(dispatch_get_main_queue(), ^{
        // if you want to update UI, change to main thread
        NSLog(@"connectionStatusChanged:%@", @(state));
        if ([_superDelegate respondsToSelector:@selector(connectionStatusChanged:)]) {
            [_superDelegate connectionStatusChanged:state];
        }
    });
}

#pragma mark CameraSource delegate
- (void)didAddCameraSource:(VCSimpleSession*)session {
    if ([_superDelegate respondsToSelector:@selector(didAddCameraSource:)]) {
        [_superDelegate didAddCameraSource:session];
    }
}

- (void) detectedThroughput: (NSInteger)throughputInBytesPerSecond videoRate:(NSInteger) rate {
    if ([_superDelegate respondsToSelector:@selector(detectedThroughput:videoRate:)]) {
        [_superDelegate detectedThroughput:throughputInBytesPerSecond videoRate:rate];
    }
}
@end
