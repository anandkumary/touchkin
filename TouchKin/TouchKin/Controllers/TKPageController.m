//
//  TKPageController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKPageController.h"
#import "TKCircularView.h"
#import "UIColor+Navigation.h"
#import "UILabel+Attribute.h"
#import "MyHomeLocation.h"
#import "TKDataEngine.h"
#import "UserActivity.h"
#import <AudioToolbox/AudioServices.h>


@interface TKPageController ()


@property (weak, nonatomic) IBOutlet UIView *bgImage;
@property (weak, nonatomic) IBOutlet TKCircularView *circularView;
@property (weak, nonatomic) IBOutlet UILabel *bgLetterLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageViewConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelConstraint;

@end

@implementation TKPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgImage.layer.cornerRadius = self.bgImage.frame.size.width/2;
    
    self.dashboardView.layer.cornerRadius = self.dashboardView.frame.size.width/2;
    
    self.dashboardView.mapView = self.mapView;

    self.dashboardView.type = self.boardType;
    
    self.bgLetterLbl.layer.cornerRadius = self.bgLetterLbl.frame.size.width/2;
    self.bgLetterLbl.clipsToBounds = YES;
    
    self.bgLetterLbl.backgroundColor = [UIColor randomColor];
    
   CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if(height == 480){
    
        self.bgImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        self.bgImageViewConstriant.constant -= 10;
        self.bottomLabelConstraint.constant -= 15;
    
        [self.bgImage layoutIfNeeded];
        
        [self.view layoutIfNeeded];
    }
    else if (height >= 667.0){
        
        self.bgImage.transform = CGAffineTransformMakeScale(1.4, 1.4);
        
        self.bgImageViewConstriant.constant += 60;
        self.bottomLabelConstraint.constant += 65;
        
        [self.bgImage layoutIfNeeded];
        
        [self.view layoutIfNeeded];
        
    }
    
  //  [self.topLabel setText:@"Its 7:30 am for Eric in New York" highlightText:@"7:30 am" withColor:nil];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat delay = 0.5;
     if(self.boardType != DASHBOARDIMAGETYPE){
         delay = 0.0;
     }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //Perform animation
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setConnection:(MyConnection *)connection withUserStatus:(NSDictionary *)status {
    _connection = connection;
    
    self.gradientCircle.hidden = YES;
    self.splitView.hidden = YES;
    
    self.dashboardView.avatar.transform = CGAffineTransformMakeScale(1.18, 1.18);
    self.bgLetterLbl.transform = CGAffineTransformMakeScale(1.18, 1.18);
    
    [self updateMyConnectionData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // self.splitView.splitlist = status;
    });
}

-(void) updateMyConnectionData{
    
    NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",_connection.userId];
    self.dashboardView.urlString = urlString;
    
    self.bgLetterLbl.text = [_connection.fname substringToIndex:1];
    
    NSString *dateString = [[TKDataEngine sharedManager] getTimeFromCurrentDate];
    
    [self.topLabel setText:[NSString stringWithFormat:@"Its %@ for %@ in India",dateString,_connection.fname] highlightText:dateString withColor:nil];
    
    [self.bottomLabel setText:([_connection.gender isEqualToString:@"male"] ? @"Send him a touch now?" : @"Send her a touch now")];
}

-(void) setCircle:(MyCircle *)circle {
    _circle = circle;
    
    NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",circle.userId];
    
    self.dashboardView.urlString = urlString;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  self.splitView.splitlist = circle.userStatus;
//        self.splitView.ratio = self.gradientCircle.ratio;
//        self.splitView.boardType = self.boardType;
//
//        [self.splitView addKnobAnimtation];
    });
    
}

-(void) addTextForImageDashboard {
    
    NSString *lastTime = [[TKDataEngine sharedManager] lastUpdateTimeFromDateString:_others.updateTime];
    
    [self.bottomLabel setText:[NSString stringWithFormat:@"Last touch was %@ ago",lastTime] highlightText:lastTime withColor:nil];
    
    NSDictionary *dict = _others.userStatus.activityStatus;
    
    NSArray *allkeys = [dict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *msg  = @"";
    
    if([dict[allkeys.lastObject] isKindOfClass:[NSNull class]]){
        
        msg = @"a little low";
    }
    else {
        NSString *value = dict[allkeys.lastObject];
        
        msg = (value.intValue > 1) ? @"ok" : @"a little low";
    }
    
    NSString *name = [NSString stringWithFormat:@"%@ is %@ today",self.others.fname,msg];
    
    [self.topLabel setText:name highlightText:msg withColor:nil];
    
    self.bgLetterLbl.text = [self.others.fname substringToIndex:1];


}

-(void) setOthers:(OthersCircle *)others {
    _others = others;
    
     NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",others.userId];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.gradientCircle.splitlist = others.userStatus.activityStatus;

        //Perform animation
        
        [self.splitView animate];

//        self.splitView.ratio = self.gradientCircle.ratio;
//        
//        self.splitView.boardType = self.boardType;
//        
//        [self.splitView addKnobAnimtation];

    });
    
    if(others.homeList.count){
      
        MyHomeLocation *location = [others.homeList objectAtIndex:0];
        self.dashboardView.lat = [NSString stringWithFormat:@"%@", location.latitude];
        self.dashboardView.log = [NSString stringWithFormat:@"%@",location.longitude];
        [self.dashboardView updateLocation];

    }
    
    self.bgLetterLbl.hidden = YES;
    
    self.bgLetterLbl.text = [self.others.fname substringToIndex:1];


    switch (self.boardType) {
        case DASHBOARDIMAGETYPE: {
            
            self.bgLetterLbl.hidden = NO;
            
            [self addTextForImageDashboard];
            
            if(others.didReceiveTouch){
                
                NSString *message = @"is thinking you";
                [self.topLabel setText:[NSString stringWithFormat:@"%@ %@",others.fname,message] highlightText:message withColor:nil];
                
                [self.bottomLabel setText:[NSString stringWithFormat:@"Tap above for a touch from %@",([others.gender isEqualToString:@"male"] ? @"him" : @"her")]];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
                tapGesture.numberOfTapsRequired = 1;
                
                [tapGesture addTarget:self action:@selector(imageRippleEffect:)];
                
                [self.dashboardView.avatar addGestureRecognizer:tapGesture];
                
                self.dashboardView.avatar.userInteractionEnabled = YES;
            }

            
            break;
        }
        case DASHBOARDMAPTYPE: {
            
            NSString *lastHours = @"";
            if(_others.homeList.count){
                
                MyHomeLocation *location = [_others.homeList objectAtIndex:0];
                lastHours =  [[TKDataEngine sharedManager] lastUpdateTimeFromDateString:location.updatedTime];
            }
            else {
               lastHours =  [[TKDataEngine sharedManager] lastUpdateTimeFromDateString:_others.updateTime];
            }
            
            
            [self.topLabel setText:[NSString stringWithFormat:@"%@ is at work",others.fname]];
            
            [self.bottomLabel setText:[NSString stringWithFormat:@"%@ left home %@ ago",others.fname,lastHours] highlightText:lastHours withColor:nil];
            
            break;
        }
        case DASHBOARDCELLULARTYPE:{
            
            UserActivity *useractivity = others.userStatus;
            
            self.dashboardView.g3Level = useractivity.threeGStrength;
            self.dashboardView.wifilevel = useractivity.wifiStrength;
            self.dashboardView.batteryLevel = useractivity.batteryLevel;
            
            NSString *lastTime = [[TKDataEngine sharedManager] lastUpdateTimeFromDateString:useractivity.updatedTime];
            
            NSString * connectedStatus = @"not Connected";
            
            if ([lastTime rangeOfString:@"hour"].location == NSNotFound) {
                connectedStatus = @"Connected";
            }
            
             [self.topLabel setText:[NSString stringWithFormat:@"%@ is %@",others.fname,connectedStatus] highlightText:connectedStatus withColor:nil];
            
            [self.bottomLabel setText:[NSString stringWithFormat:@"Last update on %@ ago", lastTime] highlightText:lastTime withColor:nil];

            break;
        }
            
        default:
            break;
    }
    
    self.dashboardView.urlString = urlString;
}

-(void)imageRippleEffect:(UIGestureRecognizer *)gesture {
    
    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.5];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:@"rippleEffect"];
    
    [animation setFillMode:kCAFillModeRemoved];
    animation.endProgress=0.99;
    [animation setRemovedOnCompletion:NO];
    [self.dashboardView.avatar.layer addAnimation:animation forKey:nil];
    
    [self addTextForImageDashboard];
    
    UIGestureRecognizer *gest = self.dashboardView.avatar.gestureRecognizers[0];
    
    [self.dashboardView.avatar removeGestureRecognizer:gest];
    self.dashboardView.avatar.userInteractionEnabled = NO;
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
@end
