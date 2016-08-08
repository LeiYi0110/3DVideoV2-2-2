/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This view controller handles the UI to load assets for playback and for adjusting the luma and chroma values. It also sets up the AVPlayerItemVideoOutput, from which CVPixelBuffers are pulled out and sent to the shaders for rendering.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface APLViewController : UIViewController <AVPlayerItemOutputPullDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *videoPlayedTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;


@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;

@property (strong, nonatomic) UIView *offsetSilderBackground;


@property (strong, nonatomic) NSURL *videoURL;

@property BOOL isOnline;
@property (strong, nonatomic) AVAsset *avAssect;
//@property (strong, nonatomic) AVAsset *asset;


@property (weak, nonatomic) IBOutlet UIView *playerBottomView;


@property (weak, nonatomic) IBOutlet UIView *playerTopView;

@property BOOL isSeeking;


@property (strong, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (strong, nonatomic) NSString *videoTitle;


@end
