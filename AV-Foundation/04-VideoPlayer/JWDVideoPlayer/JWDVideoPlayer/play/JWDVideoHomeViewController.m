//
//  JWDVideoHomeViewController.m
//  JWDVideoPlayer
//
//  Created by yixiajwd on 2018/11/8.
//  Copyright © 2018 yixiajwd. All rights reserved.
//

#import "JWDVideoHomeViewController.h"
#import "JWDVideoPlayViewController.h"
#import "JWDVideoPlayView.h"
#import <Masonry.h>


@interface JWDVideoHomeViewController ()

@property (nonatomic, strong) JWDVideoPlayView        *playView; ///< <#value#>

@end

@implementation JWDVideoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor yellowColor];


    UIButton *playLocalButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 160, 30)];
    playLocalButton.backgroundColor = [UIColor redColor];
    [playLocalButton setTitle:@"playLocal" forState:UIControlStateNormal];
    [playLocalButton addTarget:self action:@selector(playLocalButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playLocalButton];


    UIButton *playRemoteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 160, 30)];
    playRemoteButton.backgroundColor = [UIColor redColor];
    [playRemoteButton setTitle:@"playRemote" forState:UIControlStateNormal];
    [playRemoteButton addTarget:self action:@selector(playRemoteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRemoteButton];
}

- (void)playLocalButton {


    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)playRemoteButton {
    
}


- (JWDVideoPlayView *)playView {
    if (!_playView) {
        _playView = [[JWDVideoPlayView alloc] init];
    }
    return _playView;
}

@end
