//
//  TKPageController.h
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "MyCircle.h"
#import "OthersCircle.h"
#import "MyConnection.h"
#import "TKDashboardView.h"
#import "TKKnob.h"
#import "TKGradientCircularView.h"
#import "TKSplitView.h"
#import <MapKit/MapKit.h>

@interface TKPageController : UIViewController<UIPageViewControllerDelegate>

@property (assign, nonatomic) NSInteger index;

@property (nonatomic, strong) MyCircle *circle;

@property (nonatomic, strong) OthersCircle *others;

@property (nonatomic, strong) MyConnection *connection;

@property (assign, nonatomic) DashboardType boardType;

@property (weak, nonatomic) IBOutlet TKDashboardView *dashboardView;
@property (weak, nonatomic) IBOutlet TKSplitView *gradientCircle;
@property (weak, nonatomic) IBOutlet TKKnob *splitView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void) setConnection:(MyConnection *)connection withUserStatus:(NSDictionary *)status;
-(void) updateMyConnectionData;

@end
