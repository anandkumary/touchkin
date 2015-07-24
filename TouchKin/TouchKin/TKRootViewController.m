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

static NSString * const KINTROSCREEN = @"TKIntroVC";

@interface TKRootViewController () {
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
    tabBarItem1.image = [[UIImage imageNamed:@"avatar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"kinbook"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"kinbook"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];

    
    [[TKDataEngine sharedManager] getMyFamilyInfo];
    
}

-(void) viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    NSString *mobile = [[TKDataEngine sharedManager] getPhoneNumber];
    NSDate *expDate = [NSDate dateWithTimeIntervalSince1970:(double)[[TKDataEngine sharedManager] getExpDate]];
    
//    NSLog(@"exp =%@  ->  date = %@",expDate,[NSDate date]);
//    
//    if([expDate compare:[NSDate date]] == NSOrderedDescending){
//        NSLog(@"is Greater");
//    }
    
    if( mobile.length == 0 || [expDate compare:[NSDate date]] == NSOrderedAscending){
        
        if(!isLoginShown){
            isLoginShown = YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self showLogin];
                
            });
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
