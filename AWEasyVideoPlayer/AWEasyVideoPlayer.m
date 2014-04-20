//
//  AWEasyVideoPlayer.m
//  AWEasyVideoPlayer
//
//  Created by Aaron Wojnowski on 2014-04-19.
//  Copyright (c) 2014 aaron. All rights reserved.
//

#import "AWEasyVideoPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface AWEasyVideoPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) BOOL bufferEmpty;
@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation AWEasyVideoPlayer

-(void)dealloc {
    
    [self destroyPlayer];
    
}

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        // setup UI
        
        [self setBackgroundColor:[UIColor blackColor]];
        
        UIButton *actionButton = [[UIButton alloc] init];
        [self addSubview:actionButton];
        [self setActionButton:actionButton];
        
        // setup internal
        
        [self setEndAction:AWEasyVideoPlayerEndActionStop];
        [self setState:AWEasyVideoPlayerStateStopped];
        
    }
    return self;
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [[self playerLayer] setFrame:[self bounds]];
    
    [[self actionButton] setFrame:[self bounds]];
    
}

#pragma mark - Actions

-(void)play {
    
    switch ([self state]) {
        case AWEasyVideoPlayerStatePaused:
            
            [[self player] play];
            
            break;
        case AWEasyVideoPlayerStateStopped:
            
            [self setupPlayer];
            
            break;
            
        default:
            break;
    }
    
}

-(void)pause {
    
    if ([self state] == AWEasyVideoPlayerStatePaused ||
        [self state] == AWEasyVideoPlayerStateStopped) return;
    
    [[self player] pause];
   
}

-(void)stop {
    
    if ([self state] != AWEasyVideoPlayerStateStopped) return;
    
    [self destroyPlayer];
    
}

#pragma mark - Player

-(void)setupPlayer {
    
    if (![self URL]) return;
    
    [self destroyPlayer];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[self URL]];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    [player setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [player setVolume:[self playerVolume]];
    [self setPlayer:player];
    
    [self addObservers];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [[self layer] addSublayer:playerLayer];
    [self setPlayerLayer:playerLayer];
    
    [player play];
    
    [self layoutSubviews];
    
}

-(void)destroyPlayer {
    
    [self removeObservers];
    
    [self setPlayer:nil];
    
    [[self playerLayer] removeFromSuperlayer];
    [self setPlayerLayer:nil];
    
    [self setStateNotifyingDelegate:AWEasyVideoPlayerStateStopped];
    
}

#pragma mark - Player Notifications

-(void)playerFailed:(NSNotification *)notification {
    
    [self destroyPlayer];
    
    if ([[self delegate] respondsToSelector:@selector(videoPlayer:encounteredError:)])
        [[self delegate] videoPlayer:self encounteredError:[NSError errorWithDomain:@"AWEasyVideoPlayer" code:1 userInfo:@{ NSLocalizedDescriptionKey : @"An unknown error occurred." }]];
    
}

-(void)playerPlayedToEnd:(NSNotification *)notification {
    
    switch ([self endAction]) {
        case AWEasyVideoPlayerEndActionStop:
            
            [self destroyPlayer];
            
            break;
        case AWEasyVideoPlayerEndActionLoop:
            
            [[[self player] currentItem] seekToTime:kCMTimeZero];
            
            break;
    }
    
}

#pragma mark - Observers

-(void)addObservers {
    
    [[self player] addObserver:self forKeyPath:@"rate" options:0 context:NULL];
    
    [[[self player] currentItem] addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:NULL];
    [[[self player] currentItem] addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFailed:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:[[self player] currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayedToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[[self player] currentItem]];
    
}

-(void)removeObservers {
    
    [[self player] removeObserver:self forKeyPath:@"rate"];
    
    [[[self player] currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [[[self player] currentItem] removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == [self player]) {
        
        if ([keyPath isEqualToString:@"rate"]) {
            
            CGFloat rate = [[self player] rate];
            if (![self loaded]) {
                
                [self setStateNotifyingDelegate:AWEasyVideoPlayerStateLoading];
                
            } else if (rate == 1.0) {
                
                [self setStateNotifyingDelegate:AWEasyVideoPlayerStatePlaying];
                
            } else if (rate == 0.0) {
                                
                if ([self bufferEmpty]) {
                    
                    [self setStateNotifyingDelegate:AWEasyVideoPlayerStateLoading];
                    
                } else {
                    
                    [self setStateNotifyingDelegate:AWEasyVideoPlayerStatePaused];
                    
                }
                
            }
            
        }
        
    } else if (object == [[self player] currentItem]) {
        
        if ([keyPath isEqualToString:@"status"]) {
            
            AVPlayerItemStatus status = [[[self player] currentItem] status];
            switch (status) {
                case AVPlayerItemStatusFailed:
                    
                    [self destroyPlayer];
                    
                    if ([[self delegate] respondsToSelector:@selector(videoPlayer:encounteredError:)])
                        [[self delegate] videoPlayer:self encounteredError:[[[self player] currentItem] error]];
                    
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    
                    [self setLoaded:YES];
                    [self setStateNotifyingDelegate:AWEasyVideoPlayerStatePlaying];
                    
                    break;
                case AVPlayerItemStatusUnknown:
                    break;
            }
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            BOOL empty = [[[self player] currentItem] isPlaybackBufferEmpty];
            [self setBufferEmpty:empty];
            
        }
        
    }
    
}

#pragma mark - Getters & Setters

-(CGFloat)playerVolume {
    
    if ([self isMuted]) return 0.0;
    return 1.0;
    
}

-(void)setMuted:(BOOL)muted {
    
    _muted = muted;
    
    [[self player] setVolume:[self playerVolume]];
    
}

-(void)setURL:(NSURL *)URL {
    
    _URL = URL;
    
    [self destroyPlayer];
        
}

-(void)setState:(AWEasyVideoPlayerState)state {
        
    _state = state;
    
    switch (state) {
        case AWEasyVideoPlayerStatePaused:
        case AWEasyVideoPlayerStateStopped:
            
            [[self actionButton] addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case AWEasyVideoPlayerStateLoading:
        case AWEasyVideoPlayerStatePlaying:
            
            [[self actionButton] addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        default:
            break;
    }
    
}

#pragma mark - Delegate

-(void)setStateNotifyingDelegate:(AWEasyVideoPlayerState)state {
    
    AWEasyVideoPlayerState previousState = [self state];
    [self setState:state];
    
    if (state != previousState) {
        
        if ([[self delegate] respondsToSelector:@selector(videoPlayer:changedState:)])
            [[self delegate] videoPlayer:self changedState:state];
        
    }
    
}

@end
