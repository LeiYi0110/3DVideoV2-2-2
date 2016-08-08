//
//  ServerSideAPI.m
//  3DVideoV2
//
//  Created by Lei on 5/30/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "ServerSideAPI.h"
#import "JSONKit.h"

@implementation ServerSideAPI
@synthesize apiFormDataRequest;
@synthesize delegate;
-(void)startGetHttpRequestWithURLString:(NSString *)urlString apiKey:(APIKey)apiKey
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:apiKey],@"apiKey", nil];
    
    [request setDelegate:self];
    [request startAsynchronous];
    /*
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    
    //urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    
    
    NSLog(@"request url is %@",urlString);
    
    
    self.apiFormDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    [apiFormDataRequest setDelegate:self];
    apiFormDataRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:apiKey],@"apiKey", nil];
    
    
    
    apiFormDataRequest.timeOutSeconds = 20;
    
    apiFormDataRequest.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    [apiFormDataRequest startAsynchronous];
     */
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    
    NSNumber *apiKey = [request.userInfo objectForKey:@"apiKey"];
    
    NSLog(@"api is %@,response is %@", apiKey,responseString);
    
    
    
    
    
    [self parseJSONWithHttpResuest:request responseString:responseString];
    
    
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSNumber *apiKey = [request.userInfo objectForKey:@"apiKey"];
    NSError *error = [request error];
    
    NSLog(@"error is %@",error);
    
    
    
    
    if ([delegate respondsToSelector:@selector(failToReceiveData:apiKey:)]) {
        
        [delegate failToReceiveData:error apiKey:[apiKey intValue]];
        
    }
  
    
}

-(void)parseJSONWithHttpResuest:(ASIHTTPRequest *)request responseString:(NSString *)responseString
{
    NSNumber *apiKey = [request.userInfo objectForKey:@"apiKey"];
    //NSString *responseString = [request responseString];
    @try {
        NSDictionary *dic = [responseString objectFromJSONString];
        
        if (delegate != nil) {
            
            [delegate didReceivedDicData:dic apiKey:apiKey.intValue];
        }
        
        return;
    }
    @catch (NSException *exception) {
        NSDictionary *dic = [responseString objectFromJSONString];
        NSLog(@"message is %@",[dic valueForKey:@"message"]);
        [delegate didReceivedDicData:nil apiKey:[apiKey intValue]];
    }
    @finally {
        
    }
    
}
-(void)getVideoList
{
    APIKey apiKey = APIKeyVideoList;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASEURL,VideoList];
    
    [self startGetHttpRequestWithURLString:urlString apiKey:apiKey];
}
-(void)getVideoKeyValue
{
    APIKey apiKey = APIKeyVideoKeyValue;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASEURL,SearchKeyValue];
    
    [self startGetHttpRequestWithURLString:urlString apiKey:apiKey];
    
}
-(void)test
{
    APIKey apiKey = APIKeyVideoList;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",TestURL];
    
    [self startGetHttpRequestWithURLString:urlString apiKey:apiKey];

}
-(void)setCheckNum:(NSString *)checkNum
{
    APIKey apiKey = APIKeySetCheckNum;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",BASEURL,SetCheckNum,checkNum];
    
    [self startGetHttpRequestWithURLString:urlString apiKey:apiKey];

    

}

@end
