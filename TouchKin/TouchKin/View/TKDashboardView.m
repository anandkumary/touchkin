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

@interface TKDashboardView()
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
       
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        self.wifiImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"wifi%d",delegate.isConnectedToWifi]];
        
        self.cellularImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Network%d",delegate.isConnectedTo3G]];
    });
    
}

-(void) setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    
    if(DASHBOARDIMAGETYPE == self.type) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        __weak typeof(UIImageView *) weakSelf = self.avatar;
        
        [self.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = image;
  
            });
        }];
    }
}

@end
