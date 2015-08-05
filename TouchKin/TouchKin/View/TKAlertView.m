//
//  TKAlertView.m
//  TouchKin
//
//  Created by Anand kumar on 8/5/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKAlertView.h"

@interface TKAlertView() {
  UILabel *alertlabel;
}
@end

@implementation TKAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}



+ (id)sharedManager {
    static TKAlertView *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.frame = [UIScreen mainScreen].bounds;
        sharedManager.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UIImageView *img = [TKAlertView setupBackGoundImage];
        
        [sharedManager addSubview:img];
        
        UILabel *lbl = [TKAlertView setupAlertLabelForRect:img.frame];
        lbl.tag = 1000;
        [sharedManager addSubview:lbl];
        
    });
    return sharedManager;
}

+(UIImageView *) setupBackGoundImage {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake( size.width/2 - 300/2, size.height/2 - 200/2, 300, 200)];
    
    [imgView setBackgroundColor:[UIColor lightGrayColor]];
    
    return imgView;
}

+(UILabel *) setupAlertLabelForRect:(CGRect)rect {
    
    CGRect frame = rect;
    
    frame.origin.x = 20;
    frame.size.width -= 40;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];

    lbl.numberOfLines = 0;
    return lbl;
    
}


+(void) showAlertWithText:(NSString *)text forView:(UIView *)view {
    
    TKAlertView *alert = [TKAlertView sharedManager];
    
    UILabel *lbl = (UILabel *)[alert viewWithTag:1000];
    
    lbl.text = text;
    
    [view addSubview:alert];
    
}

+(void) hideAlertForView:(UIView *)view {
    
    TKAlertView *alert = [TKAlertView sharedManager];
    [alert removeFromSuperview];

}
+(void) hideAllAlertView {
    TKAlertView *alert = [TKAlertView sharedManager];
    [alert removeFromSuperview];

}

@end
