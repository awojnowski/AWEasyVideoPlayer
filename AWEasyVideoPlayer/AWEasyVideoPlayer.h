//
//  AWEasyVideoPlayer.h
//  AWEasyVideoPlayer
//
//  Created by Aaron Wojnowski on 2014-04-19.
//  Copyright (c) 2014 aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AWEasyVideoPlayerState) {
    
    AWEasyVideoPlayerStateStopped,
    AWEasyVideoPlayerStateLoading,
    AWEasyVideoPlayerStatePlaying,
    AWEasyVideoPlayerStatePaused
    
};

typedef NS_ENUM(NSInteger, AWEasyVideoPlayerEndAction) {
    
    AWEasyVideoPlayerEndActionStop,
    AWEasyVideoPlayerEndActionLoop
    
};

@protocol AWEasyVideoPlayerDelegate;

@interface AWEasyVideoPlayer : UIView

@property (nonatomic, weak) id <AWEasyVideoPlayerDelegate> delegate;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) AWEasyVideoPlayerEndAction endAction;
@property (nonatomic, assign) AWEasyVideoPlayerState state;

@property (nonatomic, assign, getter = isMuted) BOOL muted;

-(void)play;
-(void)pause;
-(void)stop;

@end

@protocol AWEasyVideoPlayerDelegate <NSObject>

@optional
-(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer changedState:(AWEasyVideoPlayerState)state;
-(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer encounteredError:(NSError *)error;

@end
