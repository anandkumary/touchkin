//
//  TKKinBookCollectionCell.m
//  TouchKin
//
//  Created by Anand kumar on 7/26/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKKinBookCollectionCell.h"

@implementation TKKinBookCollectionCell

- (IBAction)playButtonAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(didPlayButtonSelected:)]){
        [self.delegate didPlayButtonSelected:self];
    }
}
- (IBAction)sendTouchButtonAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(kinBookDidSelectSendTouch:)]){
        [self.delegate kinBookDidSelectSendTouch:self];
    }
}
- (IBAction)deleteButtonAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(kinBookDidSelectDelete:)]){
        [self.delegate kinBookDidSelectDelete:self];
    }
}

@end
