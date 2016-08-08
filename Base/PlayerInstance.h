//
//  PlayerInstance.h
//  3DVideoV2
//
//  Created by Lei on 6/15/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerInstance : NSObject

@property (strong, nonatomic)  AVPlayer *player;


+ (PlayerInstance *)sharedSingleton;

@end
