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
#import "UIColor+Navigation.h"

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
    [cell.avatar setBackgroundColor:[UIColor randomColor]];
    [cell.avatar setClipsToBounds:YES];
    cell.image_CollectionCell.layer.cornerRadius = cell.image_CollectionCell.frame.size.width/2;
    cell.image_CollectionCell.clipsToBounds = YES;

    if(self.connectList.count == indexPath.item){
        
        cell.avatar.image = [UIImage imageNamed:@"add_avatar"];
        cell.userName_CollectionCell.text = @"Add Kin";
        return cell;
    }
    
    MyConnection *connect = [self.connectList objectAtIndex:indexPath.item];
    cell.image_CollectionCell.text = [NSString stringWithFormat:@"%@",[connect.fname substringToIndex:1]];
    cell.image_CollectionCell.backgroundColor = [UIColor randomColor];
    //[cell.userName_CollectionCell sizeToFit];
    cell.userName_CollectionCell.text =[NSString stringWithFormat:@"%@",connect.fname];
    cell.userName_CollectionCell.adjustsFontSizeToFitWidth = YES;
   

//    if(){
//        cell.userName_CollectionCell.text = @"Add Kin";
//    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",connect.userId]];
    [cell.avatar setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
       
        if (image ==nil) {
            cell.image_CollectionCell.hidden = NO;
        }else{
            
        cell.avatar.image = image;
        cell.image_CollectionCell.hidden = YES;

        }
    }];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.connectList.count == indexPath.item) {
        
        if([self.delegate respondsToSelector:@selector(didCellSelectAtIndex:)])
        {
            [self.delegate didCellSelectAtIndex:indexPath.item];
        }
        
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 82);
}


-(void) setConnectList:(NSMutableArray *)connectList {
    _connectList = connectList;
    
    [self.myCircleCollectionView reloadData];
}

@end
