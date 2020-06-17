//
//  JWDOverlayView.m
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "JWDOverlayView.h"
#import <Masonry.h>
#import "NSTimer+Additions.h"

@interface JWDOverlayView ()

@property (nonatomic, strong) UILabel *playTitleLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL animateHidden;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isPlaying;

@end


@implementation JWDOverlayView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
        [self addGestureRecognize];
        [self resetTimer];
    }
    return self;
}

- (void)setupView {

    // 布局
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor grayColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];

    UIButton *closeBtn = [[UIButton alloc] init];
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
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
 
    UIButton *playBtn = [[UIButton alloc] init];
    self.playBtn = playBtn;
    [playBtn setTitle:@"pause" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnDid:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(bottomView);
        make.width.mas_equalTo(50);
    }];
    
    UISlider *slider = [[UISlider alloc] init];
    [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];

    self.slider = slider;
    [bottomView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playBtn.mas_right).offset(15);
        make.right.equalTo(bottomView);
        make.top.bottom.equalTo(bottomView);
    }];

    // 约束
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

}

- (void)playBtnDid:(UIButton *)button {
    [self setPlay:button.isSelected];
}

- (void)setPlay:(BOOL)isPlaying {
    if (isPlaying) {
        [self.playBtn setTitle:@"pause" forState:UIControlStateNormal];
        [self.playBtn setSelected:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(play)]) {
            [self.delegate play];
        }
        self.isPlaying = YES;
    }else {
        [self.playBtn setTitle:@"play" forState:UIControlStateNormal];
        [self.playBtn setSelected:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
        self.isPlaying = NO;
    }
}

- (void)closeBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stop)]) {
        [self.delegate stop];
    }
    [self deallocTimer];
}

- (void)sliderTouchDown:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pause)]) {
        [self.delegate pause];
    }
    self.isPlaying = NO;
}

- (void)sliderTouchUpInSide:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpedToTime:)]) {
        [self.delegate jumpedToTime:slider.value*self.duration];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(play)]) {
        [self.delegate play];
    }
    self.isPlaying = YES;
}

- (void)setTitle:(NSString *)title {
    self.playTitleLabel.text = title;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    self.duration = duration;
    CGFloat sliderValue = time/duration;
    [self.slider setValue:sliderValue];
}
- (void)playbackComplete {
    [self.playBtn setTitle:@"play" forState:UIControlStateNormal];
    [self.playBtn setSelected:YES];
    self.isPlaying = NO;
}

- (void)setScrubbingTime:(NSTimeInterval)time {
    NSLog(@"JWDOverlayView----setScrubbingTime--%f",time);

}

- (void)setSubtitles:(NSArray *)subtitles {
    
}

#pragma Timer
- (void)resetTimer {
    [self deallocTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 firing:^{
        if (self.timer.isValid && self.animateHidden) {
            [self animateWith:YES];
        }
    }];
}
- (void)deallocTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)animateWith:(BOOL)isHidden {
    [UIView animateWithDuration:0.35 animations:^{
        if (isHidden) {
            self.animateHidden = NO;
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.superview).offset(-50);
            }];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.topView.superview).offset(50);
            }];
            [self deallocTimer];
        }else {
            self.animateHidden = YES;
            [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.superview).offset(0);
            }];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.topView.superview).offset(0);
            }];
            [self resetTimer];
        }
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
}

#pragma addGestureRecognize
- (void)addGestureRecognize {
    
    self.animateHidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewDoubletap:)];
    doubletap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubletap];
    [tap requireGestureRecognizerToFail:doubletap];
}

- (void)overlayViewTap:(UITapGestureRecognizer *)tap {
    [self animateWith:self.animateHidden];
}

- (void)overlayViewDoubletap:(UITapGestureRecognizer *)tap {
    [self setPlay:self.playBtn.isSelected];
}

@end
