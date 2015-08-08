//
//  UserLastUpdate.h
//  TouchKin
//
//  Created by Anand Kumar on 8/8/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyConnection.h"
@interface UserLastUpdate : NSObject

@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * lastUpdatedId;
@property (nonatomic, copy) NSString * receiverUserID;
@property (nonatomic, copy) NSString * objectId;

@property (nonatomic, strong) MyConnection *userInfo;

- (instancetype)initWithDict:(NSDictionary *) dict;
@end
