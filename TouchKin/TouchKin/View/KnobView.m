//
//  KnobView.m
//  circularProgressVIew
//
//  Created by Anand Kumar  on 8/17/15.
//  Copyright (c) 2015 YMediaLabs. All rights reserved.
//

#import "KnobView.h"

#define DEGREES_TO_RADIANS(angle) (angle/180.0*M_PI)

@interface KnobView()
@property (nonatomic, strong) CAShapeLayer *circularLayer;
@end
@implementation KnobView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    self.backgroundColor = [UIColor clearColor];

    
    [self addKnob];
}


-(void) addKnob {
    
    CGFloat radius = 80.0;
    
    if(!self.circularLayer){
        
        self.circularLayer = [CAShapeLayer layer];
        
        self.circularLayer.path= [UIBezierPath bezierPathWithRect:self.frame].CGPath;
        
        self.circularLayer.position = CGPointMake(self.center.x - 5,self.center.y - 5);
        
        // Configure the apperence of the circle
        self.circularLayer.fillColor = [UIColor clearColor].CGColor;
        self.circularLayer.strokeColor = [UIColor clearColor].CGColor;
        self.circularLayer.lineWidth = 10;
        
        [self.layer addSublayer:self.circularLayer];
        
        CAShapeLayer *knob = [CAShapeLayer layer];
        [knob setPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.center.x + 58) - radius, ((self.center.y/2) + 27) - radius, 20, 20) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)] CGPath]];
        [knob setFillColor:[[UIColor grayColor] CGColor]];
        [self.circularLayer addSublayer:knob];
        
        // [self.circularLayer insertSublayer:knob atIndex:[self.circularLayer.sublayers count]];
        
        self.circularLayer.masksToBounds = NO;
        
        self.circularLayer.transform = CATransform3DRotate(self.circularLayer.transform, DEGREES_TO_RADIANS(-90), 0.0, 0.0, 1.0);
    }
    


}

-(void) addKnobAnimtation {
    
    [self animate];
}

-(void) animate {
    
    CGFloat angle = (360-5) * self.ratio;
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
    spinAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(angle)];
    spinAnimation.duration = 0.7;
    spinAnimation.cumulative = YES;
    spinAnimation.additive = YES;
    spinAnimation.removedOnCompletion = NO;
    spinAnimation.fillMode = kCAFillModeForwards;
    
    [self.circularLayer addAnimation:spinAnimation forKey:@"spinAnimation"];
 
}




@end
