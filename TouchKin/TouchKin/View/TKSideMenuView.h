//
//  TKSideMenuView.h
//  TouchKin
//
//  Created by Anand kumar on 7/16/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKSideMenuView;
@protocol SideMenuDelegate <NSObject>

-(void)sideMenu:(TKSideMenuView *)menu didSlecetAtIndex:(NSInteger)index;

@end

@interface TKSideMenuView : UIView
@property (nonatomic, weak) IBOutlet UITableView *menuTable;
@property (nonatomic, weak)IBOutlet NSLayoutConstraint *menuLeftConstriant;
@property (nonatomic, weak) IBOutlet UIImageView *bgImage;

@property (nonatomic,assign) id<SideMenuDelegate> delegate;

@end
