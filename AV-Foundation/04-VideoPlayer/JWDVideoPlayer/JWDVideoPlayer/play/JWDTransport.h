//
//  JWDTransport.h
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#ifndef JWDTransport_h
#define JWDTransport_h

#import <AVFoundation/AVFoundation.h>


@protocol JWDTransportDelegate <NSObject>

- (void)play;
- (void)pause;
- (void)stop;

- (void)scrubbingDidStart;
- (void)scrubbedToTime:(NSTimeInterval)time;
- (void)scrubbingDidEnd;

- (void)jumpedToTime:(NSTimeInterval)time;

@optional
- (void)subtitleSelected:(NSString *)subtitle;

@end


@protocol JWDTransport <NSObject>


@property (weak, nonatomic) id <JWDTransportDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)setScrubbingTime:(NSTimeInterval)time;
- (void)playbackComplete;
- (void)setSubtitles:(NSArray *)subtitles;

@end

#endif /* JWDTransport_h */
