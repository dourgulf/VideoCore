//
//  ViewController.m
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/6/25.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import "PrepareLiveVC.h"
#import "LivingVC.h"

@interface PrepareLiveVC () {
}

@property (weak, nonatomic) IBOutlet UITextField *streamURLText;
@property (weak, nonatomic) IBOutlet UITextField *streamNameText;
@property (weak, nonatomic) IBOutlet UITextField *bitrateText;

@end

@implementation PrepareLiveVC {
}

- (IBAction)onLiveClicked:(UIButton *)sender {
    LivingVC *vc = [[LivingVC alloc] init];
    vc.pushURL = self.streamURLText.text;
    vc.streamName = self.streamNameText.text;
    vc.bitrate = [[[[NSNumberFormatter alloc] init] numberFromString:self.bitrateText.text] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
