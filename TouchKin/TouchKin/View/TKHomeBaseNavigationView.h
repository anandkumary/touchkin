//
//  TKHomeBaseNavigationView.h
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKHeaderTitleView.h"
#import "Define.h"

@class TKHomeBaseNavigationView;

@protocol TKHomeBaseNavigationViewDelegate <NSObject>

-(void) didSelectHeaderTitleAtIndex:(NSInteger)index withUserId:(NSString *)userId;
-(void) homeBaseDidUserTappedOutside:(TKHomeBaseNavigationView *)view;
-(void) homeBaseDidOpen:(TKHomeBaseNavigationView *)view;
-(void) homeBaseDidClose:(TKHomeBaseNavigationView *)view;

@end

@interface TKHomeBaseNavigationView : UIView
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet TKHeaderTitleView *titleView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *dropArrow;

@property (nonatomic, assign) NavigationType navType;

@property (nonatomic, assign) id<TKHomeBaseNavigationViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray *groupList;

@end
