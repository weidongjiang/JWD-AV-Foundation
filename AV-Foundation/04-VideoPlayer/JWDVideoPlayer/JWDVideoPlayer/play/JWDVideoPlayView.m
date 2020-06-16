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

    // 布局

    JWDOverlayView *overlayView = [[JWDOverlayView alloc] init];
    self.overlayView = overlayView;
    self.overlayView.frame = self.bounds;
    [self addSubview:overlayView];
    
//    overlayView.backgroundColor = [UIColor blackColor];
//
//    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//
//
//    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = [UIColor blueColor];
//    [self addSubview:topView];
//
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//        make.height.mas_equalTo(50);
//    }];
//
//    UIButton *closeBtn = [[UIButton alloc] init];
//    closeBtn.backgroundColor = [UIColor redColor];
//    [closeBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:closeBtn];
//
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.equalTo(topView);
//        make.width.mas_equalTo(50);
//    }];
//
//
//
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor blueColor];
//    [self addSubview:bottomView];
//
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self);
//        make.height.mas_equalTo(50);
//    }];
//
//
//    // 约束
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [self layoutIfNeeded];


}

- (void)closeBtn {
    if (self) {
        [self removeFromSuperview];
    }
}


- (id<JWDTransport>)transport {
    return self.overlayView;
}

@end
