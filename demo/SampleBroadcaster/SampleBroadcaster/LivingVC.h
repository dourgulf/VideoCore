//
//  LivingVC.h
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/7/5.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivingVC : UIViewController

@property (copy, nonatomic) NSString *pushURL;
@property (copy, nonatomic) NSString *streamName;
@property (assign, nonatomic) int bitrate;

@end
