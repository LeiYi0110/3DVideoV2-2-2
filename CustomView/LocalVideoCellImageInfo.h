//
//  LocalVideoCellImageInfo.h
//  3DVideoV2
//
//  Created by Lei on 6/15/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "VideoLocalCollectionViewCell.h"

@interface LocalVideoCellImageInfo : NSObject

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) VideoLocalCollectionViewCell *cell;

-(id)initWithPHAsset:(PHAsset *)asset cell:(VideoLocalCollectionViewCell *)cell;

@end
