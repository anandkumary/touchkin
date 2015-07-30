//
//  TKGradientCircularView.m
//  TouchKin
//
//  Created by Anand kumar on 7/30/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKGradientCircularView.h"

@interface TKGradientCircularView()

@property (nonatomic,assign) CGFloat ratio;
@end

@implementation TKGradientCircularView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        NSDate *today = [NSDate date]; //Get a date object for today's date
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:today];
        
        
        NSDateComponents *components = [c components:NSCalendarUnitDay fromDate:today];
        
        self.ratio = (CGFloat)components.day / (CGFloat)days.length;

        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat offset = 5;
    
    CGFloat width = self.bounds.size.width - offset;
    CGFloat height = self.bounds.size.height - offset;
    
    CGPoint center = CGPointMake(width/2 + offset/2, (height)/2 + offset/2);
    
    CGFloat lineWidth = 10.0f;

    
    CGFloat radius = (width - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;

    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(204.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 16);
    CGContextAddArc(context, center.x,center.y, radius, startAngle,endAngle + 10, 0);
    CGContextStrokePath(context);
    
    
    CGFloat progressRatio = self.ratio;
        
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapRound;
    processPath.lineWidth = lineWidth;
    // endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    
    
    endAngle = (progressRatio * 2 * (float)M_PI) + startAngle;
    CGFloat tmpStartAngle=startAngle;
    CGFloat shownProgressStep=0.05;
    
    // The size of progress steps to take when rendering progress colors.
    // for (CGFloat shownProgress=0.0;shownProgress <= self.progress ;shownProgress+=shownProgressStep)
    for (CGFloat shownProgress=0.0;shownProgress <= progressRatio ;shownProgress+=shownProgressStep){
        endAngle=(shownProgress * 2 *(float)M_PI) + startAngle;
        
        CGFloat rval= ((251.0/255.0) - ( 0.02 * shownProgress));
        //(1.0-shownProgress) + shownProgress;
        CGFloat gval= ((182.0/255.0) - (0.4 * shownProgress));
        //(1.0-shownProgress);
        CGFloat bval= ((138.0/255.0) - (0.6 * shownProgress));
    
        
        UIColor *progressColor=[UIColor colorWithRed:rval green:gval blue:bval alpha:1.0];
        [progressColor set];
        
        [processPath addArcWithCenter:center radius:radius startAngle:tmpStartAngle endAngle:endAngle clockwise:YES];
        [processPath stroke];
        [processPath removeAllPoints];
        
        tmpStartAngle=endAngle;
    }

}


@end
