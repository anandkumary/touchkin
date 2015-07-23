//
//  TKCountryVC.h
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseController.h"

@protocol TKCountryDelegate <NSObject>

-(void)selectedCountry:(NSString *)stdCode;

@end

@interface TKCountryVC : TKHomeBaseController
@property (nonatomic, assign) id<TKCountryDelegate> delegate;
@end
