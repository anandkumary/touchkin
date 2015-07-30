//
//  TKMyFamilyRequestCell.m
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMyFamilyRequestCell.h"

@implementation TKMyFamilyRequestCell
- (IBAction)cancelButtonAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(requestDidCancelCell:)]){
        [self.delegate requestDidCancelCell:self];
    }
}
- (IBAction)acceptButtonAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(requestDidAcceptCell:)]){
        [self.delegate requestDidAcceptCell:self];
    }
}

@end
