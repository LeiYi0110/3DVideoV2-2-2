//
//  LocalVideoViewController.h
//  3DVideoV2
//
//  Created by Lei on 6/2/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "MBProgressHUD.h"
#import "ServerSideAPI.h"

@interface LocalVideoViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,ServerSideAPIDelegate>{
    MBProgressHUD *HUD;
}


@property (weak, nonatomic) IBOutlet UICollectionView *localVideoCollectionView;

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) PHFetchResult *fetchResult2;
@property (strong, nonnull) NSString *checkNum;

@property (strong, nonatomic) ServerSideAPI *api;

@end
