//
//  TKKnob.m
//  TKCircularProgressView
//
//  Created by Anand Kumar  on 8/28/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

#import "TKKnob.h"

#define DEGREES_TO_RADIANS(angle) (angle/180.0*M_PI)

@interface TKKnob ()

@property (nonatomic, strong) CAShapeLayer *circularLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic, assign) CGFloat startAnglePoint;
@property (nonatomic, assign) CGFloat actualAngle;
@property (nonatomic, assign) CGFloat totalIteration;
@property (nonatomic, assign) CGFloat minAngle;
@property (nonatomic, assign) CGFloat endAnglePoint;
@end
@implementation TKKnob


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.startAnglePoint =  (-M_PI_2 + 0);
       // self.endAnglePoint = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKnobStatus:) name:@"knobNotification" object:nil];
    }
    return self;
}

-(void)updateKnobStatus:(NSNotification *)note {
    
    NSDictionary *dict = note.userInfo;
    CGFloat srtPoint = [dict[@"knob"] floatValue];
    
    DashboardType type = [dict[@"type"] integerValue];
    
    if(self.dashboardType == type){
        
        self.startAnglePoint  = (-M_PI_2 + srtPoint);
        
        [self setNeedsDisplay];
    }
        
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
   // if(self.circleType == DASHBOARDOTHERCIRCLE)
    {
     
        CGRect rect1 = rect;
        
//        rect1.origin.x += 7;
//        rect1.origin.y += 7;
//        rect1.size.width += 14;
//        rect1.size.height += 14;
        
       // const NSUInteger kNumCircles = 1u;
        
        CGFloat height = CGRectGetHeight(rect1) - 0;
        
        CGFloat smallCircleRadius = height / 8.0f;
        
        CGRect bigCircleRect = CGRectInset(rect1, smallCircleRadius / 2.0f, smallCircleRadius / 2.0f);
        CGFloat bigCircleRadius = CGRectGetHeight(bigCircleRect) / 2.0f;
        
        CGPoint rectCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2.0f);

        CGFloat alpha = self.startAnglePoint;
        
        // for (NSUInteger i = 0; i < kNumCircles; i++)
        {
            CGPoint smallCircleCenter = CGPointMake(rectCenter.x  + bigCircleRadius * cos(alpha) - smallCircleRadius/2.0f , rectCenter.y  + bigCircleRadius * sin(alpha) - smallCircleRadius / 2.0f );
            
            CGRect smallCircleRect = CGRectMake(smallCircleCenter.x,smallCircleCenter.y,smallCircleRadius,smallCircleRadius);
            
            CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
            CGContextAddEllipseInRect(context, smallCircleRect);
            
            CGContextSetFillColorWithColor(context,[UIColor colorWithRed:49/255.f green:217/255.f blue:93/255.f alpha:1].CGColor);
            
            CGRect smallCircleRect1 = smallCircleRect;
            smallCircleRect1.origin.x -= 1;
            smallCircleRect1.origin.y -= 1;
            smallCircleRect1.size.width -= 2;
            smallCircleRect1.size.height -= 2;
            
            CGContextFillEllipseInRect(context, smallCircleRect1);
            CGContextStrokeEllipseInRect(context, smallCircleRect1);
           //CGContextSetLineWidth(context, 0.5f);
            CGContextStrokePath(context);
            //alpha += M_PI / (kNumCircles / 2.0f);
        }
        
    }
    
   // [self addKnob];
}

-(void) setCircleType:(CircleType)circleType {
    _circleType = circleType;
    
  //  [self setNeedsDisplay];
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // [self.circularLayer removeAllAnimations];

     // [self.timer invalidate];
}

//-(void) addKnob {
//
//  //  CGFloat radius = 80.0;
//
//    if(!self.circularLayer){
//
//        self.circularLayer = [CAShapeLayer layer];
//
//        self.circularLayer.path= [UIBezierPath bezierPathWithRect:self.frame].CGPath;
//
//        self.circularLayer.position = CGPointMake(self.center.x - 7.2,self.center.y - 7.2);
//
//        // Configure the apperence of the circle
//        self.circularLayer.fillColor = [UIColor clearColor].CGColor;
//        self.circularLayer.strokeColor = [UIColor clearColor].CGColor;
//        self.circularLayer.lineWidth = 10;
//
//        [self.layer addSublayer:self.circularLayer];
//
//        CAShapeLayer *knob = [CAShapeLayer layer];
//        [knob setPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.center.x/2 + 24), (self.center.y/4 - 24), 18, 18) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(9, 9)] CGPath]];
//        [knob setFillColor:[[UIColor grayColor] CGColor]];
//        [self.circularLayer addSublayer:knob];
//
//        self.circularLayer.transform = CATransform3DRotate(self.circularLayer.transform, DEGREES_TO_RADIANS(-90), 0.0, 0.0, 1.0);
//    }
//
//}


//- (void)timerFired:(NSTimer *)timer
//{
//    self.percentage += 0.05;
//    CGFloat fullCircleRatio = 0.201666;
//    CGFloat totalPercent = (fullCircleRatio  * self.currentDay);
//    if (self.percentage >= totalPercent) {
//        //self.percentage = self.endedPoint;
//        [self.timer invalidate];
//    }
//    
//    self.startPoint = self.percentage;
//    
//    //self.endAnglePoint += self.minAngle;
//
//    //[self startKnobAnimation:self.endAnglePoint];
//}

//-(void) startKnobAnimation:(CGFloat)endAngle {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//       // CGFloat angle = (360-5) * self.percentage;
//        
//        CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        spinAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.startAnglePoint)];
//        spinAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(endAngle)];
//        spinAnimation.duration = 0.1;
//        spinAnimation.cumulative = YES;
//        spinAnimation.additive = YES;
//        spinAnimation.removedOnCompletion = NO;
//        spinAnimation.fillMode = kCAFillModeForwards;
//        
//        [self.circularLayer addAnimation:spinAnimation forKey:@"spinAnimation"];
//        
//        self.startAnglePoint = endAngle;
//    });
//    
//}


-(void) animate {
//    
//    self.percentage = (0);
//    self.actualAngle = (360 - 15) * self.ratio;
//    
//    CGFloat perSliceRatio = 0.201666;
//
//    self.totalIteration = (perSliceRatio * self.totalDays)/0.05;
//    
//    self.minAngle = (self.actualAngle/self.totalIteration);
//
//    
//    [self.circularLayer removeAllAnimations];
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.04
//                                                  target:self
//                                                selector:@selector(timerFired:)
//                                                userInfo:nil
//                                                 repeats:YES];
//    
}



@end
