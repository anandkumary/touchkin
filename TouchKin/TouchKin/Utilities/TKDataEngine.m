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
#import "MyConnection.h"
#import "AppDelegate.h"

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
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
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
       
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];

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
        
        
        if(error == nil){
            
            NSDictionary *dict = responseObject;
            
            [self parseCareGiverFor:dict[@"care_givers"]];
            [self parseCareReciverFor:dict[@"care_receivers"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFamilyCircle" object:nil];
        }
        else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyFamilyCircleError" object:nil];
           
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel showAlertViewWithText:@"Oops something went worng. \n Please try Again" alertType:ALERTDEFAULTTYPE withHandler:^(NSInteger alertTag, NSError *error) {
                
                if(alertTag == 0){
                    [self getMyFamilyInfo];
                }
            }];
        }
                
       
    }];
}

-(void) parseCareGiverFor:(NSArray *)careGiverList {
    
    if(!self.familyList){
        self.familyList = [[NSMutableArray alloc] init];
    }
    
    if(careGiverList.count){
        
        MyCircle *circle = [[MyCircle alloc] initWithArray:careGiverList];
        circle.userName = @"Me";
        circle.userId = [[TKDataEngine sharedManager] getUserId];
        
        [self.familyList addObject:circle];
    }
    else {
        MyCircle *circle = [[MyCircle alloc] init];
        circle.userName = @"Me";
        circle.userId = [[TKDataEngine sharedManager] getUserId];
        
        [self.familyList addObject:circle];
    }
    
}

-(void) parseCareReciverFor:(NSArray *)careRecList {
    
    if(careRecList.count){
      
        if(!self.familyList){
            self.familyList = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dict in careRecList) {
            
            OthersCircle *circle = [[OthersCircle alloc] initWithDictionary:dict];
            
            if([dict[@"care_receiver_status"] isEqualToString:@"pending"]){
                circle.isPending = YES;
            }
            [self.familyList addObject:circle];
            
        }
    }
   
}

-(void) getNewConnectionRequest {
    
    MLNetworkModel *mdl = [[MLNetworkModel alloc] init];
    
    [mdl getRequestPath:@"user/connection-requests" withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        NSDictionary *dictionary = responseObject;
        
        if(error == nil && ![dictionary isKindOfClass:[NSDictionary class]]) {
            
            for (NSDictionary *dict in responseObject) {
                
                NSLog(@"res =%@",dict);
                
                MyCircle *circle = [self.familyList objectAtIndex:0];
                
                if(!circle.requestList){
                    circle.requestList = [[NSMutableArray alloc] init];
                }
                
                MyConnection *connection = [[MyConnection alloc] init];
                connection.requestId = dict[@"id"];
                connection.nickName = dict[@"care_giver"][@"first_name"];
                connection.mobile  = dict[@"care_giver"][@"mobile"];
                connection.userId  = dict[@"care_giver"][@"id"];
                connection.yob     = [dict[@"care_giver"][@"yob"] intValue];
                
                [circle.requestList addObject:connection];
                
            }
        }
       
        NSLog(@"new connection = %@", responseObject);
        
    }];
}

-(void)getuserInfo {
    
    // /user/profile
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model getPath:@"user/profile" withParameter:nil withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        
        NSLog(@"userInfo = %@",responseObject);
        
        NSDictionary *dict = responseObject;
        
        self.userInfo = [[MyConnection alloc] initWithDictionary:dict];
    }];
}

- (NSString *) getTimeFromCurrentDateString:(NSString *)dateString {
    
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *convertString = [formatter stringFromDate:date];
    
    formatter = nil;
    
    return convertString;
    
}

- (NSString *) getTimeFromCurrentDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *convertString = [formatter stringFromDate:[NSDate date]];
    
    formatter = nil;
    
    return convertString;

}

- (NSString *) lastUpdateTimeFromDateString:(NSString *)dateString {
    
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    
    NSTimeInterval secs = [[NSDate date] timeIntervalSinceDate:date];

    return [self stringFromTimeInterval:secs];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
   // NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    NSString *convertString = @"";
    
    if(hours > 0){
        convertString = [NSString stringWithFormat:@"%02ld %@",(long)hours,((hours >1)? @"hours" : @"hour")];
        
    }
//    if(hours > 0 && minutes > 0){
//        
//        convertString = [NSString stringWithFormat:@"%02ld:%02ld mins ago",(long)hours,(long)minutes];
//
//    }
    else {
        convertString = [NSString stringWithFormat:@"%02ld %@",(long)minutes,((minutes > 10) ? @"mins" : @"min")];
    }
    return convertString;
}

- (void) receivedTouchForuserID:(NSString *)userId withType:(NSString *)type {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId CONTAINS[cd] %@",userId];
    
    NSArray *array = [self.familyList filteredArrayUsingPredicate:predicate];
        
    if(array.count){
        [array setValue:@(YES) forKey:@"didReceiveTouch"];
    }
    
    
}

@end
