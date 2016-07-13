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
#import "LiveKeeper.h"

@interface LivingVC() <VCSessionDelegate>

@property (strong, nonatomic) VCSimpleSession *liveSession;
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;
@property (strong, nonatomic) LiveKeeper *liveKeeper;

@end

@implementation LivingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLiveKeeper];
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

- (void)setupLiveKeeper {
    self.liveKeeper = [[LiveKeeper alloc] initWithURL:[NSURL URLWithString:self.pushURL]];

    [self.liveKeeper.recoverTimeout subscribeNext:^(id x) {
        [self updateStatusText:@"Recover timeout"];
    }];
    
    [self.liveKeeper.shoultRecover subscribeNext:^(id x) {
        [self updateStatusText:@"Recovering"];
        self.liveKeeper.recoving = YES;
        [self.liveSession endRtmpSession];
        [self.liveSession startRtmpSessionWithURL:self.pushURL andStreamKey:self.streamName];
    }];
    
    [self.liveKeeper.recoverToomuch subscribeNext:^(id x) {
        [self updateStatusText:@"Recover failed"];        
    }];
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
    self.liveSession.delegate = self;
    [self.view insertSubview:self.liveSession.previewView atIndex:0];
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
        self.liveSession.bitrate = 1000 * 1000;
        self.liveSession.useAdaptiveBitrate = YES;
    }
    self.liveKeeper.userStartedLive = YES;
    [self.liveSession startRtmpSessionWithURL:self.pushURL andStreamKey:self.streamName];
}

- (void)stopPushVideo {
    self.liveKeeper.userStartedLive = NO;
    [self.liveSession endRtmpSession];
}

- (void)updateStatusText:(NSString *)text {
    self.liveStatusLabel.text = [NSString stringWithFormat:@"RTMP Status:%@", text];

}
#pragma mark - Video session
- (void)connectionStatusChanged:(VCSessionState) state {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *stateText = @"";
        switch (state) {
            case VCSessionStatePreviewStarted:
                stateText = @"Preview";
                break;
            case VCSessionStateStarting:
                stateText = @"Starting";
                break;
            case VCSessionStateStarted:
                stateText = @"Started";
                self.liveKeeper.recoving = NO;
                self.liveKeeper.pushBroken = NO;
                break;
            case VCSessionStateEnded:
                stateText = @"Ended";
                self.liveKeeper.pushBroken = YES;
                break;
            case VCSessionStateError:
                stateText = @"Error";
                self.liveKeeper.pushBroken = YES;
                break;
            default:
                stateText = @"Unknown";
                break;
        }
        [self updateStatusText:stateText];
    });
}

#pragma mark CameraSource delegate
- (void)didAddCameraSource:(VCSimpleSession*)session {
    NSLog(@"didAddCameraSource");
}

- (void) detectedThroughput: (NSInteger)throughputInBytesPerSecond videoRate:(NSInteger) rate {
}

@end
