//
//  ConnectionKeeper.h
//  SampleBroadcaster
//
//  Created by jinchu darwin on 16/6/29.
//  Copyright © 2016年 dawenhing.top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <videocore/api/iOS/VCSimpleSession.h>

@interface ConnectionKeeper : NSObject<VCSessionDelegate>

@property (weak, nonatomic) VCSimpleSession *liveSession;

@end
