//
//  TKDataManager.h
//  TouchKin
//
//  Created by Anand Kumar on 8/19/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Notification.h"

typedef void (^YLBlock)(BOOL success, id responseObject);


@interface TKDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundMasterContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *createWriteContext;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (TKDataManager *) sharedInstance;

- (void) saveAllWithContext:(NSManagedObjectContext *)writeContext withCallback:(YLBlock)callback;

-(void) saveNotificationForDict:(NSDictionary *)dict withBlock:(YLBlock)block;
- (NSInteger ) getNotificationCount;
-(NSArray *) getAllNotification;
@end
