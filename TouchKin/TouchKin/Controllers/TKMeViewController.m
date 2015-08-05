//
//  TKMeViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMeViewController.h"
#import "TKPageController.h"
#import "TKDataEngine.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MLNetworkModel.h"
#import "TKCameraVC.h"
#import "TKAlertView.h"

@interface TKMeViewController ()<UIPageViewControllerDataSource,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) NSMutableArray *familyList;

@property (nonatomic, assign) NSInteger selctedIndex;

@property (nonatomic, assign) BOOL isSelectedUserPending;

@property (nonatomic, strong) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendTouchBtn;

@end

@implementation TKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"Me";
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    CGRect frame = self.containerView.frame;
    frame.origin.y = 0;
    
    self.pageController.view.frame = frame;
    
    [self.containerView addSubview:self.pageController.view];
    [self.containerView setClipsToBounds:YES];
    
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    
    [self addMyCircleObserver];
    
    [self addtapGestureForMap];
    
    // [self setDelegate:self];
    
    [self.callBtn addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isSelectedUserPending = NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addtapGestureForMap {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tgr];
}

-(void) addMyCircleObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCircle:) name:@"MyFamilyCircle" object:nil];
}

-(void)updateMyCircle:(NSNotification *)notify {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.familyList = [[TKDataEngine sharedManager] familyList];
        
        self.selctedIndex = 0;
        
        self.navTitle = @"My Family";
        
        MyCircle *circle = [self.familyList objectAtIndex:0];
        
        [self getActivityForId:circle.userId];
        
        [[TKDataEngine sharedManager] setCurrentUserId:circle.userId];
        
        [self addDefaultpages];
        
        [self reloadGroupData];
    });
}

-(void) addDefaultpages {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TKPageController *initialViewController = [self viewControllerAtIndex:0];
        
        initialViewController.view.clipsToBounds = YES;
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    });
    
   
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
    
    if (index == 3 || self.selctedIndex == 0 || self.isSelectedUserPending) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (TKPageController *)viewControllerAtIndex:(NSUInteger)index {
    
    TKPageController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TKPageController"];
    childViewController.index = index;
    childViewController.boardType = index % 3;
    
    if(childViewController.boardType == DASHBOARDMAPTYPE){
        childViewController.mapView = self.mapView;
    }
    childViewController.view.clipsToBounds = YES;
    
    MyCircle *circle = [self.familyList objectAtIndex:self.selctedIndex];
    if(![circle isKindOfClass:[MyCircle class]]){
        
        childViewController.others = (OthersCircle *)circle;
        self.isSelectedUserPending = childViewController.others.isPending;
    }
    else {
        childViewController.circle = circle;
    }
    
    CGRect frame = childViewController.view.frame;
    frame.size.height = self.containerView.frame.size.height;
    childViewController.view.frame = frame;
    
    return childViewController;
    
}


-(void) didSelectHeaderTitleAtIndex:(NSInteger)index withUserId:(NSString *)userId {
    
    self.selctedIndex = index;
    
    [[TKDataEngine sharedManager] setCurrentUserId:userId];
    
    self.pageController.dataSource = nil;
    self.pageController.dataSource = self;
    
    [self addDefaultpages];
    
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void) handleGesture:(UIGestureRecognizer *)gesture {
   
    MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    mvc.location = self.mapView.region.center;
    
    [self presentViewController:mvc animated:YES completion:nil];
}

#pragma mark - Get Activity

-(void) getActivityForId:(NSString *)userId {
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model getRequestPath:[NSString stringWithFormat:@"activity/current/%@",userId] withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"res =%@",responseObject);
    }];
}

-(void) callButtonAction:(id)sender {
    [TKAlertView showAlertWithText:@"Alert view shown" forView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TKAlertView hideAlertForView:self.view];
    });

}
- (IBAction)sendTouchBtnAction:(id)sender {
    [self openImagePicker];

}

-(void) openImagePicker {
    
    TKCameraVC *cam = [self.storyboard instantiateViewControllerWithIdentifier:@"TKCameraVC"];
    
    [self presentViewController:cam animated:YES completion:nil];
}

@end
