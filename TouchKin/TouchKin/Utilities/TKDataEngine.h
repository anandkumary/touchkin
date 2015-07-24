//
//  TKDataEngine.h
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKDataEngine : NSObject {
    
}
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) NSMutableArray *familyList;


-(NSString *) getDeviceToken;
-(NSString *) getUserId;
-(NSString *) getPhoneNumber;
-(NSString *) getSessionToken;
-(double) getExpDate;

-(void) saveUserInfo:(NSDictionary *)userDict;

-(void) getMyFamilyInfo;

+ (id)sharedManager;

@end
