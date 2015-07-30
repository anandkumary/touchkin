//
//  OthersCircle.m
//  TouchKin
//
//  Created by Anand kumar on 7/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "OthersCircle.h"
#import "MyHomeLocation.h"
#import "MLNetworkModel.h"
#import "MyConnection.h"

@implementation OthersCircle

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
        self.yob   = [dict[@"yob"] intValue];
        
        if(dict[@"places"]){
            
            [self initializePlacefor:dict[@"places"]];
        }
        
        [self getOtherFamilyInfo];
        
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
        
        [self.homeList addObject:location];
    }
    
}

-(void) getOtherFamilyInfo {
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    [model getRequestPath:[NSString stringWithFormat:@"user/family/%@",self.userId] withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        NSDictionary *dict =  responseObject;
        
        [self parseCareGiverFor:dict[@"care_givers"]];
    }];
}


-(void) parseCareGiverFor:(NSArray *)careGiverList {
    
    
    for (NSDictionary * dict in careGiverList) {
        if(!self.connectionList){
            self.connectionList = [[NSMutableArray alloc] init];
        }
        
        MyConnection *connection = [[MyConnection alloc] initWithDictionary:dict];
        
        [self.connectionList addObject:connection];
    }
    
}

@end
