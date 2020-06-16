//
//  JWDVideoPlayView.m
//  JWDVideoPlayer
//
//  Created by yixiajwd on 2018/11/8.
//  Copyright © 2018 yixiajwd. All rights reserved.
//

#import "JWDVideoPlayView.h"
#import <Masonry.h>
#import "JWDOverlayView.h"

@interface JWDVideoPlayView ()

@property (nonatomic, strong)JWDOverlayView *overlayView;

@end

@implementation JWDVideoPlayView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (instancetype)initWithPlayer:(AVPlayer *)player {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
    }
    return self;
}

- (void)setupView {

    self.overlayView = [[JWDOverlayView alloc] init];
    [self addSubview:self.overlayView];
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self layoutIfNeeded];
    
}

- (id<JWDTransport>)transport {
    return self.overlayView;
}

@end
