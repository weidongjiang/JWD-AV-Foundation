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

typedef void(^JWDVideoPlayControllerRemoveBlock)(void);

@interface JWDVideoPlayController : NSObject

@property (nonatomic,strong,readonly) UIView *view;
@property (nonatomic, copy) JWDVideoPlayControllerRemoveBlock removeBlock;
- (instancetype)initWithUrl:(NSURL *)assetURL;

@end

NS_ASSUME_NONNULL_END
