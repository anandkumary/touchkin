//
//  TKMyFamilyCollectionCell.h
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@protocol TKMyFamilyCollectionCellDelegate <NSObject>

-(void) didCellSelectAtIndex:(NSInteger)index;

@end

@interface TKMyFamilyCollectionCell : UITableViewCell

@property (nonatomic, assign) FamilyType familyType;
@property (nonatomic, assign) id<TKMyFamilyCollectionCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *myCircleCollectionView;

@property (nonatomic, strong) NSMutableArray *connectList;
@end
