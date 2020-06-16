//
//  AVAsset+JWDAdditions.m
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "AVAsset+JWDAdditions.h"

@implementation AVAsset (JWDAdditions)
- (NSString *)title {

    AVKeyValueStatus status =
        [self statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items =
            [AVMetadataItem metadataItemsFromArray:self.commonMetadata
                                           withKey:AVMetadataCommonKeyTitle
                                          keySpace:AVMetadataKeySpaceCommon];
        if (items.count > 0) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
    }
    
    return nil;
}
@end
