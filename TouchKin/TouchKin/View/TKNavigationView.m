//
//  TKNavigationView.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKNavigationView.h"
#import "UIColor+Navigation.h"

#define KNAVIGATIONBARFRAME CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)

@interface TKNavigationView()

@property (nonatomic, strong) UILabel * navigationTitle;
@end

@implementation TKNavigationView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    
        self.frame = KNAVIGATIONBARFRAME;
        self.backgroundColor = [UIColor navigationColor];
    
        [self setUpNavigation];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.frame = KNAVIGATIONBARFRAME;
        self.backgroundColor = [UIColor navigationColor];
        
        [self setUpNavigation];

    }
    return self;
}

-(void) setUpNavigation {
    
    CGPoint point = self.center;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 120;
    CGFloat height = 30;
    
    self.navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(point.x - width/2, self.frame.size.height - (height + 5),width, height)];
    
    [self.navigationTitle setBackgroundColor:[UIColor clearColor]];
    [self.navigationTitle setTextColor:[UIColor whiteColor]];
    [self.navigationTitle setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.navigationTitle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.navigationTitle.text = title;
}

-(void)forceViewToTop {
    CGRect frame = self.frame;
    frame.origin.y = -40;
    self.frame = frame;

}

-(void) animateTop:(MLAnimationBlock)complete {
    
    self.navigationTitle.hidden = YES;
    
    self.topConstraint.constant = -40;
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        [self setNeedsDisplay];
        
    }completion:^(BOOL finished) {
        
        complete(YES);
    }];
}

-(void) animateDown {
    
    self.navigationTitle.hidden = NO;
    
    self.topConstraint.constant = 0;
    [self updateConstraintsIfNeeded];
   
    [UIView animateWithDuration:0.4 animations:^{
        [self setNeedsDisplay];
    }];
}

@end
