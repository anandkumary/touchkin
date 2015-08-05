//
//  TKKinBookCollectionCell.h
//  TouchKin
//
//  Created by Anand kumar on 7/26/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKKinBookCollectionCell;

@protocol TKKinBookCollectionCellDelegate <NSObject>

-(void) didPlayButtonSelected:(TKKinBookCollectionCell*)cell;

@end

@interface TKKinBookCollectionCell : UICollectionViewCell
@property (nonatomic, assign) id<TKKinBookCollectionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end
