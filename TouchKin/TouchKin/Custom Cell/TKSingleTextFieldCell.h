//
//  TKSingleTextFieldCell.h
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKSingleTextFieldCellDelegate <NSObject>



@end

@interface TKSingleTextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
