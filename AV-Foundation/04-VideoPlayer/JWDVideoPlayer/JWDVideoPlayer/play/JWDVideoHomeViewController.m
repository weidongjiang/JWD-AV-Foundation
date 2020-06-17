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
#import "JWDVideoPlayController.h"

@interface JWDVideoHomeViewController ()

@property (nonatomic, strong) JWDVideoPlayView        *playView; ///< <#value#>
@property (nonatomic, strong) JWDVideoPlayController *playController;

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

    NSString *localURL = [[NSBundle mainBundle] pathForResource:@"hubblecast" ofType:@"m4v" inDirectory:@"Res"];
    self.playController = [[JWDVideoPlayController alloc] initWithUrl:[NSURL fileURLWithPath:localURL]];
    
    [self.view addSubview:self.playController.view];
    [self.playController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)playRemoteButton {
    
}


@end
