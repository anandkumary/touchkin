//
//  TKContactVC.h
//  TouchKin
//
//  Created by Anand kumar on 7/31/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseController.h"

@class TKContactVC;

@protocol TKContactVCDelegate <NSObject>

@optional
-(void)Contact:(TKContactVC *)controller withName:(NSString *)name andMobileNumber:(NSString *)mobile;

@end

@interface TKContactVC : TKHomeBaseController
@property (nonatomic, assign)id<TKContactVCDelegate> delegate;
@end
