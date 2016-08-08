//
//  PlayerViewController.h
//  3DVideoV2
//
//  Created by Lei on 5/31/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController : UIViewController<AVPlayerItemOutputPullDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *videoPlayedTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;


@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;

@property (strong, nonatomic) IBOutlet UIView *offsetSilderBackground;

@property (strong, nonatomic) NSURL *videoURL;

-(id)initWithURL:(NSURL *)url;

@end
