//
//  TKDashboardView.h
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Define.h"

@interface TKDashboardView : UIView

@property (nonatomic, assign) DashboardType type;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, copy) NSString * lat;
@property (nonatomic, copy) NSString * log;

-(void) updateLocation;

@end
