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
        self.startAnglePoint = 0;
        self.endAnglePoint = 0;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    [self addKnob];
}


-(void) addKnob {
    
  //  CGFloat radius = 80.0;
    
    if(!self.circularLayer){
        
        self.circularLayer = [CAShapeLayer layer];
        
        self.circularLayer.path= [UIBezierPath bezierPathWithRect:self.frame].CGPath;
        
        self.circularLayer.position = CGPointMake(self.center.x - 7.2,self.center.y - 7.2);
        
        // Configure the apperence of the circle
        self.circularLayer.fillColor = [UIColor clearColor].CGColor;
        self.circularLayer.strokeColor = [UIColor clearColor].CGColor;
        self.circularLayer.lineWidth = 10;
        
        [self.layer addSublayer:self.circularLayer];
        
        CAShapeLayer *knob = [CAShapeLayer layer];
        [knob setPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.center.x/2 + 24), (self.center.y/4 - 24), 18, 18) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(9, 9)] CGPath]];
        [knob setFillColor:[[UIColor grayColor] CGColor]];
        [self.circularLayer addSublayer:knob];
        
        self.circularLayer.transform = CATransform3DRotate(self.circularLayer.transform, DEGREES_TO_RADIANS(-90), 0.0, 0.0, 1.0);
    }
    
}

-(void)dealloc {
    
     [self.circularLayer removeAllAnimations];

      [self.timer invalidate];
}

- (void)timerFired:(NSTimer *)timer
{
    self.percentage += 0.05;
    CGFloat fullCircleRatio = 0.201666;
    CGFloat totalPercent = (fullCircleRatio  * self.totalDays);
    if (self.percentage >= totalPercent) {
        //self.percentage = self.endedPoint;
        [self.timer invalidate];
    }
    
    self.startPoint = self.percentage;
    
    self.endAnglePoint += self.minAngle;

    [self startKnobAnimation:self.endAnglePoint];
}

-(void) startKnobAnimation:(CGFloat)endAngle {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       // CGFloat angle = (360-5) * self.percentage;
        
        CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        spinAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(self.startAnglePoint)];
        spinAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(endAngle)];
        spinAnimation.duration = 0.1;
        spinAnimation.cumulative = YES;
        spinAnimation.additive = YES;
        spinAnimation.removedOnCompletion = NO;
        spinAnimation.fillMode = kCAFillModeForwards;
        
        [self.circularLayer addAnimation:spinAnimation forKey:@"spinAnimation"];
        
        self.startAnglePoint = endAngle;
    });
    
}
-(void) animate {
    
    self.percentage = (0);
    self.actualAngle = (360 - 15) * self.ratio;
    
    CGFloat perSliceRatio = 0.201666;

    self.totalIteration = (perSliceRatio * self.totalDays)/0.05;
    
    self.minAngle = (self.actualAngle/self.totalIteration);

    
    [self.circularLayer removeAllAnimations];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    
}



@end
