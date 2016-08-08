/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This view controller handles the UI to load assets for playback and for adjusting the luma and chroma values. It also sets up the AVPlayerItemVideoOutput, from which CVPixelBuffers are pulled out and sent to the shaders for rendering.
 */

#import "APLViewController.h"
#import "APLEAGLView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PlayerInstance.h"

# define ONE_FRAME_DURATION 0.03
# define LUMA_SLIDER_TAG 0
# define CHROMA_SLIDER_TAG 1

static void *AVPlayerItemStatusContext = &AVPlayerItemStatusContext;

@interface APLImagePickerController : UIImagePickerController

@end

@implementation APLImagePickerController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

@interface APLViewController ()
{
    AVPlayer *_player;
    dispatch_queue_t _myVideoOutputQueue;
    id _notificationToken;
    id _timeObserver;
}

@property (nonatomic, weak) IBOutlet APLEAGLView *playerView;
@property (nonatomic, weak) IBOutlet UISlider *chromaLevelSlider;
@property (nonatomic, weak) IBOutlet UISlider *lumaLevelSlider;
@property (nonatomic, weak) IBOutlet UILabel *currentTime;
@property (nonatomic, weak) IBOutlet UIView *timeView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property UIPopoverController *popover;

@property AVPlayerItemVideoOutput *videoOutput;
@property CADisplayLink *displayLink;

@property (strong, nonatomic)  IBOutlet UISlider *offsetSlider;

@property (weak, nonatomic) IBOutlet UISlider *partCountSlider;





- (IBAction)updateLevels:(id)sender;
- (IBAction)loadMovieFromCameraRoll:(id)sender;
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

- (void)displayLinkCallback:(CADisplayLink *)sender;

@end


@implementation APLViewController
//@synthesize asset;
@synthesize videoURL;

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViewDidLoad];
    
    
    //[self.playerView setFrame:CGRectMake(0, 0, 1920.0f/3, 1080.0f/3)];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
     tapGesture.numberOfTapsRequired=1;
    [self.playerView addGestureRecognizer:tapGesture];
    
    self.isSeeking = NO;
    
    
}



-(void)initViewDidLoad
{
    self.playerView.lumaThreshold = 1.0f;//[[self lumaLevelSlider] value];
    self.playerView.chromaThreshold = 1.0f;//[[self chromaLevelSlider] value];
    

    _player = [PlayerInstance sharedSingleton].player;//[[AVPlayer alloc] init];
    [_player seekToTime:kCMTimeZero];
    
    [self addTimeObserverToPlayer];
    
    // Setup CADisplayLink which will callback displayPixelBuffer: at every vsync.
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[self displayLink] setPaused:YES];
    
    // Setup AVPlayerItemVideoOutput with the required pixelbuffer attributes.
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    _myVideoOutputQueue = dispatch_queue_create("myVideoOutputQueue", DISPATCH_QUEUE_SERIAL);
    [[self videoOutput] setDelegate:self queue:_myVideoOutputQueue];
    
    [self initSlider];

}

-(void)initSlider
{
    /*
    CGFloat sliderHeight = self.view.frame.size.height*1.9/3;
    self.offsetSlider = [[UISlider alloc] init];
    self.offsetSlider.maximumValue = 20.0f;
    self.offsetSlider.value = 9.0f;
    [self.offsetSlider addTarget:self action:@selector(updateLevels:) forControlEvents:UIControlEventValueChanged];
    CGRect frame = CGRectMake(self.view.frame.size.width - (sliderHeight/2 + 30), self.view.frame.size.height/2, sliderHeight, 30);
    self.offsetSlider.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.offsetSilderBackground = [[UIView alloc] initWithFrame:frame];    
    [self.offsetSilderBackground addSubview:self.offsetSlider];
    

    self.offsetSilderBackground.transform = CGAffineTransformMakeRotation(1.57079633*3);
    self.offsetSilderBackground.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.playerView addSubview:self.offsetSilderBackground];
    [self.offsetSilderBackground setBackgroundColor: [UIColor blackColor]];
    [self.offsetSilderBackground setAlpha:0.6f];
     */
    
    NSLog(@"width is %f, height is %f",self.view.frame.size.width,self.view.frame.size.height);
    
    CGFloat sliderHeight = self.view.frame.size.width*1.9/3;
    self.offsetSlider = [[UISlider alloc] init];
    self.offsetSlider.maximumValue = 20.0f;
    self.offsetSlider.value = 2.0f;
    [self.offsetSlider addTarget:self action:@selector(updateLevels:) forControlEvents:UIControlEventValueChanged];
    CGRect frame = CGRectMake(self.view.frame.size.height - (sliderHeight/2 + 30), self.view.frame.size.width/2, sliderHeight, 30);
    self.offsetSlider.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.offsetSilderBackground = [[UIView alloc] initWithFrame:frame];
    [self.offsetSilderBackground addSubview:self.offsetSlider];
    
    
    self.offsetSilderBackground.transform = CGAffineTransformMakeRotation(1.57079633*3);
    self.offsetSilderBackground.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.playerView addSubview:self.offsetSilderBackground];
    [self.offsetSilderBackground setBackgroundColor: [UIColor blackColor]];
    [self.offsetSilderBackground setAlpha:0.6f];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    //[self.playerView setFrame:CGRectMake(0, 0, 1920.0f/3, 1080.0f/3)];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    ////////////////////////////////////////////////////////////////////////
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:AVPlayerItemStatusContext];
    [self addTimeObserverToPlayer];
    
    /*Added by Lei*/
    /*
    if ([_player currentItem] == nil) {
        [[self lumaLevelSlider] setEnabled:YES];
        [[self chromaLevelSlider] setEnabled:YES];
        [[self playerView] initView];
        [[self playerView] setupGL];
    }
    */
    //[[self playerView] initView];
    //[self setupPlaybackForURL:[[NSBundle mainBundle] URLForResource:@"4" withExtension:@"MP4"]];
    //[self setupPlaybackForURL:[[NSBundle mainBundle] URLForResource:@"afd" withExtension:@"mp4"]];
    
    
    //[self setupPlaybackForURL:[NSURL URLWithString:@"http://120.76.102.116/video/37.mp4"]];
    
    
    /*******************************************************************************************/
    self.playerView.offsetNum = 2*(int)[self.offsetSlider value] + 1;
    
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
    //if ([_player currentItem] == nil) {
    if (([_player currentTime].value == kCMTimeZero.value && _isOnline) || !_isOnline) {
        [[self lumaLevelSlider] setEnabled:YES];
        [[self chromaLevelSlider] setEnabled:YES];
        [[self playerView] initView];
        [[self playerView] setupGL];
    }
     */
    [[self lumaLevelSlider] setEnabled:YES];
    [[self chromaLevelSlider] setEnabled:YES];
    [[self playerView] initView];
    [[self playerView] setupGL];
    //[self setupPlaybackForURL:[NSURL URLWithString:@"http://120.76.102.116/video/37.mp4"]];
    
    if (_isOnline) {
        [self setupPlaybackForURL:self.videoURL];
    }
    else
    {
        [self setupPlaybackForAVAsset:self.avAssect];
    }
    //[self setupPlaybackForURL:self.videoURL];
    self.videoTitleLabel.text = self.videoTitle;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:AVPlayerItemStatusContext];
    [self removeTimeObserverFromPlayer];
    
    if (_notificationToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notificationToken name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _notificationToken = nil;
    }
    
    [super viewWillDisappear:animated];
    
    
}

#pragma mark - Utilities

- (IBAction)updateLevels:(id)sender
{
    
    
    /*
     NSInteger tag = [sender tag];
     
     switch (tag) {
     case LUMA_SLIDER_TAG: {
     self.playerView.lumaThreshold = [[self lumaLevelSlider] value];
     break;
     }
     case CHROMA_SLIDER_TAG: {
     self.playerView.chromaThreshold = [[self chromaLevelSlider] value];
     break;
     }
     default:
     break;
     }
     */
    self.playerView.offsetNum = 2*(int)[self.offsetSlider value] + 1;
    //self.playerView.partCount = (int)[self.partCountSlider value]*4;
}

- (IBAction)loadMovieFromCameraRoll:(id)sender
{
    [_player pause];
    [[self displayLink] setPaused:YES];
    
    if ([[self popover] isPopoverVisible]) {
        [[self popover] dismissPopoverAnimated:YES];
    }
    // Initialize UIImagePickerController to select a movie from the camera roll
    
    //[self setupPlaybackForURL:[[NSBundle mainBundle] URLForResource:@"7" withExtension:@"MP4"]];
    
    
    APLImagePickerController *videoPicker = [[APLImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:videoPicker];
        self.popover.delegate = self;
        [[self popover] presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else {
        [self presentViewController:videoPicker animated:YES completion:nil];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //self.toolbar.hidden = !self.toolbar.hidden;
    //self.offsetSlider.hidden = !self.offsetSlider.hidden;
    
    self.offsetSilderBackground.hidden = !self.offsetSilderBackground.hidden;
    self.playerTopView.hidden = !self.playerTopView.hidden;
    
    self.playerBottomView.hidden = !self.playerBottomView.hidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Playback setup


-(void)setupPlaybackForAVAsset:(AVAsset *)asset
{
    [[_player currentItem] removeOutput:self.videoOutput];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    NSLog(@"%lld",asset.duration.value/asset.duration.timescale);
    
    self.videoDurationLabel.text = [self convertSecondsToString:asset.duration.value/asset.duration.timescale];
    
    self.currentTimeSlider.maximumValue = asset.duration.value/asset.duration.timescale;
    
    
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        
        if ([asset statusOfValueForKey:@"tracks" error:nil] == AVKeyValueStatusLoaded) {
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            if ([tracks count] > 0) {
                // Choose the first video track.
                AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
                [videoTrack loadValuesAsynchronouslyForKeys:@[@"preferredTransform"] completionHandler:^{
                    
                    if ([videoTrack statusOfValueForKey:@"preferredTransform" error:nil] == AVKeyValueStatusLoaded) {
                        CGAffineTransform preferredTransform = [videoTrack preferredTransform];
                        
                        /*
                         The orientation of the camera while recording affects the orientation of the images received from an AVPlayerItemVideoOutput. Here we compute a rotation that is used to correctly orientate the video.
                         */
                        self.playerView.preferredRotation = -1 * atan2(preferredTransform.b, preferredTransform.a);
                        
                        [self addDidPlayToEndTimeNotificationForPlayerItem:item];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [item addOutput:self.videoOutput];
                            [_player replaceCurrentItemWithPlayerItem:item];
                            [self.videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:ONE_FRAME_DURATION];
                            [_player play];
                        });
                        
                    }
                    
                }];
            }
        }
        
    }];
}
- (void)setupPlaybackForURL:(NSURL *)URL
{
    /*
     Sets up player item and adds video output to it.
     The tracks property of an asset is loaded via asynchronous key value loading, to access the preferred transform of a video track used to orientate the video while rendering.
     After adding the video output, we request a notification of media change in order to restart the CADisplayLink.
     */
    
    // Remove video output from old item, if any.
    [[_player currentItem] removeOutput:self.videoOutput];
    
    /*let movieURL = NSBundle.mainBundle().URLForResource("7", withExtension: "MP4")!*/
    //URL = [[NSBundle mainBundle] URLForResource:@"7" withExtension:@"MP4"];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
    AVAsset *asset = [item asset];
    NSLog(@"%lld",asset.duration.value/asset.duration.timescale);
    
    self.videoDurationLabel.text = [self convertSecondsToString:asset.duration.value/asset.duration.timescale];
    
    self.currentTimeSlider.maximumValue = asset.duration.value/asset.duration.timescale;
    
    
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        
        if ([asset statusOfValueForKey:@"tracks" error:nil] == AVKeyValueStatusLoaded) {
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            if ([tracks count] > 0) {
                // Choose the first video track.
                AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
                [videoTrack loadValuesAsynchronouslyForKeys:@[@"preferredTransform"] completionHandler:^{
                    
                    if ([videoTrack statusOfValueForKey:@"preferredTransform" error:nil] == AVKeyValueStatusLoaded) {
                        CGAffineTransform preferredTransform = [videoTrack preferredTransform];
                        
                        /*
                         The orientation of the camera while recording affects the orientation of the images received from an AVPlayerItemVideoOutput. Here we compute a rotation that is used to correctly orientate the video.
                         */
                        self.playerView.preferredRotation = -1 * atan2(preferredTransform.b, preferredTransform.a);
                        
                        [self addDidPlayToEndTimeNotificationForPlayerItem:item];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [item addOutput:self.videoOutput];
                            [_player replaceCurrentItemWithPlayerItem:item];
                            [self.videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:ONE_FRAME_DURATION];
                            [_player play];
                        });
                        
                    }
                    
                }];
            }
        }
        
    }];
    
}

- (void)stopLoadingAnimationAndHandleError:(NSError *)error
{
    if (error) {
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title for animation load error");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVPlayerItemStatusContext) {
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                break;
            case AVPlayerItemStatusReadyToPlay:
                self.playerView.presentationRect = [[_player currentItem] presentationSize];
                break;
            case AVPlayerItemStatusFailed:
                [self stopLoadingAnimationAndHandleError:[[_player currentItem] error]];
                break;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)addDidPlayToEndTimeNotificationForPlayerItem:(AVPlayerItem *)item
{
    if (_notificationToken)
        _notificationToken = nil;
    
    /*
     Setting actionAtItemEnd to None prevents the movie from getting paused at item end. A very simplistic, and not gapless, looped playback.
     */
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    _notificationToken = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        // Simple item playback rewind.
        [[_player currentItem] seekToTime:kCMTimeZero];
    }];
}

- (void)syncTimeLabel
{
    
    double seconds = CMTimeGetSeconds([_player currentTime]);
    if (!isfinite(seconds)) {
        seconds = 0;
    }
    
    int secondsInt = round(seconds);
    
    /*
    int minutes = secondsInt/60;
    secondsInt -= minutes*60;
    
    self.currentTime.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.currentTime.textAlignment = NSTextAlignmentCenter;
    
    self.currentTime.text = [NSString stringWithFormat:@"%.2i:%.2i", minutes, secondsInt];
     */
    [self.currentTime setHidden:YES];
    self.videoPlayedTimeLabel.text = [self convertSecondsToString: secondsInt];//[NSString stringWithFormat:@"%.2i:%.2i", minutes, secondsInt];
    self.currentTimeSlider.value = seconds;
}

- (void)addTimeObserverToPlayer
{
    /*
     Adds a time observer to the player to periodically refresh the time label to reflect current time.
     */
    if (_timeObserver)
        return;
    /*
     Use __weak reference to self to ensure that a strong reference cycle is not formed between the view controller, player and notification block.
     */
    __weak APLViewController* weakSelf = self;
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 10) queue:dispatch_get_main_queue() usingBlock:
                     ^(CMTime time) {
                         [weakSelf syncTimeLabel];
                     }];
}

- (void)removeTimeObserverFromPlayer
{
    if (_timeObserver)
    {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

#pragma mark - CADisplayLink Callback

- (void)displayLinkCallback:(CADisplayLink *)sender
{
    //[self.playerView setFrame:CGRectMake(0, 0, 1920.0f/3, 1080.0f/3)];
    
    /*
     The callback gets called once every Vsync.
     Using the display link's timestamp and duration we can compute the next time the screen will be refreshed, and copy the pixel buffer for that time
     This pixel buffer can then be processed and later rendered on screen.
     */
    //CGRect frame = CGRectMake(0, 0, 736, 414);
    NSLog(@"view controller view width is %f, height is %f",self.playerView.frame.size.width,self.playerView.frame.size.height);
    //self.playerView.frame = frame;
    CMTime outputItemTime = kCMTimeInvalid;
    
    // Calculate the nextVsync time which is when the screen will be refreshed next.
    CFTimeInterval nextVSync = ([sender timestamp] + [sender duration]);
    
    outputItemTime = [[self videoOutput] itemTimeForHostTime:nextVSync];
    
    if ([[self videoOutput] hasNewPixelBufferForItemTime:outputItemTime]) {
        CVPixelBufferRef pixelBuffer = NULL;
        pixelBuffer = [[self videoOutput] copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:NULL];
        
        [[self playerView] displayPixelBuffer:pixelBuffer];
        
        if (pixelBuffer != NULL) {
            CFRelease(pixelBuffer);
        }
    }
}

#pragma mark - AVPlayerItemOutputPullDelegate

- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender
{
    // Restart display link.
    [[self displayLink] setPaused:NO];
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(APLImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.popover dismissPopoverAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([_player currentItem] == nil) {
        [[self lumaLevelSlider] setEnabled:YES];
        [[self chromaLevelSlider] setEnabled:YES];
        [[self playerView] setupGL];
    }
    
    // Time label shows the current time of the item.
    if (self.timeView.hidden) {
        [self.timeView.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        [self.timeView.layer setCornerRadius:5.0f];
        [self.timeView.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:0.15].CGColor];
        [self.timeView.layer setBorderWidth:1.0f];
        self.timeView.hidden = NO;
        self.currentTime.hidden = NO;
    }
    
    [self setupPlaybackForURL:info[UIImagePickerControllerReferenceURL]];
    
    picker.delegate = nil;
}

- (void)imagePickerControllerDidCancel:(APLImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Make sure our playback is resumed from any interruption.
    if ([_player currentItem]) {
        [self addDidPlayToEndTimeNotificationForPlayerItem:[_player currentItem]];
    }
    
    [[self videoOutput] requestNotificationOfMediaDataChangeWithAdvanceInterval:ONE_FRAME_DURATION];
    [_player play];
    
    picker.delegate = nil;
}

# pragma mark - Popover Controller Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // Make sure our playback is resumed from any interruption.
    if ([_player currentItem]) {
        [self addDidPlayToEndTimeNotificationForPlayerItem:[_player currentItem]];
    }
    [[self videoOutput] requestNotificationOfMediaDataChangeWithAdvanceInterval:ONE_FRAME_DURATION];
    [_player play];
    
    self.popover.delegate = nil;
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.view) {
        // Ignore touch on toolbar.
        return NO;
    }
    return YES;
}

- (IBAction)playButtonPress:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        [_player pause];//[_player pause];
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else
    {
        //[_player play];
        [_player play];
        [button setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    button.tag = (button.tag + 1)%2;
    
}
-(NSString *)convertSecondsToString:(long long)seconds
{
    NSString *strSeconds = [NSString stringWithFormat:@"%lld",seconds%60];
    NSString *strMinute = [NSString stringWithFormat:@"%lld",seconds%3600/60];
    NSString *strHour = [NSString stringWithFormat:@"%lld",seconds/3600];
    
    if (seconds < 3600) {
        return [NSString stringWithFormat:@"%@:%@", [self addZeroWithStr:strMinute],[self addZeroWithStr:strSeconds]];
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@",[self addZeroWithStr:strHour],[self addZeroWithStr:strMinute],[self addZeroWithStr:strSeconds]];
    
}
-(NSString *)addZeroWithStr:(NSString *)str
{
    if (str.length < 2) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}
/*
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
 */

- (IBAction)backPress:(id)sender {
    
    [_player pause];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //_player = nil;
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)currentTimeChange:(id)sender {
    if ([sender isKindOfClass:[UISlider class]] && !self.isSeeking)
    {
        self.isSeeking = YES;
        UISlider* slider = sender;
        
        CMTime playerDuration = [self playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration))
        {
            float minValue = [slider minimumValue];
            float maxValue = [slider maximumValue];
            float value = [slider value];
            
            double time = duration * (value - minValue) / (maxValue - minValue);
            
            [_player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isSeeking = NO;
                });
            }];
        }
    }
}
- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [_player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

@end
