//
//  AppDelegate.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "AppDelegate.h"
#import "TKDataEngine.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface AppDelegate ()
@property(nonatomic, assign) NetworkStatus internetStatus;

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    
    [myDevice setBatteryMonitoringEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    Reachability * hostReach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    [hostReach startNotifier];

    self.internetStatus = [hostReach currentReachabilityStatus];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    [self updateCarrierInfo];
    
    [self setUpTokenRegistration:application];
    
    return YES;
}

-(void) setUpTokenRegistration:(UIApplication *)application {
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if ([reachability currentReachabilityStatus] == ReachableViaWWAN)
        {
        self.isConnectedTo3G = YES;
        }
    
    if ([reachability currentReachabilityStatus] == ReachableViaWiFi)
        {
        self.isConnectedToWifi = YES;
        }
}


-(void)reachabilityChanged: (NSNotification *)note
{
    Reachability *curReach = [note object];
    self.internetStatus = [curReach currentReachabilityStatus];
    
    if(self.internetStatus == NotReachable){
        
        self.isConnectedTo3G = NO;
        self.isConnectedToWifi = NO;
    }
    
    [self updateInterfaceWithReachability:curReach];

}

-(BOOL) isNetWorkConnected {
    
    return (self.internetStatus != NotReachable) ? YES : NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)updateCarrierInfo {
    
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    
    CTCarrier *carrier = telephonyInfo.subscriberCellularProvider;
    
    NSLog(@"country code is: %@ -> %@", carrier.isoCountryCode,carrier.mobileNetworkCode);
    
//    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
//    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    // NSArray *cty = [NSLocale ISOCountryCodes];
    
    //  NSLog(@"country code is: %@ -> %@", countryCode, cty);


    
    NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
    [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note)
    {
    NSLog(@"New Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
    }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{    
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"%@",token);
    
    [[TKDataEngine sharedManager] setToken:token];
    // [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}

@end
