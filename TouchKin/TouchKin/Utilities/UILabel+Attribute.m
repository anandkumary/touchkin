//
//  UILabel+Attribute.m
//  TouchKin
//
//  Created by Anand kumar on 7/20/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "UILabel+Attribute.h"


@implementation UILabel (Attribute)

-(void) setText:(NSString *)text highlightText:(NSString *)highLightText withColor:(UIColor *)color {
    
    NSRange range = [text rangeOfString:highLightText];
    
    NSMutableAttributedString *aText =
    [[NSMutableAttributedString alloc]
     initWithString:text];
    
    [aText addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:234/255.f green:105/255.f blue:39/255.f alpha:1]
                 range:range];
    [self setAttributedText: aText];
    
}





@end
