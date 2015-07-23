//
//  TKDataEngine.m
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKDataEngine.h"

static NSString * const KDEVICETOKEN = @"deviceToken";
static NSString * const KSESSIONID = @"id";
static NSString * const KPHONE = @"mobile";

static NSString * const KEXPIRE = @"exp";
static NSString * const KIAT = @"iat";
static NSString * const KSESSIONTOKEN = @"token";
static NSString * const KPHONEVERIFIED = @"mobile_verified";



@interface TKDataEngine ()
@end

@implementation TKDataEngine

+ (id)sharedManager {
    static TKDataEngine *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
       
    }
    return self;
}

-(void)  setToken:(NSString *)token {
    _token = token;
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KDEVICETOKEN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) getDeviceToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:KDEVICETOKEN];
}

-(void) setSessionId:(NSString *)userId {
    _sessionId = userId;
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:KSESSIONID];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) getSessionId {
    
     return [[NSUserDefaults standardUserDefaults] objectForKey:KSESSIONID];
}

-(void) setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:KPHONE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSString *) getPhoneNumber {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:KPHONE];
}

-(double) getExpDate {
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:KEXPIRE];
    return num.doubleValue;
}

-(void) saveUserInfo:(NSDictionary *)userDict {
    
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KEXPIRE] forKey:KEXPIRE];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KIAT] forKey:KIAT];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KSESSIONTOKEN] forKey:KSESSIONTOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KPHONEVERIFIED] forKey:KPHONEVERIFIED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
