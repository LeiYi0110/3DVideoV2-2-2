//
//  LocalVideoViewController.m
//  3DVideoV2
//
//  Created by Lei on 6/2/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "LocalVideoViewController.h"
#import "PlayerViewController.h"
#import "VideoResource.h"
#import "APLViewController.h"
#import "VideoLocalCollectionViewCell.h"
#import "LocalVideoCellImageInfo.h"

@interface LocalVideoViewController ()

@end

@implementation LocalVideoViewController
static NSString * const CellLocalVideoReuseIdentifier = @"localVideoCell";

static CGSize AssetGridThumbnailSize;


@synthesize localVideoCollectionView;
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"本地视频";
    self.api = [[ServerSideAPI alloc] init];
    [self.api setDelegate:self];
    
    [self.localVideoCollectionView registerNib:[UINib nibWithNibName:@"VideoLocalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellLocalVideoReuseIdentifier];
    
    //[self.localVideoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellLocalVideoReuseIdentifier];
    [self.localVideoCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self getImageFromStart];
    /*
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                
                
                
                
                
                
                break;
            case PHAuthorizationStatusRestricted:
                
              
                
                break;
            case PHAuthorizationStatusDenied:
                
                
                
                break;
            default:
                break;
        }
    }];
     */
    
    
    
    
    
    
}
-(void)getImageFromStart
{
    self.fetchResult2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    if (self.fetchResult2.count == 0) {
        return;
    }
    
    PHAssetCollection *assetCollection = self.fetchResult2[0];//[[PHAssetCollection alloc] init]  ;
    //assetCollection.
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    //NSLog(@"video count is %d",assetsFetchResult.count);
    
    
    self.assetsFetchResults = assetsFetchResult;//[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.localVideoCollectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    [self.localVideoCollectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count = (int)self.assetsFetchResults.count;
    return count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    //UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    VideoLocalCollectionViewCell *cell = (VideoLocalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellLocalVideoReuseIdentifier forIndexPath:indexPath];

    /*
    PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager]
     requestImageDataForAsset:asset
     options:imageRequestOptions
     resultHandler:^(NSData *imageData, NSString *dataUTI,
                     UIImageOrientation orientation,
                     NSDictionary *info)
     {
         NSLog(@"info = %@", info);
         
         UIImage *image = [UIImage imageWithData:imageData];
         //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
         //[imageView setImage:image];
         //[cell addSubview:imageView];
         [cell.locaoVideoImageView setImage:image];

     }];
     */
    
    LocalVideoCellImageInfo *imageInfo = [[LocalVideoCellImageInfo alloc] initWithPHAsset:asset cell:cell];
    
    [self performSelectorInBackground:@selector(setImage:) withObject:imageInfo];
    

   
    return cell;
}

-(void)setImage:(LocalVideoCellImageInfo *)imageInfo
{
    PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager]
     requestImageDataForAsset:imageInfo.asset
     options:imageRequestOptions
     resultHandler:^(NSData *imageData, NSString *dataUTI,
                     UIImageOrientation orientation,
                     NSDictionary *info)
     {
         NSLog(@"info = %@", info);
         
         UIImage *image = [UIImage imageWithData:imageData];
         //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
         //[imageView setImage:image];
         //[cell addSubview:imageView];
         //NSLog(@"%f",imageInfo.asset.duration);
         
         [imageInfo.cell.labelTime setText:[self convertSecondsToString:imageInfo.asset.duration]];
         [imageInfo.cell.locaoVideoImageView setImage:image];
         
     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return CGSizeMake(self.view.bounds.size.width/2 - 8, self.view.bounds.size.width/2);
    return CGSizeMake(collectionView.bounds.size.width/3 - 8, collectionView.bounds.size.width/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 2, 0, 2);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0f;//3.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    PlayerViewController *playerViewController = [[PlayerViewController alloc] init];
    [self.navigationController pushViewController:playerViewController animated:YES];
    */
    self.selectedIndexPath = indexPath;
    
    
    /*
    NSString *checkNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"checkNum"];
    if (checkNum == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入序列号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
        return;
    }
     */
     
    

    [self performSegueWithIdentifier:@"showPlayer" sender:self];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"0");
    }
    else//OK
    {
        NSLog(@"1");
        [self showHUD];
        self.checkNum = [alertView textFieldAtIndex:0].text;
        [self.api setCheckNum:self.checkNum];
        
    }
}

-(BOOL)didReceivedDicData:(NSDictionary *)receivedData apiKey:(APIKey)apiKey
{
    int status = [[receivedData valueForKey:@"Status"] intValue];
    if (status == 1) {
        [self removeHUD];
        [[NSUserDefaults standardUserDefaults] setObject:self.checkNum  forKey:@"checkNum"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"showPlayer" sender:self];
        
    }
    else
    {
        [self showConpleteHUDWithText:@"序列号无效"];
        
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue");
    //[self.navigationController supportedInterfaceOrientations] = UIInterfaceOrientationMaskLandscape;
    //self.navigationController.supportedInterfaceOrientations =
    
    
    if ([[segue identifier] isEqualToString:@"showPlayer"]) {
        
        PHAsset *asset = self.assetsFetchResults[self.selectedIndexPath.item];
        //VideoResource *videoResource = [[VideoResource alloc] initWithDic:[self.dataSource objectAtIndex:self.selectedIndexPath.item]];
        PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
        [options setNetworkAccessAllowed:YES];
        //options canHandleAdjustmentData
        /*
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        options.version = .Original
        PHImageManager.defaultManager().requestAVAssetForVideo(mPhasset, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [NSObject : AnyObject]?) -> Void in
            
            if let urlAsset = asset as? AVURLAsset {
                let localVideoUrl : NSURL = urlAsset.URL
                completionHandler(responseURL : localVideoUrl)
            } else {
                completionHandler(responseURL : nil)
            }
        })
         */
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
            // Use the AVAsset avAsset
            
            
            
            APLViewController *aplViewController = (APLViewController *)[segue destinationViewController];
            aplViewController.avAssect = avAsset;
            aplViewController.isOnline = NO;
            //aplViewController.videoTitle = [asset valueForKey:@"filename"];
            
            
        }];
        
        
        /*
        [asset requestContentEditingInputWithOptions:options
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageURL = contentEditingInput;
                                       
                                       APLViewController *aplViewController = (APLViewController *)[segue destinationViewController];
                                       aplViewController.videoURL = [NSURL URLWithString:@"file:///var/mobile/Media/DCIM/100APPLE/IMG_0590.mp4"];//[NSURL fileURLWithPath:@"file:///var/mobile/Media/DCIM/100APPLE/IMG_0590.mp4"];//
                                       //contentEditingInput.fullSizeImageURL;
                                       NSLog(@"url is %@",aplViewController.videoURL.absoluteString);
                                   }];
         */
        
        
        
    }
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)showHUD
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController != nil ? self.navigationController.view:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
}
-(void)showConpleteHUDWithText:(NSString *)text
{
    [self removeHUD];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] ;
    
    
    HUD.customView = imageView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    [self performSelector:@selector(removeHUD) withObject:nil afterDelay:0.8];
}

-(void)removeHUD
{
    if (HUD != nil) {
        [HUD hide:YES];
        [HUD removeFromSuperview];
        HUD = nil;
    }
    
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
@end
