//
//  UIColor+Navigation.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "UIColor+Navigation.h"

@implementation UIColor (Navigation)

+(UIColor *) navigationColor {
 
    return [UIColor colorWithRed:(234.0/255.0) green:(105.0/255.0) blue:(39.0/255.0) alpha:1.0];
}

+(UIColor *) randomColor{
    
        int r = arc4random() % 255;
        int g = arc4random() % 255;
        int b = arc4random() % 255;
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

}


@end
