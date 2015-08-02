//
//  TKGenderCell.m
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKGenderCell.h"

@implementation TKGenderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)heButtonAction:(id)sender {
    
    self.heBtn.selected = YES;
    self.sheBtn.selected = NO;
    
    if([self.delegate respondsToSelector:@selector(didSelectedGenderType:)]){
        [self.delegate didSelectedGenderType:YES];
    }
}
- (IBAction)sheButtonAction:(id)sender {
    
    self.heBtn.selected = NO;
    self.sheBtn.selected = YES;
    
    if([self.delegate respondsToSelector:@selector(didSelectedGenderType:)]){
        [self.delegate didSelectedGenderType:NO];
    }
}

@end
