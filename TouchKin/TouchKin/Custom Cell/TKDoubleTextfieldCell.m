//
//  TKDoubleTextfieldCell.m
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKDoubleTextfieldCell.h"
#import "TKUtility.h"

@interface TKDoubleTextfieldCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UIButton *yobBtn;

@end

@implementation TKDoubleTextfieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)yobButtonAction:(id)sender {
}

-(void) settextValue:(NSString *)string {
    
    self.ageTextField.text = string;
    self.ageTextField.delegate = self;
    
    NSInteger year = [TKUtility getCurrentYear];
    
    NSString *yob = [NSString stringWithFormat:@"%d",year - string.intValue];
    
    [self.yobBtn setTitle:yob forState:UIControlStateNormal];

}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if([self.delegate respondsToSelector:@selector(doubleTextFieldCelldidBeginEditing:)]){
        [self.delegate doubleTextFieldCelldidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if([self.delegate respondsToSelector:@selector(doubleTextFieldCell:didEndEditText:)]){
        [self.delegate doubleTextFieldCell:self didEndEditText:textField.text];
    }
}

-(void) setYobValue:(NSString *)yob {
    [self.yobBtn setTitle:yob forState:UIControlStateNormal];
}

@end
