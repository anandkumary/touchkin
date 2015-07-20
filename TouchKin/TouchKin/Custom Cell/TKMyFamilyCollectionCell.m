//
//  TKMyFamilyCollectionCell.m
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMyFamilyCollectionCell.h"
#import "TKMyConnectionCell.h"

@interface TKMyFamilyCollectionCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation TKMyFamilyCollectionCell

-(void) setMyCircleCollectionView:(UICollectionView *)myCircleCollectionView {
    _myCircleCollectionView = myCircleCollectionView;
    _myCircleCollectionView.delegate = self;
    _myCircleCollectionView.dataSource = self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //collectionImageCell
    
    TKMyConnectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionImageCell" forIndexPath:indexPath];
    
    [cell.avatar.layer setCornerRadius:cell.avatar.frame.size.width/2];
    [cell.avatar setBackgroundColor:[UIColor redColor]];
    [cell.avatar setClipsToBounds:YES];
    
    return cell;
    
}

@end
