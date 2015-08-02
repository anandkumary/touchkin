//
//  TKSingleTextFieldCell.m
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKSingleTextFieldCell.h"

@interface TKSingleTextFieldCell ()<UITextFieldDelegate>

@end

@implementation TKSingleTextFieldCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTextValue:(NSString *)string {
    
    self.textField.text = string;
    self.textField.delegate = self;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if([self.delegate respondsToSelector:@selector(singleTextFieldCelldidBeginEditing:)]){
        
        [self.delegate singleTextFieldCelldidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if([self.delegate respondsToSelector:@selector(singleTextFieldCell:didEndEditingWithString:)]){
        
        [self.delegate singleTextFieldCell:self didEndEditingWithString:textField.text];
    }
}

@end
