//
//  reuseLabel.m
//  TouchKin
//
//  Created by Shankar K on 06/08/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "reuseLabel.h"
#import "UIColor+Navigation.h"
@implementation reuseLabel
@synthesize oftenUsedLabel;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect rect;
        rect = CGRectMake(0.0,0.0,self.oftenUsedLabel.frame.size.width,self.oftenUsedLabel.frame.size.height);
        
        oftenUsedLabel = [[UILabel alloc] initWithFrame:rect];
        oftenUsedLabel.backgroundColor = [UIColor randomColor];
        //oftenUsedLabel.textColor = [UIColor whiteColor];
        oftenUsedLabel.font = [UIFont boldSystemFontOfSize:33];
        oftenUsedLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        oftenUsedLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:oftenUsedLabel];
    }
    
    return self;
}






@end
