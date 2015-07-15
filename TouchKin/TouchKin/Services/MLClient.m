//
//  MLClient.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MLClient.h"

static NSString * const USERTOKEN = @"TOKEN";

@interface MLClient()

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic, strong) NSURL  * baseUrl;
@end

@implementation MLClient


- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        self.baseUrl = [NSURL URLWithString:baseUrl];
        self.defaultHeaders = [[NSMutableDictionary alloc]init];
        [self initalizeSession];
    }
    return self;
}

-(void) initalizeSession {
    
    self.session = [NSURLSession sharedSession];
}

-(NSURLRequest *) requestMethod:(NSString *)method withPath:(NSString *)path andParameters:(NSDictionary *)param {
    
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN];
    
    if(tokenId){
        [self.defaultHeaders setObject:[NSString stringWithFormat:@"token %@", tokenId] forKey:@"Authorization"];
    }
    
    request.HTTPMethod = method;
    request.allHTTPHeaderFields = self.defaultHeaders;
    
    if(![method isEqual:@"GET"]){
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    }
    
    return request;
}

- (void) postPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler  {
    
    NSURLRequest *request = [self requestMethod:@"POST" withPath:path andParameters:params];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        handler(self,json,err);
    }];
    [task resume];
}


- (void) getPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler {
    
    NSURLRequest *request = [self requestMethod:@"GET" withPath:path andParameters:params];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        handler(self,json,err);
        
    }];
    
    [task resume];
}


- (void) deletePath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler  {
    NSURLRequest *request = [self requestMethod:@"GET" withPath:path andParameters:params];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        handler(self,json,err);
        
    }];
    [task resume];
}
@end
