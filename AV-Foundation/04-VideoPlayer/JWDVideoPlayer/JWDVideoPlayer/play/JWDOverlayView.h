//
//  JWDOverlayView.h
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWDTransport.h"

NS_ASSUME_NONNULL_BEGIN

@interface JWDOverlayView : UIView <JWDTransport>

@property (nonatomic, weak) id<JWDTransportDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
