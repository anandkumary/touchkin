//
//  TKMeViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMeViewController.h"
#import "TKPageController.h"

@interface TKMeViewController ()<UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation TKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"Me";
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    CGRect frame = self.containerView.frame;
    frame.origin.y = 0;
    
    self.pageController.view.frame = frame;
    
    TKPageController *initialViewController = [self viewControllerAtIndex:0];
    
    initialViewController.view.clipsToBounds = YES;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.containerView addSubview:self.pageController.view];
    [self.containerView setClipsToBounds:YES];
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    [self addMyCircleObserver];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addMyCircleObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCircle:) name:@"MyFamilyCircle" object:nil];
}

-(void)updateMyCircle:(NSNotification *)notify {
    
    [self reloadGroupData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TKPageController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TKPageController *)viewController index];
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (TKPageController *)viewControllerAtIndex:(NSUInteger)index {
    
    TKPageController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TKPageController"];
    childViewController.index = index;
    childViewController.boardType = index % 3;
    childViewController.view.clipsToBounds = YES;
    
    CGRect frame = childViewController.view.frame;
    frame.size.height = self.containerView.frame.size.height;
    childViewController.view.frame = frame;
    
    return childViewController;
    
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    // The number of items reflected in the page indicator.
//    
//    return 0;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    // The selected item reflected in the page indicator.
//    return 0;
//}

@end
