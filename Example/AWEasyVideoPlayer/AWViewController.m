//
//  AWViewController.m
//  AWEasyVideoPlayer
//
//  Created by Aaron Wojnowski on 2014-04-19.
//  Copyright (c) 2014 aaron. All rights reserved.
//

#import "AWViewController.h"

#import "AWEasyVideoPlayer.h"

@interface AWViewController () <AWEasyVideoPlayerDelegate>

@property (nonatomic, strong) AWEasyVideoPlayer *videoPlayer;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation AWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* example video URLs:
        - https://v.cdn.vine.co/videos_trellis/2013/10/12/046D49BF981000873061781766144_1.3.4_xGpElVkrzkUjtqsRMBhS0hutCQh3.NA5vT9LsJXWQ5XRXPwOSY4cmpVH_KdDfG0s.mp4
        - http://uploadingit.com/file/pkgz6mplwtodlzl6/Mac%20OS%20X%20Snow%20Leopard%20Intro%20Movie%20HD.mp4
    */
    
    AWEasyVideoPlayer *videoPlayer = [[AWEasyVideoPlayer alloc] init];
    [videoPlayer setDelegate:self];
    [videoPlayer setURL:[NSURL URLWithString:@"https://v.cdn.vine.co/videos_trellis/2013/10/12/046D49BF981000873061781766144_1.3.4_xGpElVkrzkUjtqsRMBhS0hutCQh3.NA5vT9LsJXWQ5XRXPwOSY4cmpVH_KdDfG0s.mp4"]];
    [videoPlayer setEndAction:AWEasyVideoPlayerEndActionLoop];
    [[self view] addSubview:videoPlayer];
    [self setVideoPlayer:videoPlayer];
    
    UIButton *playButton = [[UIButton alloc] init];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[self view] addSubview:playButton];
    [self setPlayButton:playButton];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [statusLabel setTextAlignment:NSTextAlignmentCenter];
    [statusLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:statusLabel];
    [self setStatusLabel:statusLabel];
    
}

-(void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    [[self videoPlayer] setFrame:CGRectMake((CGRectGetWidth([[self view] frame]) - 320) / 2.0, 20, 320, 320)];
    
    [[self playButton] setFrame:CGRectMake((CGRectGetWidth([[self view] frame]) - 100) / 2.0, CGRectGetMaxY([[self videoPlayer] frame]) + 20, 100, 44)];
    [[self statusLabel] setFrame:CGRectMake(0, CGRectGetMaxY([[self playButton] frame]) + 20, 320, 20)];
    
}

#pragma mark - Actions

-(void)play:(id)sender {
    
    [[self videoPlayer] play];
    
}

#pragma mark - AWEasyVideoPlayerDelegate

-(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer changedState:(AWEasyVideoPlayerState)state {
    
    NSLog(@"Video player state changed: %ld",state);
    
    switch (state) {
        case AWEasyVideoPlayerStateStopped:
            
            [[self statusLabel] setText:@"Player STOPPED."];
            
            break;
        case AWEasyVideoPlayerStateLoading:
            
            [[self statusLabel] setText:@"Player LOADING."];
            
            break;
        case AWEasyVideoPlayerStatePlaying:
            
            [[self statusLabel] setText:@"Player PLAYING."];
            
            break;
        case AWEasyVideoPlayerStatePaused:
            
            [[self statusLabel] setText:@"Player PAUSED."];
            
            break;
    }
    
}

-(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer encounteredError:(NSError *)error {
    
    NSLog(@"Encountered error: %@",[error localizedDescription]);
    
}

@end
