//
//  MyCircle.h
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCircle : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *myConnectionList;

- (instancetype)initWithArray:(NSArray *)connectionList;

@end
