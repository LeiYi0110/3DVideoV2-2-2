//
//  VideoCell.h
//  PhotoCollectionView
//
//  Created by Lei on 5/30/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoResource.h"

@interface VideoCell : UICollectionViewCell

/*
@property (nonatomic, strong) UIImage *descImage;
@property (nonatomic, strong) NSString *videoName;

@property (nonatomic, strong) NSURL *url;
 */

@property (nonatomic, strong) VideoResource *videoSource;

@end
