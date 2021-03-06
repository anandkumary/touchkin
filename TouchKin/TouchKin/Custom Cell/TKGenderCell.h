//
//  TKGenderCell.h
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKGenderCell;

@protocol TKGenderCellDelegate <NSObject>

-(void) genderCell:(TKGenderCell *)cell didSelectedGenderType:(BOOL) genderType ;

@end

@interface TKGenderCell : UITableViewCell

@property (nonatomic, assign) id<TKGenderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *sheBtn;
@property (weak, nonatomic) IBOutlet UIButton *heBtn;

@end
