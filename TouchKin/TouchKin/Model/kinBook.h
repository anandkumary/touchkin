//
//  kinBook.h
//  TouchKin
//
//  Created by Anand kumar on 8/4/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyConnection.h"

@interface kinBook : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, copy) NSString *hdMedia;
@property (nonatomic, copy) NSString *kinId;
@property (nonatomic, copy) NSString *iPhoneMedia;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * sdMedia;
@property (nonatomic, copy) NSString * thumbnail;
@property (nonatomic, strong) MyConnection *connection;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
