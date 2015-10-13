//
//  VideoShowViewController.m
//  camerashow
//
//  Created by jinchu darwin on 15/10/12.
//  Copyright © 2015年 jinchu darwin. All rights reserved.
//

#import "VideoShowViewController.h"
#import <videocore/api/iOS/VCSimpleSession.h>

@interface VideoShowViewController ()<VCSessionDelegate> {
    VCSimpleSession *_session;
}
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIView *controlView;

@end

@implementation VideoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 720) frameRate:30 bitrate:1000000 useInterfaceOrientation:YES];
    self.controlView.backgroundColor = [UIColor clearColor];
    // make the preview below all view
    [self.view insertSubview:_session.previewView atIndex:0];
    _session.previewView.frame = self.view.bounds;
    _session.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onShowClicked:(id)sender {
    [_session startRtmpSessionWithURL:@"rtmp://pushvideo.jclive.cn/testonly" andStreamKey:@"iosstream?abc=xxx"];
    //            [_session startRtmpSessionWithURL:@"rtmp://192.168.50.19/myapp" andStreamKey:@"iosstream?abc=xxx"];
}
- (IBAction)onCloseClicked:(id)sender {
    _session.delegate = nil;
    [_session endRtmpSession];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 
#pragma mark - Video session
- (void) connectionStatusChanged:(VCSessionState) state
{
    switch(state) {
        case VCSessionStatePreviewStarted:
            NSLog(@"Start preview");
            break;
            
        case VCSessionStateStarting:
            NSLog(@"Connecting");
            break;
            
        case VCSessionStateStarted:
        {
            NSLog(@"Connected");
            // 事件通知是在子线程里的，如果需要更改UI，需要重新分配到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                self.showButton.hidden = YES;
            });
        }
            break;
        case VCSessionStateEnded:
            NSLog(@"Disconnected");
            break;
        case VCSessionStateError:
            NSLog(@"ERROR!!");
            break;
        default:
            NSLog(@"UNKNOWN");
            break;
    }
}
@end
