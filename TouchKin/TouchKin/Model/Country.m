//
//  Country.m
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "Country.h"

#define kCountriesFileName @"countries.json"

@interface Country(){
    
    NSArray *countriesList;

}

@end

@implementation Country

- (id)init {
    self = [super init];
    if (self) {
        [self parseJSON];
    }
    
    return self;
}

- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    countriesList = (NSArray *)parsedObject;
}

- (NSArray *)countries
{
    return countriesList;
}

@end
