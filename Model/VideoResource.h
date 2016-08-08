//
//  VideoResource.h
//  3DVideoV2
//
//  Created by Lei on 6/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoResource : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonnull) NSURL *imageURL;

-(id)initWithDic:(NSDictionary *)dic;


@end
