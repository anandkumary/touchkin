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
#import "reuseLabel.h"

@interface TKHomeBaseNavigationView()<TKHeaderTitleDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *selectedId;
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
        
        [self.titleView setIsTapEnabled:NO];
        self.dropArrow.hidden = YES;
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

    }completion:^(BOOL finished) {
    
        if([self.delegate respondsToSelector:@selector(homeBaseDidOpen:)]){
            [self.delegate homeBaseDidOpen:self];
        }
        
    } ];
    
}

-(void) animateCollectionViewUp {
    
    self.topConstraint.constant = -90;
    [self.collectionView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGRect frame = self.frame;
        frame.size.height = 90;
        self.frame = frame;
        
        [self layoutIfNeeded];

    }completion:^(BOOL finished) {
        self.selectedId = nil;
        [self.collectionView reloadData];
        
        if([self.delegate respondsToSelector:@selector(homeBaseDidClose:)]){
            [self.delegate homeBaseDidClose:self];
        }
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
    
    cell.avatar.backgroundColor = [UIColor clearColor];
    cell.avatar.image = [UIImage imageNamed:@"add_avatar"];
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2;
    cell.avatar.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    cell.avatar.layer.borderWidth  = 2.0;
    cell.avatar.clipsToBounds = YES;
    cell.lbl_imageName.layer.cornerRadius = cell.lbl_imageName.frame.size.width/2;
    cell.lbl_imageName.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    cell.lbl_imageName.layer.borderWidth = 2.0;
    cell.lbl_imageName.clipsToBounds = YES;

    if(self.groupList.count != indexPath.item){
       
        MyCircle *circle = [self.groupList objectAtIndex:indexPath.item];
        OthersCircle *others = nil;
        
        NSString *userId = nil;
        NSString *userName = nil;

        if(![circle isKindOfClass:[MyCircle class]]){
            
            others = (OthersCircle *)circle;
            userId = others.userId;
            userName =others.fname;
            [cell.userNameLabel setText:userName];

        }
        else if([circle isKindOfClass:[MyCircle class]]){
            userId = circle.userId;
            userName =circle.userName;
            [cell.userNameLabel setText:userName];

        }else{
            
            [cell.userNameLabel setText:@"Add Kin"];

        }
        [cell.lbl_imageName setBackgroundColor:[UIColor randomColor]];
        [cell.lbl_imageName setText:[userName substringToIndex:1]];
        cell.userNameLabel.adjustsFontSizeToFitWidth = YES;
        cell.checkMark.hidden = YES;

        
        if([self.selectedId containsObject:userId]){
            cell.avatar.layer.borderColor = [UIColor colorWithRed:(249.0/255.0) green:(133.0/255.0) blue:(74.0/255.0) alpha:1.0].CGColor;
            cell.checkMark.hidden = NO;
        }
        else {
            
            cell.avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
        }
        
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",userId]];
        
        
        [cell.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
           
            if (image == nil) {
                
                cell.lbl_imageName.hidden = NO;
                
            }else{
                cell.avatar.image = image;
                cell.lbl_imageName.hidden = YES;
            }
        }];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.groupList.count != indexPath.item ) {
        
        OthersCircle *others = [self.groupList objectAtIndex:indexPath.item];
        
        if(!self.selectedId){
            self.selectedId = [[NSMutableArray alloc] init];
        }
        
        TKMyConnectionCell *cell = (TKMyConnectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if(![self.selectedId containsObject:others.userId]){
            [self.selectedId addObject:others.userId];
            
            cell.avatar.layer.borderColor = [UIColor colorWithRed:(249.0/255.0) green:(133.0/255.0) blue:(74.0/255.0) alpha:1.0].CGColor;
            cell.checkMark.hidden = NO;

        }
        else {
            [self.selectedId removeObject:others.userId];
            cell.checkMark.hidden = YES;
            cell.avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;

        }
        
        self.title = (indexPath.row == 0) ? @"My Family" : others.fname;
        
        if([self.delegate respondsToSelector:@selector(didSelectHeaderTitleAtIndex:withUserId:)]){
            [self.delegate didSelectHeaderTitleAtIndex:indexPath.item withUserId:others.userId];
        }

    }
    else {
        //Add new care taker
        if([self.delegate respondsToSelector:@selector(homeBaseDidTapCareForSomeone:)]){
            [self.delegate homeBaseDidTapCareForSomeone:self];
        }

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
    return CGSizeMake(60, 82);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self animateCollectionViewUp];
   
    if([self.delegate respondsToSelector:@selector(homeBaseDidUserTappedOutside:)]){
        [self.delegate homeBaseDidUserTappedOutside:self];
    }
}

@end
