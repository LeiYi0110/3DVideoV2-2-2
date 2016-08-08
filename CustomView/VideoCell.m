//
//  VideoCell.m
//  PhotoCollectionView
//
//  Created by Lei on 5/30/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

-(void)layoutSubviews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    //UIImage *image = [UIImage imageNamed:@"a.jpeg"];
    CGRect imageViewFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.8);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [imageView setImage:self.videoSource.image];
    [self addSubview:imageView];
    
    CGRect labelFrame = CGRectMake(0, imageViewFrame.size.height, self.bounds.size.width, self.bounds.size.height - imageViewFrame.size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setText:self.videoSource.name];
    [self addSubview:label];
    
    
}

@end
