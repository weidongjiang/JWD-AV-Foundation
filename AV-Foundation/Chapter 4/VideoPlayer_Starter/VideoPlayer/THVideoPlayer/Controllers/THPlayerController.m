//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "THPlayerController.h"
#import "THThumbnail.h"
#import <AVFoundation/AVFoundation.h>
#import "THTransport.h"
#import "THPlayerView.h"
#import "AVAsset+THAdditions.h"
#import "UIAlertView+THAdditions.h"
#import "THNotifications.h"
#import "THThumbnail.h"

// AVPlayerItem's status property
#define STATUS_KEYPATH @"status"

// Refresh interval for timed observations of AVPlayer
#define REFRESH_INTERVAL 0.5f

// Define this constant for the key-value observation context.
static const NSString *PlayerItemStatusContext;


@interface THPlayerController () <THTransportDelegate>

@property (strong, nonatomic) THPlayerView *playerView;

// Listing 4.4
@property (nonatomic, strong) AVAsset        *asset; ///< <#value#>
@property (nonatomic, strong) AVPlayerItem        *palyerItem; ///< <#value#>
@property (nonatomic, strong) AVPlayer        *player; ///< <#value#>

@property (nonatomic, weak) id<THTransport>          transport; ///<  <#value#>
@property (nonatomic, strong) id        timeObserver; ///<
@property (nonatomic, strong) id        itemEndObserver; ///< <#value#>
@property (nonatomic, assign) float         lastPlaybackRate; ///< <#value#>
@property (nonatomic, strong) AVAssetImageGenerator        *imageGenerator; ///< <#value#>

@end

@implementation THPlayerController

#pragma mark - Setup

- (id)initWithURL:(NSURL *)assetURL {
    self = [super init];
    if (self) {
        
        // Listing 4.6
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {

    // Listing 4.6

    NSArray *keys = @[@"tracks",@"duration",@"commonMetadata",@"availableMediaCharacteristicsWithMediaSelectionOptions"];
    self.palyerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];

    // 添加观察者
    [self.palyerItem addObserver:self
                      forKeyPath:STATUS_KEYPATH
                         options:0
                         context:&PlayerItemStatusContext];

    self.player = [AVPlayer playerWithPlayerItem:self.palyerItem];

    self.playerView = [[THPlayerView alloc] initWithPlayer:self.player];

    self.transport = self.playerView.transport;

    self.transport.delegate = self;

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    // Listing 4.7
    if (context == &PlayerItemStatusContext) { // 观察的是该key

        // 没有指定是哪一个线程 回到主线程操作
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.palyerItem removeObserver:self forKeyPath:STATUS_KEYPATH];

            // 准备播放
            if (self.palyerItem.status == AVPlayerItemStatusReadyToPlay) {

                // 设置时间监听
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];

                // 设置时间
                CMTime duration = self.palyerItem.duration;
                [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(duration)];


                // 设置标题 self.asset.title 分类添加的属性 便于阅读
                [self.transport setTitle:self.asset.title];

                [self.player play];

                // 设置缩略图
                [self generateThumbnails];

                // 添加字幕
                [self loadMediaOptions];

            }else {
                [UIAlertView showAlertWithTitle:@"Error" message:@" Failed to load video"];
            }

        });

    }
}

#pragma mark - Time Observers

- (void)addPlayerItemTimeObserver {

    // Listing 4.8

    // 实时监听时间变化，更新进度条
    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    [self.player addPeriodicTimeObserverForInterval:interval
                                              queue:dispatch_get_main_queue()
                                         usingBlock:^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.palyerItem.duration);
        [weakSelf.transport setCurrentTime:currentTime duration:duration];
    }];
    
}

- (void)addItemEndObserverForPlayerItem {

    // Listing 4.9
    // 监听b播放器完成播放的通知 更新播放器时长，播放界面滑动条回到原点
    __weak typeof(self) weakSelf = self;
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.palyerItem
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                                                          [self.transport playbackComplete];
                                                      }];
                                                      }];

    
}

- (void)dealloc {
    if (self.itemEndObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.itemEndObserver];
        self.itemEndObserver = nil;
    }
}

#pragma mark - THTransportDelegate Methods

- (void)play {

    // Listing 4.10
    [self.player play];
}

- (void)pause {

    // Listing 4.10
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    
}

- (void)stop {

    // Listing 4.10
    [self.player setRate:0.0f];
    [self.transport playbackComplete];
    
}

- (void)jumpedToTime:(NSTimeInterval)time {

    // Listing 4.10
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidStart {

    // Listing 4.11
    // 在滑动开始的时候暂停 移除时间监听
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)scrubbedToTime:(NSTimeInterval)time {

    // Listing 4.11
    // 获取滑动条的数据，设置需要播放的点
    [self.palyerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    
}

- (void)scrubbingDidEnd {

    // Listing 4.11
    // 添加时间监听
    [self addPlayerItemTimeObserver];
    // 移动的时间点 去播放
    if (self.lastPlaybackRate > 0) {
        [self.player play];
    }
    
}


#pragma mark - Thumbnail Generation

- (void)generateThumbnails {

    // Listing 4.14

    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];

    self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);

    CMTime duration = self.asset.duration;

    // 添加时间集合
    NSMutableArray *times = [[NSMutableArray alloc] init];
    CMTimeValue increment = duration.value / 100;
    CMTimeValue currentValue = kCMTimeZero.value;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }


    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [[NSMutableArray alloc] init];

    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {

        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *_image = [UIImage imageWithCGImage:image];
            THThumbnail *thumbnail = [THThumbnail thumbnailWithImage:_image time:actualTime];
            [images addObject:thumbnail];
        }else {

        }

        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:THThumbnailsGeneratedNotification object:images];
            });
        }

    }];

}



- (void)loadMediaOptions {

    // Listing 4.16
    NSString *mc = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    if (group) {
        NSMutableArray *subtitles = [[NSMutableArray alloc] init];
        for (AVMediaSelectionOption *option in group.options) {
            [subtitles addObject:option.displayName];
        }
        [self.transport setSubtitles:subtitles];
    }else {
        [self.transport setSubtitles:nil];
    }
    
}

- (void)subtitleSelected:(NSString *)subtitle {

    // Listing 4.17
    NSString *mc = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];

    BOOL select = NO;
    for (AVMediaSelectionOption *option in group.options) {
        if ([option.displayName isEqualToString:subtitle]) {
            [self.palyerItem selectMediaOption:option inMediaSelectionGroup:group];
            select = YES;
        }
    }

    if (!select) {
        [self.palyerItem selectMediaOption:nil inMediaSelectionGroup:group];
    }
}


#pragma mark - Housekeeping

- (UIView *)view {
    return self.playerView;
}

@end
