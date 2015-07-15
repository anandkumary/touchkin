//
//  TKRootViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKRootViewController.h"
#import "TKIntroVC.h"

static NSString * const KINTROSCREEN = @"TKIntroVC";

@interface TKRootViewController ()

@end

@implementation TKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];

    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        TKIntroVC *introVC = [self.storyboard instantiateViewControllerWithIdentifier:KINTROSCREEN];
        
         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVC];
        
        [navController setNavigationBarHidden:YES];
        
        [self presentViewController:navController animated:NO completion:nil];
    });
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
