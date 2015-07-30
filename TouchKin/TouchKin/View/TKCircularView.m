//
//  TKCircularView.m
//  TouchKin
//
//  Created by Anand kumar on 7/16/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKCircularView.h"
#import "UIColor+Navigation.h"

#define KADegreesToRadians(degrees) ((degrees)/180.0*M_PI)
#define KARadiansToDegrees(radians) ((radians)*180.0/M_PI)



@implementation TKCircularView 

@synthesize startDegree = _startDegree;
@synthesize endDegree = _endDegree;
@synthesize progress = _progress;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}


-(void)baseInit
{
    // We need a square view
    // For now, we resize  and center the view
    if(self.frame.size.width != self.frame.size.height){
        CGRect frame = self.frame;
        float delta = ABS(self.frame.size.width-self.frame.size.height)/2;
        if(self.frame.size.width > self.frame.size.height){
            frame.origin.x += delta;
            frame.size.width = self.frame.size.height;
            self.frame = frame;
        }else{
            frame.origin.y += delta;
            frame.size.height = self.frame.size.width;
            self.frame = frame;
        }
    }
    // [self setUserInteractionEnabled:YES];
    
    // Style
    self.trackWidth             = 10.0;
    self.progressWidth          = 10.0;
    self.roundedCornersWidth    = 0.0;
    self.fillColor              = [UIColor clearColor];
    self.trackColor             = [UIColor colorWithRed:(204.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0];
    self.progressColor          = [UIColor navigationColor];
    
    
    // Logic
    self.startDegree        = 0;
    self.endDegree          = 0;
    self.progress           = 0;
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
  
    [self drawProgressLabelCircleInRect:rect];
}

-(void)drawProgressLabelCircleInRect:(CGRect)rect
{
    
    CGRect circleRect= [self rectForCircle:rect];
    CGFloat archXPos = rect.size.width/2 + rect.origin.x;
    CGFloat archYPos = rect.size.height/2 + rect.origin.y;
    CGFloat archRadius = (circleRect.size.width) / 2.0;
    
    CGFloat trackStartAngle = KADegreesToRadians(0);
    CGFloat trackEndAngle = KADegreesToRadians(360);
    CGFloat progressStartAngle = KADegreesToRadians(_startDegree);
    CGFloat progressEndAngle = KADegreesToRadians(_endDegree);
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Circle
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2));
    CGContextStrokePath(context);
    
    // Track
    CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor);
    CGContextSetLineWidth(context, _trackWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, trackStartAngle, trackEndAngle, 1);
    CGContextStrokePath(context);
    
    // Progress
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextSetLineWidth(context, _progressWidth);
    CGContextAddArc(context, archXPos,archYPos, archRadius, progressStartAngle, progressEndAngle, 0);
    CGContextStrokePath(context);
    
}

#pragma mark - Getters

- (float) radius
{
    return MIN(self.frame.size.width,self.frame.size.height)/2;
}

- (CGFloat)startDegree
{
    return _startDegree +90;
}

- (CGFloat)endDegree
{
    return _endDegree +90;
}

- (CGFloat)progress
{
    return self.endDegree/360;
}

-(void)setStartDegree:(CGFloat)startDegree
{
    _startDegree = startDegree - 90;
}

-(void)setEndDegree:(CGFloat)endDegree
{
    _endDegree = endDegree - 90;
}

-(void)setProgress:(CGFloat)progress
{
    if(self.startDegree != 0){
        [self setStartDegree:0];
    }
    [self setEndDegree:progress*360];
}


#pragma mark - Helpers

- (CGRect) rectForDegree:(float) degree andRect:(CGRect) rect
{
    float x = [self xPosRoundForAngle:degree andRect:rect] - _roundedCornersWidth/2;
    float y = [self yPosRoundForAngle:degree andRect:rect] - _roundedCornersWidth/2;
    return CGRectMake(x, y, _roundedCornersWidth, _roundedCornersWidth);
}

- (float) xPosRoundForAngle:(float) degree andRect:(CGRect) rect
{
    return cosf(KADegreesToRadians(degree))* [self radius]
    - cosf(KADegreesToRadians(degree)) * [self borderDelta]
    + rect.size.width/2;
}

- (float) yPosRoundForAngle:(float) degree andRect:(CGRect) rect
{
    return sinf(KADegreesToRadians(degree))* [self radius]
    - sinf(KADegreesToRadians(degree)) * [self borderDelta]
    + rect.size.height/2;
}


- (float) borderDelta
{
    return MAX(MAX(_trackWidth,_progressWidth),_roundedCornersWidth)/2;
}

-(CGRect)rectForCircle:(CGRect)rect
{
    CGFloat minDim = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat circleRadius = (minDim / 2) - [self borderDelta];
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return CGRectMake(circleCenter.x - circleRadius, circleCenter.y - circleRadius, 2 * circleRadius, 2 * circleRadius);
}



@end
