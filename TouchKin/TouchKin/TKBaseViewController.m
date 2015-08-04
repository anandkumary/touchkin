//
//  TKBaseViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/16/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKBaseViewController.h"
#import "TKRootViewController.h"
#import "TKSideMenuView.h"
#import "TKMyFamilyVC.h"
#import "UIImageView+WebCache.h"
#import "TKDataEngine.h"
#import "TKProfileVC.h"
#import "TKMessagePreviewVC.h"

@interface TKBaseViewController ()<SideMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet TKSideMenuView *sideMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSideConstraint;

@property (nonatomic, strong) TKRootViewController *rootVC;

@end

@implementation TKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootVC = (TKRootViewController *)self.childViewControllers.lastObject;
    
    self.sideMenu.delegate = self;
    
    self.sideMenu.avatar.layer.cornerRadius = self.sideMenu.avatar.frame.size.width/2;
    
    self.sideMenu.avatar.clipsToBounds = YES;
    
    self.leftSideConstraint.constant = -self.sideMenu.frame.size.width;
    
    [self.sideMenu updateConstraintsIfNeeded];
    [self.sideMenu layoutIfNeeded];
    
    [self.view layoutIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [tap setNumberOfTapsRequired:1];
    [self.sideMenu.avatar addGestureRecognizer:tap];
    
    
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

-(void)openMenu {
    
    self.leftSideConstraint.constant = 0;
    [self.sideMenu updateConstraintsIfNeeded];
    self.sideMenu.bgImage.backgroundColor = [UIColor clearColor];
    
    [self updateUserProfilePic];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    self.sideMenu.bgImage.backgroundColor = [UIColor colorWithRed:(171.0/255.0) green:(171.0/255.0) blue:(171.0/255.0) alpha:0.5];
    }];

}

-(void) updateUserProfilePic {
    
    NSString *userID = [[TKDataEngine sharedManager] getUserId];
    
    if(userID){
       
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",[[TKDataEngine sharedManager] getUserId]]];
        
        // self.sideMenu.userName =
        
        [self.sideMenu.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            self.sideMenu.avatar.image = image;
        }];
    }
    
}

-(void)closeMenu {
   
     self.leftSideConstraint.constant = -self.sideMenu.frame.size.width;
    [self.sideMenu updateConstraintsIfNeeded];
    self.sideMenu.bgImage.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.5 animations:^{
                
        [self.view layoutIfNeeded];
    }];
}

-(void)sideMenu:(TKSideMenuView *)menu didSlecetAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:{
            if(![self.childViewControllers containsObject:self.rootVC]){
                
                [self removeAllViewController];
               
                [self addChildViewController:self.rootVC];
                [self.containerView addSubview:self.rootVC.view];
                [self.rootVC didMoveToParentViewController:self];
            }
            
            break;
    }
        case 1:{
            
            if(![self.childViewControllers.lastObject isKindOfClass:[TKMyFamilyVC class]]) {
                [self removeAllViewController];
                
                TKMyFamilyVC *familyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKMyFamilyVC"];
                
                [self addChildViewController:familyVC];
                [self.containerView addSubview:familyVC.view];
                [familyVC didMoveToParentViewController:self];

                
            }
            break;
        }
            
        case 2: {
            
            if(![self.childViewControllers.lastObject isKindOfClass:[TKProfileVC class]]) {
                [self removeAllViewController];
                
                TKProfileVC *profilevc = [self.storyboard instantiateViewControllerWithIdentifier:@"TKProfileVC"];
                
                [self addChildViewController:profilevc];
                [self.containerView addSubview:profilevc.view];
                [profilevc didMoveToParentViewController:self];
                
                
            }
            
            break;
        }
            
        case 3: {
            
            if(![self.childViewControllers.lastObject isKindOfClass:[TKMessagePreviewVC class]]) {
                [self removeAllViewController];
                
                TKMessagePreviewVC *profilevc = [self.storyboard instantiateViewControllerWithIdentifier:@"TKMessagePreviewVC"];
                
                [self addChildViewController:profilevc];
                [self.containerView addSubview:profilevc.view];
                [profilevc didMoveToParentViewController:self];
                
                
            }

            
            break;
        }
    
        default:
            break;
    }
    
    [self closeMenu];
}

-(void)removeAllViewController {
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}
- (void)avatarTap:(id)sender {
    
    if(![self.childViewControllers.lastObject isKindOfClass:[TKProfileVC class]]) {
        [self removeAllViewController];
        
        TKProfileVC *profilevc = [self.storyboard instantiateViewControllerWithIdentifier:@"TKProfileVC"];
        
        [self addChildViewController:profilevc];
        [self.containerView addSubview:profilevc.view];
        [profilevc didMoveToParentViewController:self];
        
    }
    
    [self closeMenu];

}
@end
