//
//  TKAlertView.h
//  TouchKin
//
//  Created by Anand kumar on 8/5/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAlertView : UIView

+ (id)sharedManager;

+(void) showAlertWithText:(NSString *)text forView:(UIView *)view;
+(void) hideAlertForView:(UIView *)view;
+(void) hideAllAlertView;

@end
