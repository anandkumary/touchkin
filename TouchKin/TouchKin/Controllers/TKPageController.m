//
//  TKPageController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKPageController.h"
#import "TKCircularView.h"
#import "UILabel+Attribute.h"
#import "MyHomeLocation.h"
#import "TKDataEngine.h"
#import "UserActivity.h"

@interface TKPageController ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIView *bgImage;
@property (weak, nonatomic) IBOutlet TKCircularView *circularView;

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
    
//    NSDate *today = [NSDate date]; //Get a date object for today's date
//    NSCalendar *c = [NSCalendar currentCalendar];
//    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
//                           inUnit:NSMonthCalendarUnit
//                          forDate:today];
//    
//    
//    NSDateComponents *components = [c components:NSCalendarUnitDay fromDate:today];
//    
//  CGFloat ratio = (CGFloat)components.day / (CGFloat)days.length;
//
//  [self.circularView setProgress:ratio];
    
    
    
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
    
    // self.topLabel.text = @"Its 7:30 am for Eric in New York";
    
    [self.topLabel setText:@"Its 7:30 am for Eric in New York" highlightText:@"7:30 am" withColor:nil];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gradientCircle startAnimating];
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) setConnection:(MyConnection *)connection {
    _connection = connection;
    
    NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",connection.userId];
    self.dashboardView.urlString = urlString;
    
    NSString *dateString = [[TKDataEngine sharedManager] getTimeFromCurrentDate];
    
    [self.topLabel setText:[NSString stringWithFormat:@"Its %@ for %@ in India",dateString,connection.fname] highlightText:dateString withColor:nil];
    
    [self.bottomLabel setText:([connection.gender isEqualToString:@"male"] ? @"Send him a touch now?" : @"Send her a touch now")];

    
}

-(void) setCircle:(MyCircle *)circle {
    _circle = circle;
    
    NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",circle.userId];
    
    self.dashboardView.urlString = urlString;
    
    
}

-(void) setOthers:(OthersCircle *)others {
    _others = others;
    
     NSString *urlString = [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",others.userId];
    
    self.splitView.splitlist = others.userStatus.activityStatus;
    
    if(others.homeList.count){
      
        MyHomeLocation *location = [others.homeList objectAtIndex:0];
        self.dashboardView.lat = [NSString stringWithFormat:@"%@", location.latitude];
        self.dashboardView.log = [NSString stringWithFormat:@"%@",location.longitude];
        
        [self.dashboardView updateLocation];

    }
    
    switch (self.boardType) {
        case DASHBOARDIMAGETYPE: {
          
            NSString *lastTime = [[TKDataEngine sharedManager] lastUpdateTimeFromDateString:others.updateTime];
            
            [self.bottomLabel setText:[NSString stringWithFormat:@"Last touch was %@ ago",lastTime] highlightText:lastTime withColor:nil];
            
            NSDictionary *dict = others.userStatus.activityStatus;
            
            NSArray *allkeys = [dict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            NSString *msg  = @"";
            
            if([dict[allkeys.lastObject] isKindOfClass:[NSNull class]]){
                
                msg = @"little low";
            }
            else {
                NSString *value = dict[allkeys.lastObject];
                
               msg = (value.intValue > 1) ? @"ok" : @"little low";
            }
            
            NSString *name = [NSString stringWithFormat:@"%@ is %@ today",others.fname,msg];

            [self.topLabel setText:name highlightText:msg withColor:nil];
            
            break;
        }
        case DASHBOARDMAPTYPE: {
            
            [self.bottomLabel setText:@"Working on it"];
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
@end
