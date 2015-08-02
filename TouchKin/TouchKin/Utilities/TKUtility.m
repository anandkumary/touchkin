//
//  TKUtility.m
//  TouchKin
//
//  Created by Anand kumar on 8/2/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKUtility.h"

@implementation TKUtility

+ (NSInteger) getCurrentYear {
    
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    
    return year;
}
@end
