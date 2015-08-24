//
//  TKGradientCircularView.h
//  TouchKin
//
//  Created by Anand kumar on 7/30/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface TKGradientCircularView : UIView
@property (nonatomic,assign) CGFloat ratio;

-(void) startAnimating;
@end
