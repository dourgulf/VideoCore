//
//  ViewController.m
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/6/25.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import "ViewController.h"
#import <videocore/api/iOS/VCSimpleSession.h>

#import "ConnectionKeeper.h"

@interface ViewController ()<VCSessionDelegate> {
}

@property (strong, nonatomic) VCSimpleSession *liveSession;
@property (strong, nonatomic) ConnectionKeeper *liveKeeper;
@end

@implementation ViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLiveClicked:(UIButton *)sender {
    if (!sender.selected) {
        [self setupSession];
        [self startPushVideo];
    }
    else {
        [self stopPushVideo];
        [self releaseSession];
    }
    sender.selected = !sender.selected;
    
    
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
    self.liveKeeper = [[ConnectionKeeper alloc] init];
    self.liveKeeper.liveSession = self.liveSession;
    [self.view addSubview:self.liveSession.previewView];
}

- (void)releaseSession {
    self.liveSession = nil;
    self.liveKeeper = nil;
}

- (void)startPushVideo {
    if (self.liveSession == nil) {
        return ;
    }
    
    NSString *urlstr =  @"";
    NSString *streamName = @"";
    int bitrate = -1;
    
    NSLog(@"Streaming:%@/%@ with bitrate:%d", urlstr, streamName, bitrate);
    if (bitrate > 0) {
        self.liveSession.bitrate = bitrate * 1000;
        self.liveSession.useAdaptiveBitrate = NO;
    }
    else {
        self.liveSession.useAdaptiveBitrate = YES;
    }
    [self.liveSession startRtmpSessionWithURL:urlstr andStreamKey:streamName];
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
