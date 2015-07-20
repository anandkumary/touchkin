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

@interface TKHomeBaseNavigationView : UIView
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet TKHeaderTitleView *titleView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *dropArrow;

@property (nonatomic, assign) NavigationType navType;

@property (nonatomic, copy) NSString *title;

@end
