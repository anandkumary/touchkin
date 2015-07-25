//
//  TKDataEngine.m
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKDataEngine.h"
#import "MLNetworkModel.h"
#import "MYCircle.h"
#import "OthersCircle.h"

static NSString * const KDEVICETOKEN = @"deviceToken";
static NSString * const KSESSIONID = @"id";
static NSString * const KPHONE = @"mobile";

static NSString * const KEXPIRE = @"exp";
static NSString * const KIAT = @"iat";
static NSString * const KSESSIONTOKEN = @"token";
static NSString * const KPHONEVERIFIED = @"mobile_verified";
static NSString * const KEMAIL = @"email";
static NSString * const KFNAME = @"first_name";
static NSString * const KLNAME = @"last_name";
static NSString * const KGENDER = @"gender";

@interface TKDataEngine ()

@property (nonatomic, strong) MLNetworkModel *model;
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

-(NSString *) getUserId {
    
     return [[NSUserDefaults standardUserDefaults] objectForKey:KSESSIONID];
}

-(NSString *) getSessionToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:KSESSIONTOKEN];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KSESSIONTOKEN] forKey:KSESSIONTOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KEXPIRE] forKey:KEXPIRE];
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KIAT] forKey:KIAT];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDict[KPHONEVERIFIED] forKey:KPHONEVERIFIED];
    
    if(![userDict[KEMAIL] isKindOfClass:[NSNull class]]){
        
        [[NSUserDefaults standardUserDefaults] setObject:userDict[KEMAIL] forKey:KEMAIL];
    }
    
    if(![userDict[KFNAME] isKindOfClass:[NSNull class]]){
        
        [[NSUserDefaults standardUserDefaults] setObject:userDict[KFNAME] forKey:KFNAME];
    }

    if(![userDict[KLNAME] isKindOfClass:[NSNull class]]){
        
        [[NSUserDefaults standardUserDefaults] setObject:userDict[KLNAME] forKey:KLNAME];
    }
        
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) getMyFamilyInfo {
    //user/family
    
    if(!self.model){
        self.model = [[MLNetworkModel alloc] init];
    }
    
    self.familyList = nil;
    
    [self.model getRequestPath:@"user/family" withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        // NSLog(@"res = %@",responseObject);
        
        NSDictionary *dict = responseObject;
        
        [self parseCareGiverFor:dict[@"care_givers"]];
        [self parseCareReciverFor:dict[@"care_receivers"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFamilyCircle" object:nil];
    }];
}

-(void) parseCareGiverFor:(NSArray *)careGiverList {
    
    if(!self.familyList){
        self.familyList = [[NSMutableArray alloc] init];
    }
    
    MyCircle *circle = [[MyCircle alloc] initWithArray:careGiverList];
    circle.userName = @"Me";
    circle.userId = [[TKDataEngine sharedManager] getUserId];
    
    [self.familyList addObject:circle];
    
}

-(void) parseCareReciverFor:(NSArray *)careRecList {
   
    if(!self.familyList){
        self.familyList = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary *dict in careRecList) {
        
        OthersCircle *circle = [[OthersCircle alloc] initWithDictionary:dict];
        
        [self.familyList addObject:circle];
        
    }
}
@end
