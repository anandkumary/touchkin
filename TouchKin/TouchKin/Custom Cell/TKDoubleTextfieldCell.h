//
//  TKDoubleTextfieldCell.h
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKDoubleTextfieldCell;

@protocol TKDoubleTextfieldCellDelegate <NSObject>

-(void) doubleTextFieldCelldidBeginEditing:(TKDoubleTextfieldCell *)cell;
-(void) doubleTextFieldCell:(TKDoubleTextfieldCell *)cell didEndEditText:(NSString *)string;

@end

@interface TKDoubleTextfieldCell : UITableViewCell

@property (nonatomic, assign) id<TKDoubleTextfieldCellDelegate> delegate;

-(void) settextValue:(NSString *)string;
-(void) setYobValue:(NSString *)yob;

@end
