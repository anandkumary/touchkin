//
//  TKNavigationView.h
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MLAnimationBlock)(BOOL onComplete);

@interface TKNavigationView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

-(void)forceViewToTop;
-(void) animateDown;
-(void) animateTop:(MLAnimationBlock)complete;

@end
