//
//  ViewController.m
//  camerashow
//
//  Created by jinchu darwin on 15/10/12.
//  Copyright © 2015年 jinchu darwin. All rights reserved.
//

#import "ViewController.h"
#import "VideoShowViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onVideoShowClicked:(id)sender {
    VideoShowViewController *videoshow = [[VideoShowViewController alloc] init];
    [self presentViewController:videoshow animated:YES completion:^{
        
    }];
}

@end
