//
//  MapViewController.h
//  TouchKin
//
//  Created by Anand kumar on 7/26/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (nonatomic, weak)IBOutlet  MKMapView *mapView;

@property (nonatomic, strong) NSArray *annotationList;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@end
