//
//  Notification.h
//  TouchKin
//
//  Created by Anand Kumar on 8/19/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, retain) NSString * notificationMessage;
@property (nonatomic, retain) NSDate * receivedDate;
@property (nonatomic, retain) NSNumber * isRead;


@end
