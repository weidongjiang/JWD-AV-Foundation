//
//  JWDVideoPlayView.m
//  JWDVideoPlayer
//
//  Created by yixiajwd on 2018/11/8.
//  Copyright © 2018 yixiajwd. All rights reserved.
//

#import "JWDVideoPlayView.h"
#import <Masonry.h>

@interface JWDVideoPlayView ()

@end

@implementation JWDVideoPlayView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {

    // 布局

    UIView *playView = [[UIView alloc] init];
    playView.backgroundColor = [UIColor blackColor];
    [self addSubview:playView];

    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];


    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blueColor];
    [self addSubview:topView];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.width.mas_equalTo(50);
    }];



    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blueColor];
    [self addSubview:bottomView];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];





    // 约束
    [self setAllLayoutView];


}

- (void)closeBtn {
    if (self) {
        [self removeFromSuperview];
    }
}


- (void)setAllLayoutView {




    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
