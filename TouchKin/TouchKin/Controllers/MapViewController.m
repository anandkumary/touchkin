//
//  MapViewController.m
//  TouchKin
//
//  Created by Anand kumar on 7/26/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "MapViewController.h"
#import "AnnotationView.h"
#import "MyHomeLocation.h"
#import "MapPopViewController.h"
#import "WYPopoverController.h"

#define METERS_PER_MILE 1609.344


@interface MapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) WYPopoverController *popover;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setCenterCoordinate:self.location animated:YES];
    
    [self.mapView setDelegate:self];

    
   // MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[_mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
    
    
    /*  MAKE THIS UNCOMMIT
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = self.location;
    //If you want to clear other pins/annotations this is how to do it
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    //Drop pin on map
    [self.mapView addAnnotation:point];
     
     */
    
    [self.view bringSubviewToFront:self.backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setAnnotationList:(NSArray *)annotationList {
    
    BOOL isSet = NO;
    
    for (MyHomeLocation *location  in annotationList) {
        
        CLLocation *actualLocation = [[CLLocation alloc] initWithLatitude:location.longitude.doubleValue longitude:location.latitude.doubleValue];
        
        if(isSet){
            isSet = YES;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(actualLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            
            [_mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
        }
        
       
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = actualLocation.coordinate;
        point.title = @"Where am I?";
        point.subtitle = @"I'm here!!!";
        
        [self.mapView addAnnotation:point];
    }
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    AnnotationView *annotationView = (AnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.backgroundColor = [UIColor clearColor];

    CGRect frame = annotationView.frame;
    frame.size = CGSizeMake(50, 50);
    annotationView.frame = frame;
    
    UIImage *img = [UIImage imageNamed:@"defaultPin.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.center = annotationView.center;
    [annotationView addSubview:imageView];
    
    annotationView.annotation = annotation;
    
    
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
//    [rightButton setBackgroundColor:[UIColor redColor]];
//    
//    annotationView.rightCalloutAccessoryView = rightButton;
    annotationView.canShowCallout = YES;
    annotationView.draggable = NO;
    
    
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    if([view isKindOfClass:AnnotationView.class]) {
        
        // Start up our view controller from a Storyboard
        UIViewController* controller = (UIViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MapPopViewController"];
        
        // Adjust this property to change the size of the popover + content
        controller.preferredContentSize = CGSizeMake(150, 80);
        
        if(!self.popover) {
            self.popover = [[WYPopoverController alloc] initWithContentViewController:controller];
            
            // Using WYPopoverController's iOS 6 theme
            self.popover.theme = [WYPopoverTheme themeForIOS6];
        }
        
        //POP POP
        [self.popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionDown animated:TRUE  options:WYPopoverAnimationOptionFadeWithScale];
    }
    
}



- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
   // [mapView removeAnnotation:view.annotation];
    //    if([view.annotation isKindOfClass:[CalloutAnnotation class]]) {
    //
    //    }
}


@end
