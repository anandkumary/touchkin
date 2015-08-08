//
//  UserActivity.m
//  TouchKin
//
//  Created by Anand Kumar on 8/7/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "UserActivity.h"

static NSString * const USERACTIVITYUSER = @"user";
static NSString * const USERACTIVITYTYPE = @"type";
static NSString * const USERACTIVITYBATTERY = @"battery";
static NSString * const USERACTIVITYWIFI    = @"wifi_strength";
static NSString * const USERACTIVITY3G      = @"3g";
static NSString * const USERACTIVITYUPDATETIME = @"updatedAt";
static NSString * const USERACTIVITID       = @"id";
static NSString * const USERACTIVITYSTATUS  = @"stats";
static NSString * const USERACTIVITLASTUPDATES = @"lastUpdatedConnectivity";
static NSString * const USERACTIVITDATA         = @"data";

@implementation UserActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
                
        NSDictionary *dict1  = dict[USERACTIVITLASTUPDATES];
        
        self.userId = dict1[USERACTIVITYUSER];
        self.activityType = dict1[USERACTIVITYTYPE];
        self.updatedTime = dict1[USERACTIVITYUPDATETIME];
        self.activityId = dict1[USERACTIVITID];
        
        NSDictionary *batteryDict = dict1[USERACTIVITDATA];
        
        self.batteryLevel = [batteryDict[USERACTIVITYBATTERY] integerValue];
        self.threeGStrength = [batteryDict[USERACTIVITY3G] integerValue];
        self.wifiStrength  = [batteryDict[USERACTIVITYWIFI] integerValue];
        
        self.activityStatus = dict[USERACTIVITYSTATUS];
        
    }
    return self;
}

@end
