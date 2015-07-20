//
//  TKHeaderTitleView.h
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKHeaderTitleView;
@protocol TKHeaderTitleDelegate <NSObject>

-(void) headerView :(TKHeaderTitleView *)view didSelectedTitle:(NSString *)headerTitle;

@end

@interface TKHeaderTitleView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isTapable) BOOL isTapEnabled;
@property (nonatomic,assign) id<TKHeaderTitleDelegate> delegate;

@end
