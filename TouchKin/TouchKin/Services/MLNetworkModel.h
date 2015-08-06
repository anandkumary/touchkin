//
//  MLNetworkModel.h
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MLClient.h"

typedef void (^MLResponseHandlerBlock)(id responseObject , NSError *error);


@interface MLNetworkModel : MLClient {
    
}

@property (nonatomic, assign) BOOL addNoToken;

- (instancetype)initWithNoToken:(BOOL)noTokenAdded;
- (instancetype)initWithBaseUrl:(NSString *)urlString;

-(void) initializeDefaultHeader;

- (void) getRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler;
- (void) postRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler;
- (void) deleteRequestPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseHandlerBlock)handler;

@end
