//
//  TKDashboardView.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKDashboardView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#define METERS_PER_MILE 1609.344


@interface TKDashboardView() <MKMapViewDelegate>

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *batteryImage;
@property (nonatomic, strong) UILabel *batteryLbl;

@property (nonatomic, strong) UIImageView *cellularImage;
@property (nonatomic, strong) UIImageView *wifiImage;
@end

@implementation TKDashboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}

-(void) setType:(DashboardType)type {
    _type = type;
    
    switch (type) {
        case DASHBOARDIMAGETYPE:{
            
            [self createAvatar];
            
            self.avatar.image = [UIImage imageNamed:@"add_avatar"];
            
            break;
        }
        case DASHBOARDMAPTYPE:{
            
            [self createMapView];

            break;
        }
        case DASHBOARDCELLULARTYPE: {
            [self createAvatar];
            
            self.avatar.image = [UIImage imageNamed:@"cellular"];
            
            [self createBatteryImage];
            
            int batterrLevel = (int)([UIDevice currentDevice].batteryLevel * 100);
            if(batterrLevel == -1){
                batterrLevel = 100;
            }
            
            int batteryIconNumber = (batterrLevel/20);
            
            self.batteryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"battery%d",batteryIconNumber]];
            
            self.batteryLbl.text = [NSString stringWithFormat:@"%d%%",batterrLevel];
            
            [self createCellularNetwork];
            
            break;
        }
            
        default:
            break;
    }
}

-(void) setMapView:(MKMapView *)mapView {
    _mapView = mapView;
}

-(void) createMapView {
    
    self.mapView.frame  = self.bounds;
    self.mapView.delegate = self;
    
    self.mapView.layer.cornerRadius = self.mapView.frame.size.width/2;
    
    self.mapView.userTrackingMode=YES;

    
    if(![self.subviews containsObject:self.mapView]){
        [self addSubview:self.mapView];
    }
    
}

-(void) updateLocation {
    
    if(self.lat.length) {
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = self.log.doubleValue;
        zoomLocation.longitude = self.lat.doubleValue;
        
        [self.mapView setCenterCoordinate:zoomLocation animated:YES];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        
        // 3
        [_mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        // Set your annotation to point at your coordinate
        point.coordinate = zoomLocation;
        //If you want to clear other pins/annotations this is how to do it
        for (id annotation in self.mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
        //Drop pin on map
        [self.mapView addAnnotation:point];
        
    }

}

-(void) createAvatar {
   
    if(!self.avatar){
        self.avatar = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.avatar];
        
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
        
        self.avatar.clipsToBounds = YES;
    }
}

-(void) createBatteryImage {
    
    if(!self.batteryImage){
        self.batteryImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 15, self.frame.size.height - 40, 30, 22)];
        
        [self addSubview:self.batteryImage];
        
        [self.batteryImage setImage:[UIImage imageNamed:@"battery0"]];
        
        self.batteryLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 20)];
        self.batteryLbl.font = [UIFont systemFontOfSize:12];
        self.batteryLbl.textAlignment = NSTextAlignmentCenter;
        self.batteryLbl.textColor = [UIColor whiteColor];
        
        [self addSubview:self.batteryLbl];
    }
    
}

-(void) setBatteryLevel:(NSInteger)batteryLevel {
    _batteryLevel = batteryLevel;
    
    int batterrLevel = (int)batteryLevel;
    
    if(batterrLevel == -1){
        batterrLevel = 100;
    }
    
    int batteryIconNumber = (batterrLevel/20);
    
    self.batteryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"battery%d",batteryIconNumber]];
    
    self.batteryLbl.text = [NSString stringWithFormat:@"%d%%",batterrLevel];
    
    [self updateNetworkReachibilty];

    
}

-(void) createCellularNetwork {
    
    if(!self.cellularImage){
       
        self.cellularImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/4 - 15, self.frame.size.height/4 , 30, 25)];
        self.cellularImage.image = [UIImage imageNamed:@"Network0"];
        
        [self addSubview:self.cellularImage];
        
        self.wifiImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height/4 , 30, 25)];
        
        self.wifiImage.image = [UIImage imageNamed:@"wifi0"];
        
        [self addSubview:self.wifiImage];
        
        [self updateNetworkReachibilty];
    }
}


-(void) updateNetworkReachibilty {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        //AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        self.wifiImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"wifi%d",((self.wifilevel > 0) ? 1 : 0)]];
        
        self.cellularImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Network%d",((self.g3Level > 0) ? 1 : 0)]];
    });
    
}

-(void) setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    
    if(DASHBOARDIMAGETYPE == self.type) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        __weak typeof(UIImageView *) weakSelf = self.avatar;
        
        [self.avatar sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = image;
            });

        }];
        
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

@end
