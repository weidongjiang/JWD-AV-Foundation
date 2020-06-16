//
//  JWDOverlayView.m
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "JWDOverlayView.h"
#import <Masonry.h>

@interface JWDOverlayView ()
@property (nonatomic, strong) UILabel *playTitleLabel;

@end


@implementation JWDOverlayView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {

    // 布局

    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blueColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(topView);
        make.width.mas_equalTo(50);
    }];

    UILabel *playTitleLabel = [[UILabel alloc] init];
    playTitleLabel.textColor = [UIColor whiteColor];
    self.playTitleLabel = playTitleLabel;
    [topView addSubview:playTitleLabel];
    [playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeBtn.mas_right);
        make.top.bottom.equalTo(topView);
    }];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blueColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setTitle:@"pause" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnDid:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(bottomView);
        make.width.mas_equalTo(50);
    }];
    

    // 约束
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

}

- (void)playBtnDid:(UIButton *)button {
    if (button.isSelected) {
        [button setTitle:@"pause" forState:UIControlStateNormal];
        [button setSelected:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate play];
        }
    }else {
        [button setTitle:@"play" forState:UIControlStateNormal];
        [button setSelected:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
    }
}

- (void)closeBtn {
  
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stop)]) {
        [self.delegate stop];
    }
    
}




- (void)setTitle:(NSString *)title {
    NSLog(@"JWDOverlayView----title--%@",title);
    self.playTitleLabel.text = title;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    NSLog(@"JWDOverlayView----time--%f",time);

}

- (void)setScrubbingTime:(NSTimeInterval)time {
    NSLog(@"JWDOverlayView----setScrubbingTime--%f",time);

}

- (void)playbackComplete {
    
}

- (void)setSubtitles:(NSArray *)subtitles {
    
}

@end
