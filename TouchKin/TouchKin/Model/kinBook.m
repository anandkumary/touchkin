//
//  kinBook.m
//  TouchKin
//
//  Created by Anand kumar on 8/4/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "kinBook.h"

static NSString * const KINBOOK_BASEURL  = @"baseURL";
static NSString * const KINBOOK_DELETED  = @"deleted";
static NSString * const KINBOOK_EXTENSION  = @"extension";
static NSString * const KINBOOK_HDMEDIA     = @"hd_media";
static NSString * const KINBOOK_KINID       = @"id";
static NSString * const KINBOOK_IPHONEMEDIA = @"iphone";
static NSString * const KINBOOK_MESSAGE     = @"message";
static NSString * const KINBOOK_OWNER       = @"owner";
static NSString * const KINBOOK_SDMEDIA     = @"sd_media";
static NSString * const KINBOOK_THUMNAIL    = @"thumbnail";


@implementation kinBook

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.baseUrl        = dict[KINBOOK_BASEURL];
        self.isDeleted      = [dict[KINBOOK_DELETED] boolValue];
        self.extension      = dict[KINBOOK_EXTENSION];
        self.hdMedia        = dict[KINBOOK_HDMEDIA];
        self.kinId          = dict[KINBOOK_KINID];
        self.iPhoneMedia    = dict[KINBOOK_IPHONEMEDIA];
        self.message        = ([dict[KINBOOK_MESSAGE] isEqual:[NSNull class]]) ? @"" : dict[KINBOOK_MESSAGE] ;
        self.connection    = [[MyConnection alloc] initWithDictionary:dict[KINBOOK_OWNER]];
        self.sdMedia        = dict[KINBOOK_SDMEDIA];
        self.thumbnail      = dict[KINBOOK_THUMNAIL];
        NSLog(@"%@",self.thumbnail);
    }
    return self;
}
@end
