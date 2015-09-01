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
#import "UILabel+Attribute.h"
#import "TKNotificationViewController.h"

#import <AudioToolbox/AudioServices.h>

@interface TKMeViewController ()<UIPageViewControllerDataSource,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) NSMutableArray *familyList;

@property (nonatomic, assign) NSInteger selctedIndex;
@property (nonatomic, assign) NSInteger childIndex;
@property (nonatomic,assign) NSInteger pageCount;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;

@property (nonatomic, assign) BOOL isSelectedUserPending;

@property (nonatomic, strong) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendTouchBtn;

@end

@implementation TKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"My Family";
    
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
    self.pageIndicator.hidden = YES;
    
    [self.callBtn addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.isSelectedUserPending = NO;
    
    [self addRightSideImage:nil forTarget:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) navRightBarAction:(UIButton *)sender {
    TKNotificationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TKNotificationViewController"];
    
    [self presentViewController:ctr animated:YES completion:nil];
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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyCircleError:) name:@"MyFamilyCircleError" object:nil];
}

-(void)updateMyCircleError:(NSNotification *)notify{
    
}

-(void)updateMyCircle:(NSNotification *)notify {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.familyList = [[TKDataEngine sharedManager] familyList];
        
        self.selctedIndex = 0;
        
        self.pageIndicator.currentPage = 0;
        
        self.navTitle = @"My Family";
        
        MyCircle *circle = [self.familyList objectAtIndex:0];
        
        if([circle isKindOfClass:[MyCircle class]]){
            
            [self getActivityForId:circle.userId forObject:circle];
            
        }
        
        [[TKDataEngine sharedManager] setCurrentUserId:circle.userId];

        [self addDefaultpages];
        
        [self reloadGroupData];
       
    });
}

-(void) addDefaultpages {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.pageIndicator.currentPage = 0;
        self.pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageController.dataSource = self;
        
    TKPageController *initialViewController = [self viewControllerAtIndex:0];
        
       // initialViewController.view.clipsToBounds = YES;

        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        self.pageController.view.frame = CGRectMake(0 ,0, self.containerView.frame.size.width, self.containerView.frame.size.height-25);
        
        [self addChildViewController:_pageController];
        [self.containerView addSubview:_pageController.view];
        [self.pageController didMoveToParentViewController:self];

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
        //Page 0
        self.pageIndicator.currentPage = 0;
        return nil;
    }
    else {
        self.pageIndicator.currentPage = self.pageIndicator.currentPage - 1;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
        
    NSUInteger index = [(TKPageController *)viewController index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.pageIndicator.currentPage = index;

    });
    

    index++;
    
    if(self.selctedIndex == 0){
        MyCircle *circle = [self.familyList objectAtIndex:self.selctedIndex];
        

        if(index == circle.myConnectionList.count){
            return nil;
        }
        
        return [self viewControllerAtIndex:index];

    }
        
    if (index == 3 || self.selctedIndex == 0 || self.isSelectedUserPending) {
        return nil;
    }
//    else {
//        TKPageController *cnt =  (TKPageController *)viewController;
//        [cnt.splitView addKnobAnimtation];
//    }
    
    return [self viewControllerAtIndex:index];
    
}

- (TKPageController *)viewControllerAtIndex:(NSUInteger)index {
    
    TKPageController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TKPageController"];
    childViewController.index = index;
    
    self.childIndex = index;
    
    if(self.selctedIndex != 0){
        childViewController.boardType = index % 3;
    }
    
    if(childViewController.boardType == DASHBOARDMAPTYPE){
        childViewController.mapView = self.mapView;
    }
    childViewController.view.clipsToBounds = YES;
    
    MyCircle *circle = [self.familyList objectAtIndex:self.selctedIndex];
    if(![circle isKindOfClass:[MyCircle class]]){
        
        childViewController.others = (OthersCircle *)circle;
        self.isSelectedUserPending = childViewController.others.isPending;
        
        self.pageIndicator.numberOfPages = (self.isSelectedUserPending) ? 1 : 3;
        self.pageCount = (self.isSelectedUserPending) ? 1 : 3;
    }
    else {
        self.pageCount = circle.myConnectionList.count;
        if(circle.myConnectionList.count){
             [childViewController setConnection:[circle.myConnectionList objectAtIndex:index] withUserStatus:circle.userStatus];
            
        }
        else {
            //ADD Care Givers
        }
        
    }
    
//    CGRect frame = childViewController.view.frame;
//    frame.size.height = self.containerView.frame.size.height - 50;
//    childViewController.view.frame = frame;
//    
    return childViewController;
    
}


-(void) didSelectHeaderTitleAtIndex:(NSInteger)index withUserId:(NSString *)userId {
    
    self.pageIndicator.hidden = (index == 0) ? YES : YES;

    self.selctedIndex = index;
    
    [[TKDataEngine sharedManager] setCurrentUserId:userId];
   
    [self.pageController.view removeFromSuperview];
    self.pageController.dataSource = nil;
    self.pageController.dataSource = self;
    [self addDefaultpages];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    
    return self.pageCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void) handleGesture:(UIGestureRecognizer *)gesture {
    
  //  NSLog(@"selected = %d",     self.selctedIndex );
    
    OthersCircle *circle = [self.familyList objectAtIndex:self.selctedIndex];
   
    MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
   // mvc.location = self.mapView.region.center;
    
    [self presentViewController:mvc animated:YES completion:^{
        mvc.annotationList = circle.homeList;

    }];
    
}

#pragma mark - Get Activity

-(void) getActivityForId:(NSString *)userId forObject:(MyCircle *)circle {
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model getRequestPath:[NSString stringWithFormat:@"activity/current/%@",userId] withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        if(responseObject[@"last_touch"]){
            
            UserLastUpdate *lastUpdated = [[UserLastUpdate alloc] initWithDict:responseObject[@"last_touch"]];
             circle.lastTouch = lastUpdated;
        }
       
        
        circle.userStatus = responseObject[@"current_month_activity"];
    }];
}

-(void) callButtonAction:(id)sender {
    
    TKPageController *pageContr = self.pageController.viewControllers[0];

    NSString *mobile = @"";
    if(self.selctedIndex == 0){
        MyConnection *connect = pageContr.connection;
        mobile = connect.mobile;
    }
    else {
        OthersCircle *others = pageContr.others;
        mobile = others.mobile;
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //telprompt alert user to call
        NSString *phoneNumber = [@"tel://" stringByAppendingString:mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    });

    
//    [TKAlertView showAlertWithText:@"Alert view shown" forView:self.view];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [TKAlertView hideAlertForView:self.view];
//    });

}
- (IBAction)sendTouchBtnAction:(UIButton *)sender {
    
    if(!sender.selected){
        
        sender.selected = YES;
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        MLNetworkModel *model = [[MLNetworkModel alloc] init];
        
        TKPageController *pageContr = self.pageController.viewControllers[0];
        
        [pageContr.topLabel setText:@"Sending a touch..."];
        [pageContr.bottomLabel setText:@"Share a moment with video?"];
        
        NSString *mobile = @"";
        if(self.selctedIndex == 0){
            MyConnection *connect = pageContr.connection;
            mobile = connect.userId;
        }
        else {
            OthersCircle *others = pageContr.others;
            mobile = others.userId;
            
            if (pageContr.index != 0) {
                [self.pageIndicator setCurrentPage:0];
                TKPageController *initialViewController = [self viewControllerAtIndex:0];
                initialViewController.view.clipsToBounds = YES;
                [initialViewController.topLabel setText:@"Sending a touch..."];
                [initialViewController.bottomLabel setText:@"Share a moment with video?"];
                
                NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
                [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            sender.selected = NO;
            [sender setTitle:@"Send a Touch" forState:UIControlStateNormal];
            NSDictionary *dict = @{@"receivingUserId" : mobile};
            
            [model postRequestPath:@"touch/add" withParameter:dict
                       withHandler:^(id responseObject, NSError *error) {
                       }];
            [self.pageController.view removeFromSuperview];
            [self addDefaultpages];
            
        });
        
        [sender setTitle:@"Add a Video" forState:UIControlStateNormal];
        
    }
    else {
        
        [sender setTitle:@"Send a Touch" forState:UIControlStateNormal];
        
        [self openImagePicker];
        
    }
    
}

-(void) openImagePicker {
    
    TKCameraVC *cam = [self.storyboard instantiateViewControllerWithIdentifier:@"TKCameraVC"];
    
    [self presentViewController:cam animated:YES completion:nil];
}

@end
