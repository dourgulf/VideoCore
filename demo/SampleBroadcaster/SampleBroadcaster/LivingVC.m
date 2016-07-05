//
//  LivingVC.m
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/7/5.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import "LivingVC.h"

#import <videocore/api/iOS/VCSimpleSession.h>
#import "Masonry.h"

@interface LivingVC() <VCSessionDelegate>

@property (strong, nonatomic) VCSimpleSession *liveSession;

@end

@implementation LivingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSession];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self startPushVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopPushVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSession {
    CGSize videoSize = [UIScreen mainScreen].bounds.size;
    
    // 取偶数大小，避免VideoCore做除法运算的误差导致的一个绿色边框的现象
    if ((int)videoSize.width % 2 == 1) {
        videoSize.width += 1;
    }
    if ((int)videoSize.height %2 == 1) {
        videoSize.height += 1;
    }
    self.liveSession = [[VCSimpleSession alloc] initWithVideoSize:videoSize
                                                        frameRate:25
                                                          bitrate:1000 * 1000
                                          useInterfaceOrientation:YES
                                                      cameraState:VCCameraStateFront];
    [self.view addSubview:self.liveSession.previewView];
    [self.liveSession.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)releaseSession {
    self.liveSession = nil;
}

- (void)startPushVideo {
    if (self.liveSession == nil) {
        return ;
    }
    
    NSLog(@"Streaming:%@/%@ with bitrate:%d", self.pushURL, self.streamName, self.bitrate);
    if (self.bitrate > 0) {
        self.liveSession.bitrate = self.bitrate * 1000;
        self.liveSession.useAdaptiveBitrate = NO;
    }
    else {
        self.liveSession.useAdaptiveBitrate = YES;
    }
    [self.liveSession startRtmpSessionWithURL:self.pushURL andStreamKey:self.streamName];
}

- (void)stopPushVideo {
    [self.liveSession endRtmpSession];
}

#pragma mark - Video session
- (void)connectionStatusChanged:(VCSessionState) state {
    NSLog(@"connectionStatusChanged:%@", @(state));
}

#pragma mark CameraSource delegate
- (void)didAddCameraSource:(VCSimpleSession*)session {
    NSLog(@"didAddCameraSource");
}

- (void) detectedThroughput: (NSInteger)throughputInBytesPerSecond videoRate:(NSInteger) rate {
}

@end
