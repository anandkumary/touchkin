//
//  TKMyFamilyRequestCell.h
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKMyFamilyRequestCell;

@protocol TKMyFamilyRequestCellDelegate  <NSObject>

-(void) requestDidCancelCell:(TKMyFamilyRequestCell *)cell;
-(void) requestDidAcceptCell:(TKMyFamilyRequestCell *)cell;

@end

@interface TKMyFamilyRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (nonatomic, assign) id<TKMyFamilyRequestCellDelegate> delegate;

@end
