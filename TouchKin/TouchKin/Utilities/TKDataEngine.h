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

-(NSString *) getDeviceToken;
-(NSString *) getSessionId;
-(NSString *) getPhoneNumber;
-(double) getExpDate;

-(void) saveUserInfo:(NSDictionary *)userDict;

+ (id)sharedManager;

@end
