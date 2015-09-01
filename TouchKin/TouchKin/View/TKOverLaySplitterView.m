//
//  TKOverLaySplitterView.m
//  TKCircularProgressView
//
//  Created by Anand Kumar  on 8/28/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

#import "TKOverLaySplitterView.h"

@interface TKOverLaySplitterView ()

@end
@implementation TKOverLaySplitterView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.startPoint = 0.0;
        
        NSDate *today = [NSDate date]; //Get a date object for today's date
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit: NSCalendarUnitDay
                               inUnit:NSCalendarUnitMonth
                              forDate:today];
        
        self.totalDays = (days.length > 30) ? 30 : days.length;
        
        NSDateComponents *components = [c components:NSCalendarUnitDay fromDate:today];

         self.ratio = (CGFloat)components.day / (CGFloat)days.length;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    

    CGFloat start  = (-M_PI_2 + self.startPoint);
    CGFloat endPoint = (-M_PI_2 + (0.213 * self.totalDays));
    
    self.endedPoint = endPoint - 0.213;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, (205.0/255.0f), (204.0/255.0f), (204.0/255.0f), 1.0);
    CGContextMoveToPoint(context, self.center.x - 5,self.center.y -6);
    CGContextAddArc(context, self.center.x - 5, self.center.y - 6 , 82.0, start, self.endedPoint, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);

}

-(void) setStartPoint:(CGFloat)startPoint {
    
    _startPoint = startPoint;
    
    [self setNeedsDisplay];
}


@end
