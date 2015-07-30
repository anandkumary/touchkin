//
//  MapViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/26/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setCenterCoordinate:self.location animated:YES];

    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = self.location;
    //If you want to clear other pins/annotations this is how to do it
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    //Drop pin on map
    [self.mapView addAnnotation:point];
    
    [self.view bringSubviewToFront:self.backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
