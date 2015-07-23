//
//  Country.h
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCountryName        @"name"
#define kCountryCallingCode @"dial_code"
#define kCountryCode        @"code"

@interface Country : NSObject

- (NSArray *)countries;

@end
