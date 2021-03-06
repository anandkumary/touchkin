//
//  TKOverLaySplitterView.h
//  TKCircularProgressView
//
//  Created by Anand Kumar  on 8/28/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface TKOverLaySplitterView : UIView

@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat endedPoint;
@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic,assign) NSInteger currentDay;
@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic,assign) CGFloat startedPoint;
@property (nonatomic, assign) DashboardType dashboardType;

-(void) animate ;
@end
