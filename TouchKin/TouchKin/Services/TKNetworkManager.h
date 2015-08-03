//
//  TKNetworkManager.h
//  TouchKin
//
//  Created by Anand kumar on 7/28/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLNetworkModel.h"
#import "TKDataEngine.h"

@interface TKNetworkManager : NSObject

+ (void) uploadImage:(NSDictionary *)fileData;

+ (void) uploadVideoFor:(NSURL *)videoUrl withUserID:(NSString *)userList;

+ (void) sendRequestForUser:(NSString *)userName withMobileNumber:(NSString *)mobile;

@end
