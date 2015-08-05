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

@end
