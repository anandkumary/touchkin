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
#import "TKDataEngine.h"

@interface TKHomeBaseController ()<TKHomeBaseNavigationViewDelegate>
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
    
    self.navView.delegate = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) setDelegate:(id)object {
    
    self.navView.delegate = object;
}

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

-(void) addLeftSideImage:(UIImage *)image forTarget:(id)target {
   
    [self.navView.leftButton setImage:image forState:UIControlStateNormal];
    
    [self.navView.leftButton addTarget:target action:@selector(navleftBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) addRightSideImage:(UIImage *)image forTarget:(id)target {
    
    [self.navView.rightButton setImage:image forState:UIControlStateNormal];
    
    [self.navView.rightButton addTarget:target action:@selector(navRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) addLeftSideTitle:(NSString *)title forTarget:(id)target {
    
    [self.navView.leftButton setTitle:title forState:UIControlStateNormal];
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    
    [self.navView.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.navView.leftButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    [self.navView.leftButton removeTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navView.leftButton addTarget:target action:@selector(navleftBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) addRightSideTitle:(NSString *)title forTarget:(id)target {
    
    [self.navView.rightButton setTitle:title forState:UIControlStateNormal];
    
    [self.navView.rightButton setImage:nil forState:UIControlStateNormal];
    
    [self.navView.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.navView.rightButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    [self.navView.rightButton addTarget:target action:@selector(navRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) reloadGroupData {
    
    self.navView.groupList = [[TKDataEngine sharedManager] familyList];
}
@end
