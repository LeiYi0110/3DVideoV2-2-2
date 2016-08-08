//
//  VideoResource.m
//  3DVideoV2
//
//  Created by Lei on 6/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "VideoResource.h"

@implementation VideoResource

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.name = [dic valueForKey:@"Name"];
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Url"]]];
        self.imageURL = [dic valueForKey:@"Image"];
    }
    return self;
}

@end
