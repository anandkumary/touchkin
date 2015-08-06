//
//  TKMyConnectionCell.h
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKMyConnectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_imageName;
@property (weak, nonatomic) IBOutlet UILabel *userName_CollectionCell;


@property (weak, nonatomic) IBOutlet UILabel *image_CollectionCell;

@end
