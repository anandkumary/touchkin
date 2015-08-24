//
//  MyHome.h
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHomeLocation : NSObject

@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * updatedTime;
@property (nonatomic, copy) NSString * locationObjectId;

@end
