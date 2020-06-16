//
//  JWDVideoPlayController.m
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "JWDVideoPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import "JWDVideoPlayView.h"
#import "AVAsset+JWDAdditions.h"


#define STATUS_KEYPATH @"status"
#define REFRESH_INTERVAL 0.5f

static const NSString *PlayerItemStatusContext;

@interface JWDVideoPlayController ()<JWDTransportDelegate>

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) JWDVideoPlayView *playerView;
@property (nonatomic, weak) id<JWDTransport> transport;

@property (strong, nonatomic) id timeObserver;
@property (strong, nonatomic) id itemEndObserver;
@property (assign, nonatomic) float lastPlaybackRate;

@end

@implementation JWDVideoPlayController
- (instancetype)initWithUrl:(NSURL *)assetURL {
    self = [super init];
    if (self) {
        self.asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {
    NSArray *keys = @[@"tracks",@"duration",@"commonMetadata",@"availableMediaCharacteristicsWithMediaSelectionOptions"];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self
                      forKeyPath:STATUS_KEYPATH
                         options:0
                         context:&PlayerItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerView = [[JWDVideoPlayView alloc] initWithPlayer:self.player];
    self.transport = self.playerView.transport;
    self.transport.delegate = self;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context == &PlayerItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
                
                [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero)
                                      duration:CMTimeGetSeconds(self.playerItem.duration)];
                
                [self.transport setTitle:self.asset.title];
                
                [self.player play];
                
                [self loadMediaOptions];
                [self generateThumbnails];
                
            }else {
                NSLog(@"Failed to load video");
            }
        });
    }
}


- (void)loadMediaOptions {
    NSString *mc = AVMediaCharacteristicLegible;
    
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    if (group) {
        NSMutableArray *subtitles = [NSMutableArray array];
        for (AVMediaSelectionOption *option in group.options) {
            [subtitles addObject:option.displayName];
        }
        [self.transport setSubtitles:subtitles];
    }else {
        [self.transport setSubtitles:nil];
    }
    
}

- (void)generateThumbnails {
    
    
}

- (void)addPlayerItemTimeObserver {
    
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __weak JWDVideoPlayController *weakSelf = self;
    void (^callBack)(CMTime time) = ^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSInteger duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.transport setCurrentTime:currentTime duration:duration];
    };
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:queue
                                                             usingBlock:callBack];
    
}

- (void)addItemEndObserverForPlayerItem {
    
    
        __weak JWDVideoPlayController *weakSelf = self;
    void (^callBack)(NSNotification * _Nonnull note) = ^(NSNotification * _Nonnull notification) {
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.transport playbackComplete];
        }];
    };
    
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                             object:self.playerItem
                                                                              queue:[NSOperationQueue mainQueue]
                                                                         usingBlock:callBack];
    
    
}


#pragma JWDTransportDelegate
- (void)play {
    [self.player play];
}
- (void)pause {
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}
- (void)stop {
    [self.player setRate:0.0f];
    [self.transport playbackComplete];
}

- (void)scrubbingDidStart {
    
}

- (void)scrubbedToTime:(NSTimeInterval)time {
    
}

- (void)scrubbingDidEnd {
    
}

- (void)jumpedToTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}



- (UIView *)view {
    return self.playerView;
}

- (void)dealloc {
    if (self.itemEndObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        self.itemEndObserver = nil;
    }
}

@end
