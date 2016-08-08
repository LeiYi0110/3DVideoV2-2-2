//
//  BackgroundGetData.m
//  BRFinance_iPhone
//
//  Created by Lei on 4/10/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "BackgroundGetData.h"

@implementation BackgroundGetData

-(id)init
{
    self = [super init];
    
    if (self) {
        [self setDelegate:self];
    }
    return self;
}

-(BOOL)didReceivedDicData:(NSDictionary *)receivedData apiKey:(APIKey)apiKey
{
    
    //BOOL result = [[receivedData valueForKey:@"result"] boolValue];
    int serverSideStatus = [[receivedData valueForKey:@"Status"] intValue];
    
    
    if (serverSideStatus == 1) {
        if (apiKey == APIKeyVideoKeyValue) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (NSDictionary *item in [receivedData valueForKey:@"Data"]) {
                NSLog(@"%@",item);
                [dic setObject:[item valueForKey:@"Url"] forKey:[item valueForKey:@"Name"]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:dic  forKey:@"videoData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    return YES;
}

-(BOOL)successReceiveDataWithResult:(BOOL)result status:(int)status
{
    return status == 1;
}


-(void)refreshCacheSecurityData
{
    [self getVideoKeyValue];
}



@end
