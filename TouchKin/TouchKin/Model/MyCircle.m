//
//  MyCircle.m
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MyCircle.h"
#import "MyConnection.h"

@interface MyCircle()

@end

@implementation MyCircle

- (instancetype)initWithArray:(NSArray *)connectionList
{
    self = [super init];
    if (self) {
        [self parseConnection:connectionList];
    }
    return self;
}

-(void)parseConnection:(NSArray *)connection {
    
    for (NSDictionary * dict in connection) {
        if(!self.myConnectionList){
            self.myConnectionList = [[NSMutableArray alloc] init];
        }
        
        MyConnection *connection = [[MyConnection alloc] initWithDictionary:dict];
        
        [self.myConnectionList addObject:connection];
    }
    
}

-(void)updateUserStatus:(NSDictionary *)userStat{
    
}

@end
