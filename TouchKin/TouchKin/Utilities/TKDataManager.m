//
//  TKDataManager.m
//  TouchKin
//
//  Created by Anand Kumar on 8/19/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKDataManager.h"

@interface TKDataManager ()

@property (nonatomic, strong,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation TKDataManager

@synthesize backgroundMasterContext = _backgroundMasterContext;
@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (TKDataManager *) sharedInstance
{
    static id sharedDataManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[[self class] alloc] init];
        [sharedDataManager initDataManager];
    });
    return sharedDataManager;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)initDataManager
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
}

-(NSManagedObjectContext*) backgroundMasterContext
{
    if(!_backgroundMasterContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if(coordinator) {
            _backgroundMasterContext =  [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_backgroundMasterContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _backgroundMasterContext;
}

-(NSManagedObjectContext*) createWriteContext
{
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [newContext setParentContext:self.mainContext];
    return newContext;
}

-(NSManagedObjectContext*) mainContext
{
    if (!_mainContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_mainContext setParentContext:self.backgroundMasterContext];
        }
    }
    return _mainContext;
}

- (NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TouchKin" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TouchKin.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //        DLog(@"Unresolved error forcing creation of file %@, %@", error, [error userInfo]);
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TouchKin.sqlite"];
        error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        if(error) {
            //            DLog(@"Error removeAllCacheData %@ %@",error,[error userInfo]);
            abort();
        }
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            //            DLog(@"Error removeAllCacheData %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

#pragma mark - instance methods
- (void) saveAllWithContext:(NSManagedObjectContext *)writeContext withCallback:(YLBlock)callback{
    
    BOOL b = NO;
    NSError *error = nil;
    if([writeContext hasChanges]) {
        b=[writeContext save:&error];
        
        if(b) {
            NSManagedObjectContext *parentContext = [writeContext parentContext];
            if(parentContext) {
                [parentContext performBlock:^{
                    [self saveAllWithContext:parentContext withCallback:callback];
                }];
            } else {
                if(callback)
                    callback(YES,nil);
            }
        } else {
            if(callback)
                callback(NO,error);
        }
    }
    else {
        if(callback)
            callback(YES, nil);
    }
}

#pragma mark - File Manager
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSMutableArray *) generateSortDescriptorForList:(NSArray *)list {
    
    NSMutableArray *sortDescriptoreList = nil;
    for (NSString *keys in list) {
        
        if(!sortDescriptoreList){
            sortDescriptoreList = [[NSMutableArray alloc] init];
        }
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:keys ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [sortDescriptoreList addObject:sortDesc];
    }
    
    return sortDescriptoreList;
}

-(void) saveNotificationForDict:(NSDictionary *)dict withBlock:(YLBlock)block {
    
    NSManagedObjectContext *writeContext = [self createWriteContext];
    [writeContext performBlock:^{
        
            Notification *note = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:writeContext];
        
        note.userId = dict[@"id"];
        note.notificationMessage = dict[@"txt"];
        note.notificationType = dict[@"type"];
        note.receivedDate = [NSDate date];
        note.isRead = @(NO);
        
        [self saveAllWithContext:writeContext withCallback:^(BOOL success, id responseObject) {

            block(YES,nil);
        }];
    }];
}

- (NSInteger ) getNotificationCount {
    
    
    NSManagedObjectContext *context = [self mainContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isRead == %d)",NO];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger numberOfRecords = [context countForFetchRequest:fetchRequest error:&error];
    
    return numberOfRecords;
    
}

-(NSArray *) getAllNotification {
    
    NSManagedObjectContext *context = [self mainContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    return array;
    
}
@end
