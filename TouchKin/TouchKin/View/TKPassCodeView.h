//
//  TKPassCodeView.h
//  TouchKin
//
//  Created by Anand kumar on 7/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKPassCodeView;

@protocol TKPassCodeViewDelegate <NSObject>

-(void) passcode:(TKPassCodeView *)view didTextEntered:(NSString *)text;

@end

IB_DESIGNABLE
@interface TKPassCodeView : UIView

@property (nonatomic, assign) id <TKPassCodeViewDelegate> delegate;
@end
