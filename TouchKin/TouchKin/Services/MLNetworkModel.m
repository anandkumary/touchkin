//
//  MLNetworkModel.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MLNetworkModel.h"

static NSString *const KDomainUrl = @"http://162.243.49.99/";

@implementation MLNetworkModel

- (instancetype)init
{
    self = [super initWithBaseUrl:KDomainUrl];
    if (self) {
        [self initializeDefaultHeader];
    }
    return self;
}

- (instancetype)initWithBaseUrl:(NSString *)urlString
{
    self = [super initWithBaseUrl:urlString];
    if (self) {
        [self initializeDefaultHeader];
    }
    return self;
}

-(void) initializeDefaultHeader {
    
    [self.defaultHeaders setObject:@"application/json" forKey:@"Accept"];
    [self.defaultHeaders setObject:@"application/json" forKey:@"content-type"];
    
}

- (void) getRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler {
    
    [super getPath:path withParameter:params withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        //Customize the response structure as needed
        handler(responseObject,error);
    }];
}
- (void) postRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler {
    [super postPath:path withParameter:params withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        //Customize the response structure as needed
        handler(responseObject,error);
    }];
    
}
- (void) deleteRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler {
    [super deletePath:path withParameter:params withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        
        //Customize the response structure as needed
        handler(responseObject,error);
    }];
}


@end
