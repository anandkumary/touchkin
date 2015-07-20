//
//  TKHeaderTitleView.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHeaderTitleView.h"

@interface TKHeaderTitleView()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation TKHeaderTitleView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewDidSelect)];
        [_tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setIsTapEnabled:(BOOL)isTapEnabled {
    _isTapEnabled = isTapEnabled;
    
    if(!isTapEnabled){
        [self removeGestureRecognizer:self.tapGesture];
    }
}

-(void) setTitle:(NSString *)title {
    _title =title;
    
    self.titleLabel.text = title;
}

-(void)titleViewDidSelect {
    
    if([self.delegate respondsToSelector:@selector(headerView:didSelectedTitle:)]){
        [self.delegate headerView:self didSelectedTitle:self.title];
    }
}

@end
