//
//  UserActivity.h
//  TouchKin
//
//  Created by Anand Kumar on 8/7/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActivity : NSObject

@property (nonatomic, copy) NSString * updatedTime;
@property (nonatomic, copy) NSString * activityId;
@property (nonatomic, copy) NSString * activityType;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, assign) NSInteger batteryLevel;
@property (nonatomic, assign) NSInteger wifiStrength;
@property (nonatomic, assign) NSInteger threeGStrength;

@property (nonatomic, strong) NSDictionary *activityStatus;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
