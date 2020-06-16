//
//  JWDVideoPlayView.h
//  JWDVideoPlayer
//
//  Created by yixiajwd on 2018/11/8.
//  Copyright © 2018 yixiajwd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JWDTransport.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWDVideoPlayView : UIView

@property (nonatomic, readonly) id<JWDTransport> transport;

- (instancetype)initWithPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
