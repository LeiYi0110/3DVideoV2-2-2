//
//  LocalVideoCellImageInfo.m
//  3DVideoV2
//
//  Created by Lei on 6/15/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "LocalVideoCellImageInfo.h"

@implementation LocalVideoCellImageInfo
@synthesize asset = _asset;
@synthesize cell = _cell;

-(id)initWithPHAsset:(PHAsset *)asset cell:(VideoLocalCollectionViewCell *)cell
{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.cell = cell;
    }
    return self;
}



@end
