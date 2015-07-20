//
//  TKHomeBaseNavigationView.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseNavigationView.h"
#import "TKMyConnectionCell.h"
#import "UIColor+Navigation.h"

@interface TKHomeBaseNavigationView()<TKHeaderTitleDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation TKHomeBaseNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setNavType:(NavigationType)navType {
    
    if(NAVIGATIONTYPENORMAL == navType){
        [self.titleView setIsTapEnabled:NO];
        self.dropArrow.hidden = YES;
    }
    
}

-(void) setTitle:(NSString *)title {
    _title = title;
    
    [self.titleView setTitle:title];
}

- (void) setTitleView:(TKHeaderTitleView *)titleView {
    _titleView =titleView;
    
    _titleView.delegate = self;
}

-(void) headerView :(TKHeaderTitleView *)view didSelectedTitle:(NSString *)headerTitle {
    NSLog(@"header tapped");
    [self animateCollectionViewDown];
}

-(void) animateCollectionViewDown {
    self.topConstraint.constant = 69;
    [self.collectionView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGRect frame = self.frame;
        frame.size.height = 159;
        self.frame = frame;
        
        [self layoutIfNeeded];

    }];
    
}

-(void) animateCollectionViewUp {
    
    self.topConstraint.constant = -90;
    [self.collectionView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGRect frame = self.frame;
        frame.size.height = 70;
        self.frame = frame;
        
        [self layoutIfNeeded];

    }];
    
}

-(void) setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.layer.borderColor = [UIColor navigationColor].CGColor;
    _collectionView.layer.borderWidth = 1.0;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TKMyConnectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myConnection"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TKMyConnectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myConnection" forIndexPath:indexPath];
    
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2;

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self animateCollectionViewUp];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}


@end
