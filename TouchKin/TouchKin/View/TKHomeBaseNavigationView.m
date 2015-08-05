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
#import "UIImageView+WebCache.h"
#import "MyCircle.h"
#import "OthersCircle.h"

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
    
    _navType = navType;
    
    if(NAVIGATIONTYPENORMAL == navType){
        [self.titleView setIsTapEnabled:NO];
        self.dropArrow.hidden = YES;
    }
    
    if(NAVIGATIONTYPECAMERA == navType){
        self.titleView.hidden = NO;
        [self animateCollectionViewDown];
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
    //  NSLog(@"header tapped");
    
    if(self.topConstraint.constant != 69){
        [self animateCollectionViewDown];
    }
    else{
        [self animateCollectionViewUp];
    }
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

-(void) setGroupList:(NSMutableArray *)groupList {
    _groupList = groupList;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupList.count +  ((NAVIGATIONTYPECAMERA == self.navType) ? 0 : 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TKMyConnectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myConnection" forIndexPath:indexPath];
    
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2;
    
    if(self.groupList.count != indexPath.item){
       
        MyCircle *circle = [self.groupList objectAtIndex:indexPath.item];
        OthersCircle *others = nil;
        
        NSString *userId = nil;
        
        if(![circle isKindOfClass:[MyCircle class]]){
            
            others = (OthersCircle *)circle;
            userId = others.userId;
        }
        else{
            userId = circle.userId;
        }
        
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",userId]];
        
        [cell.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            cell.avatar.image = image;
        }];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.groupList.count != indexPath.item ) {
        
        OthersCircle *others = [self.groupList objectAtIndex:indexPath.item];
        
        self.title = (indexPath.row == 0) ? @"My Family" : others.fname;
        
        if([self.delegate respondsToSelector:@selector(didSelectHeaderTitleAtIndex:withUserId:)]){
            [self.delegate didSelectHeaderTitleAtIndex:indexPath.item withUserId:others.userId];
        }

    }
    else {
        //Add new care taker
    }
    
    if(NAVIGATIONTYPECAMERA != self.navType){
        [self animateCollectionViewUp];
    }
    else {
       self.title = @"My Family";
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}


@end
