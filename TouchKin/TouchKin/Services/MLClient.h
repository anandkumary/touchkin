//
//  MLClient.h
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLClient;

typedef void (^MLResponseBlock)(MLClient *sender, id responseObject , NSError *error);

@interface MLClient : NSObject

@property (nonatomic, strong) NSMutableDictionary *defaultHeaders;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

- (void) getPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler;
- (void) postPath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler;
- (void) deletePath:(NSString *)path withParameter:(NSDictionary *)params withHandler:(MLResponseBlock)handler;

@end
