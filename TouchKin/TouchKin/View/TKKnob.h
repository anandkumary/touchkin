//
//  TKKnob.h
//  TKCircularProgressView
//
//  Created by Anand Kumar  on 8/28/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

// #import "TKOverLaySplitterView.h"
#import <UIKit/UIKit.h>
#import "Define.h"

//IB_DESIGNABLE

@interface TKKnob : UIView //TKOverLaySplitterView

@property (nonatomic, assign)CircleType circleType;
@property (nonatomic,assign) DashboardType dashboardType;
-(void) animate;
@end
