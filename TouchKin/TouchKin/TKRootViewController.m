//
//  TKRootViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKRootViewController.h"
#import "TKIntroVC.h"
#import "TKDataEngine.h"
#import "PSLocationManager.h"
#import "MLNetworkModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

static NSString * const KINTROSCREEN = @"TKIntroVC";

@interface TKRootViewController ()<PSLocationManagerDelegate>
{
    BOOL isLoginShown;
}

@end

@implementation TKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0]
                                 };
   
   
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateSelected];
   
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    tabBarItem1.title = @"Me";
    tabBarItem2.title = @"Kinbook";
    tabBarItem3.title = @"Message";

    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"avatar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.image = [[UIImage imageNamed:@"avatar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ];
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"kinbook"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"kinbook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ];
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchOnApplicationLoad) name:@"ApplicationOnLoad" object:nil];
    
    //LoginSuccess
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUserProfile) name:@"LoginSuccess" object:nil];
    
    //MyFamilyCircle
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoader) name:@"MyFamilyCircle" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoader) name:@"MyFamilyCircleError" object:nil];
    
   
    //Network Updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kReachabilityChangedNotification" object:nil];

}

-(void) viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    NSString *mobile = [[TKDataEngine sharedManager] getPhoneNumber];
    NSDate *expDate = [NSDate dateWithTimeIntervalSince1970:(double)[[TKDataEngine sharedManager] getExpDate]];
    
    if( mobile.length == 0 || [expDate compare:[NSDate date]] == NSOrderedAscending){
        
        if(!isLoginShown){
            isLoginShown = YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self showLogin];
                
            });
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *mobile = [[TKDataEngine sharedManager] getPhoneNumber];
    
    if( mobile.length != 0) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) fetchOnApplicationLoad {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Loading..."];
    
    [self fetchUserProfile];
}

-(void)fetchUserProfile {
    
    
    [PSLocationManager sharedLocationManager].delegate = self;
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    
    [[TKDataEngine sharedManager] getMyFamilyInfo];
    [[TKDataEngine sharedManager] getNewConnectionRequest];
    [[TKDataEngine sharedManager] getuserInfo];
    
   // [self updateUserStatus];
    
}

- (void)reachabilityChanged:(NSNotification * )notification {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *session = [[TKDataEngine sharedManager] getSessionToken];
        
        if(session.length){
            [self updateUserStatus];
        }

    });
}

- (void) updateUserStatus {
    
    
    NSString *deviceToken = [[TKDataEngine sharedManager] getDeviceToken];
    NSString *phone  = [[TKDataEngine sharedManager] getPhoneNumber];
    NSString *deviceOS = @"ios";
    
    NSInteger batteryLevel = (NSInteger)([UIDevice currentDevice].batteryLevel * 100);
    if(batteryLevel == -1){
        batteryLevel = 100;
    }

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSDictionary *connectivitystatus = @{@"battery" : @(batteryLevel),@"wifi_strength":@((int)delegate.isConnectedToWifi),@"3g": @((int)delegate.isConnectedTo3G)};
    
    NSDictionary *dict = @{@"mobile": phone,@"mobile_os": deviceOS,@"mobile_device_id": deviceToken,@"type": @"connectivity",@"data":connectivitystatus};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] initWithNoToken:YES];
    
    [model postRequestPath:@"activity/add" withParameter:dict withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"res connectivity = %@",responseObject);
    
    }];
    
}

-(void)stopLoader {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

-(void) showLogin {
   
   TKIntroVC *introVC = [self.storyboard instantiateViewControllerWithIdentifier:KINTROSCREEN];
  
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVC];
  
   [navController setNavigationBarHidden:YES];
  
   [self presentViewController:navController animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    NSString *strengthText;
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        strengthText = NSLocalizedString(@"Weak", @"");
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        strengthText = NSLocalizedString(@"Strong", @"");
    } else {
        strengthText = NSLocalizedString(@"...", @"");
    }
        
    NSLog(@"strength = %@",strengthText);

}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    // self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
    
    
    NSLog(@"distance travelled lat-> %f log -> %f",locationManager.locationManager.location.coordinate.latitude,locationManager.locationManager.location.coordinate.longitude);
    
    if(locationManager.locationManager.location.coordinate.longitude != 0){
        
        double lat = locationManager.locationManager.location.coordinate.latitude;
        double log = locationManager.locationManager.location.coordinate.longitude;
        
        [self postCoordinateForLat:lat withLongitude:log];
        [locationManager stopLocationUpdates];
    }
    
    //  NSLog(@"distance = %@",locationManager);

}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    //  self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"meters", @"")];
    
    NSLog(@"distance travelled = %.2f  -> lat-> %f log -> %f",distance,locationManager.locationManager.location.coordinate.latitude,locationManager.locationManager.location.coordinate.longitude);
        
    [locationManager stopLocationUpdates];
    
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
    
}


-(void) postCoordinateForLat:(double)lat withLongitude:(double)log {
   
    TKDataEngine *engine = [TKDataEngine sharedManager];
    
    NSString *mobile = [engine getPhoneNumber];
    NSString *deviceID = [engine getDeviceToken];
    NSString *deviceOS = @"ios";
    
    NSDictionary *points = @{@"x":@(lat),@"y":@(log)};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:deviceOS forKey:@"mobile_os"];
    [params setObject:deviceID forKey:@"mobile_device_id"];
    [params setObject:points forKey:@"point"];
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    [model postPath:@"location/add" withParameter:params withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        
        NSLog(@"resssss= %@",responseObject);
        
    }];
    
}


@end
