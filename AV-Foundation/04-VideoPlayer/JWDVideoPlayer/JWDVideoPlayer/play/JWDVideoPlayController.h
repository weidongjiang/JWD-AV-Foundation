//
//  JWDVideoPlayController.h
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface JWDVideoPlayController : NSObject

@property (nonatomic,strong,readonly) UIView *view;

- (instancetype)initWithUrl:(NSURL *)assetURL;

@end

NS_ASSUME_NONNULL_END
