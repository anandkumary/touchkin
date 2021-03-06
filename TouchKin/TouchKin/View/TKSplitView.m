//
//  TKSplitView.m
//  TouchKin
//
//  Created by Anand kumar on 7/30/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKSplitView.h"

@interface TKSplitView ()
@end

@implementation TKSplitView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGFloat offset = 5;
    
    CGFloat width = self.bounds.size.width - offset;
    CGFloat height = self.bounds.size.height - offset;
    
    CGFloat lineWidth = 10.5f;
    
    CGPoint center = CGPointMake(width/2 + offset/2, (height)/2 + offset/2);
    CGFloat radius = (width - lineWidth)/2;
    CGFloat startAngle = -(((float)M_PI / 2) + 0.07);
    // 90 degrees
    // CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(244.0/255.0) green:(243.0/255.0) blue:(243.0/255.0) alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 10.5f);
    
    CGFloat j= 0.0;
    
    for ( int i = 0; i < self.splitlist.allKeys.count; i++) {
        
        NSArray *keys = self.splitlist.allKeys;
        
        int value = ([self.splitlist[keys[i]] isKindOfClass:[NSNull class]])? 0 : 1;
       
        if(value == 0)
        {
        
            CGContextAddArc(context, center.x + 1.0,center.y, radius, j + startAngle, 0.21 + (j + startAngle), 0);
            CGContextStrokePath(context);
        }
       
        j += 0.2;
    }
    
}

-(void) setSplitlist:(NSDictionary *)splitlist {
    
    self.backgroundColor = [UIColor clearColor];
    
    _splitlist = splitlist;
    
    [self setNeedsDisplay];
}


@end
