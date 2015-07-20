//
//  TKHomeBaseController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseController.h"
#import "TKHomeBaseNavigationView.h"
#import "TKBaseViewController.h"
#import "AppDelegate.h"

@interface TKHomeBaseController ()
@property (nonatomic,strong)  TKHomeBaseNavigationView *navView;
@end

@implementation TKHomeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initailizeNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initailizeNavigation {
    
    self.navView = [[[NSBundle mainBundle] loadNibNamed:@"TKHomeBaseNavigationView" owner:self options:nil] objectAtIndex:0];
    
    self.navView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70);
    [self.navView updateConstraints];
    [self.navView layoutIfNeeded];
    
    [self.view addSubview:self.navView];
    
    [self.navView.leftButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    [self.navView setTitle:navTitle];
}

-(void) setType:(NavigationType)type {
    _type = type;
    [self.navView setNavType:type];
}

-(void) menuButtonAction:(UIButton *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    TKBaseViewController *baseVC = (TKBaseViewController *) delegate.window.rootViewController;
    
    [baseVC openMenu];
}

@end
