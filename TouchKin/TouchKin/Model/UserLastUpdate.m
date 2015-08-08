//
//  UserLastUpdate.m
//  TouchKin
//
//  Created by Anand Kumar on 8/8/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "UserLastUpdate.h"

@implementation UserLastUpdate

- (instancetype)initWithDict:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
      
        self.receiverUserID = dict[@"receivingUser"];
        self.objectId    = dict[@"id"];
        self.updateTime  =  dict[@"updatedAt"];
        
        [self parseUserInfoFOrDict:dict[@"sendingUser"]];
    }
    return self;
}

- (void) parseUserInfoFOrDict:(NSDictionary *)userDict {
    
    self.userInfo = [[MyConnection alloc] initWithDictionary:userDict];

}
@end
