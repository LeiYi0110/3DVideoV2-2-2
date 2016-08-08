//
//  ServerSideAPI.h
//  3DVideoV2
//
//  Created by Lei on 5/30/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ServerSideConfig.h"

#import "ASIFormDataRequest.h"



@protocol ServerSideAPIDelegate <NSObject>

//-(NSDictionary *)getResponse;
@optional

-(void)didReceiveData:(NSArray *)receivedData apiKey:(APIKey)apiKey;
-(void)didReceiveDicData:(NSDictionary *)receivedData apiKey:(APIKey)apiKey;
-(void)failToReceiveData:(NSError *)error apiKey:(APIKey)apiKey;
-(void)didReceiveValue:(NSString *)value apiKey:(APIKey)apiKey;


-(BOOL)didReceivedDicData:(NSDictionary *)receivedData apiKey:(APIKey)apiKey; //v3


@end


@interface ServerSideAPI : NSObject//<NSXMLParserDelegate>
{
    ASIHTTPRequest *_request;
    
    
}
@property (strong, nonatomic) NSString *UID;
-(void)getResult:(NSURL *)url;
- (void)getSingleResultHttp:(NSURL *)url;


@property (strong, nonatomic) ASIFormDataRequest *apiFormDataRequest;


@property (nonatomic, assign) id<ServerSideAPIDelegate> delegate;

-(void)getVideoList;
-(void)getVideoKeyValue;
-(void)setCheckNum:(NSString *)checkNum;

-(void)test;



@end
