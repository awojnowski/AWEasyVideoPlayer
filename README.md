AWEasyVideoPlayer
===============

AWEasyVideoPlayer is a simple implementation of AVPlayer mimicking Vine and Instagram.

It supports looping, pausing, playing, muting, and loading states and ships default with no user interface.

Getting Started
------------------

Below is an example of adding the video player to a view controller and playing a video.

    AWEasyVideoPlayer *videoPlayer = [[AWEasyVideoPlayer alloc] init];
    [videoPlayer setFrame:[[self view] bounds]];
    [videoPlayer setURL:[NSURL URLWithString:@"URL_HERE"]];
    [[self view] addSubview:videoPlayer];

    [videoPlayer play];

Features
----------

**Looping**

    [videoPlayer setEndAction:AWEasyVideoPlayerEndActionLoop];

**Muting**

    [videoPlayer setMuted:YES];

Delegate
----------

Set the delegate:

    [videoPlayer setDelegate:self];

**Receive Error Notices**

    -(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer encounteredError:(NSError *)error {
    
        NSLog(@"Encountered error: %@",[error localizedDescription]);
    
    }

**Receive Status Updates**

    -(void)videoPlayer:(AWEasyVideoPlayer *)videoPlayer changedState:(AWEasyVideoPlayerState)state {
    
        NSLog(@"Video player state changed: %ld",state);

    }