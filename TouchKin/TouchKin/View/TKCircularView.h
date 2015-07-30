//
//  TKCircularView.h
//  TouchKin
//
//  Created by Anand kumar on 7/16/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface TKCircularView : UIView

@property (nonatomic) CGFloat trackWidth;
@property (nonatomic) CGFloat progressWidth;
@property (nonatomic) CGFloat roundedCornersWidth;
@property (nonatomic, copy) UIColor * fillColor;
@property (nonatomic, copy) UIColor * trackColor;
@property (nonatomic, copy) UIColor * progressColor;

@property (nonatomic, assign) CGFloat startDegree;
@property (nonatomic, assign) CGFloat endDegree;
@property (nonatomic, assign) CGFloat progress;


@end
