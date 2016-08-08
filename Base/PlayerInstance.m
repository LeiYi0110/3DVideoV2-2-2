//
//  PlayerInstance.m
//  3DVideoV2
//
//  Created by Lei on 6/15/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "PlayerInstance.h"

@implementation PlayerInstance

+ (PlayerInstance *)sharedSingleton
{
    static PlayerInstance *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[PlayerInstance alloc] init];
        }
        
        
        return sharedSingleton;
    }
}
-(id)init
{
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}
@end
