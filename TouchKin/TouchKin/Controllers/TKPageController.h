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
#import "TKDashboardView.h"
#import <MapKit/MapKit.h>

@interface TKPageController : UIViewController

@property (assign, nonatomic) NSInteger index;

@property (nonatomic, strong) MyCircle *circle;

@property (nonatomic, strong) OthersCircle *others;

@property (assign, nonatomic) DashboardType boardType;

@property (weak, nonatomic) IBOutlet TKDashboardView *dashboardView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
