//
//  TKMyFamilyCollectionCell.m
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMyFamilyCollectionCell.h"
#import "TKMyConnectionCell.h"
#import "UIImageView+WebCache.h"
#import "MyConnection.h"

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
    
    return self.connectList.count + ((MYFAMILYTYPE == self.familyType) ? 1 : 1);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //collectionImageCell
    
    TKMyConnectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionImageCell" forIndexPath:indexPath];
    
    [cell.avatar.layer setCornerRadius:cell.avatar.frame.size.width/2];
    [cell.avatar setBackgroundColor:[UIColor redColor]];
    [cell.avatar setClipsToBounds:YES];
    
    if(self.connectList.count == indexPath.item){
        
        cell.avatar.image = [UIImage imageNamed:@"add_avatar"];
        
        return cell;
    }
    
    MyConnection *connect = [self.connectList objectAtIndex:indexPath.item];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",connect.userId]];
    
    [cell.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
       
        cell.avatar.image = image;
    }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.connectList.count == indexPath.item) {
        
        if([self.delegate respondsToSelector:@selector(didCellSelectAtIndex:)]){
            [self.delegate didCellSelectAtIndex:indexPath.item];
        }
        
    }
    
}

-(void) setConnectList:(NSMutableArray *)connectList {
    _connectList = connectList;
    
    [self.myCircleCollectionView reloadData];
}

@end
