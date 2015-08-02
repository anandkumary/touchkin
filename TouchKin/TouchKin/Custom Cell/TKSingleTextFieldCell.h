//
//  TKSingleTextFieldCell.h
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKSingleTextFieldCell;

@protocol TKSingleTextFieldCellDelegate <NSObject>

-(void) singleTextFieldCelldidBeginEditing:(TKSingleTextFieldCell *)cell;
-(void) singleTextFieldCell:(TKSingleTextFieldCell *)cell didEndEditingWithString:(NSString *)string;

@end

@interface TKSingleTextFieldCell : UITableViewCell

@property (nonatomic, assign) id<TKSingleTextFieldCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *textField;

-(void) setTextValue:(NSString *)string ;
@end
