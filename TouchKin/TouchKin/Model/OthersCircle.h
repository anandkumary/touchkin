//
//  OthersCircle.h
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OthersCircle : NSObject

@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *lname;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) int yob;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *homeList;
@property (nonatomic, strong) NSMutableArray *connectionList;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
