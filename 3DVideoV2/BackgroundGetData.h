//
//  BackgroundGetData.h
//  BRFinance_iPhone
//
//  Created by Lei on 4/10/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerSideAPI.h"

@interface BackgroundGetData : ServerSideAPI<ServerSideAPIDelegate>

-(id)init;

-(void)refreshCacheSecurityData;



@end
