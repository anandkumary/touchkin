//
//  MyConnection.m
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MyConnection.h"
#import "MyHomeLocation.h"

@implementation MyConnection

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
       
        self.userId = dict[@"id"];
        
        if(dict[@"first_name"]){
            self.fname  = ([dict[@"first_name"]isKindOfClass:[NSNull class]]) ? @"" :  dict[@"first_name"];
        }
        
        if(dict[@"last_name"]){
            self.lname  = ([dict[@"last_name"]isKindOfClass:[NSNull class]]) ? @"" :  dict[@"last_name"];
        }

        if(dict[@"email"]){
            self.email  = ([dict[@"email"]isKindOfClass:[NSNull class]]) ? @"" :  dict[@"email"];
        }

        self.gender = dict[@"gender"];
        self.mobile = dict[@"mobile"];
        
        if(dict[@"yob"]){
            self.yob  = ([dict[@"yob"]isKindOfClass:[NSNull class]]) ? 0 :  [dict[@"yob"] intValue];
        }

        
        if(dict[@"places"]){
            
            [self initializePlacefor:dict[@"places"]];
        }
        
    }
    return self;
}

-(void) initializePlacefor:(NSDictionary *)placeList {
    
    NSArray *keys = [placeList allKeys];
    
    for (NSString *key in keys) {
        
        NSDictionary *dict = placeList[key];
        
        if(!self.homeList){
            self.homeList = [[NSMutableArray alloc] init];
        }
        
        MyHomeLocation *location = [[MyHomeLocation alloc] init];
        location.longitude = dict[@"x"];
        location.latitude  = dict[@"y"] ;
    }
    
}

@end
