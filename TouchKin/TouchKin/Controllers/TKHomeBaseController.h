//
//  TKHomeBaseController.h
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface TKHomeBaseController : UIViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) NavigationType type;

-(void) setDelegate:(id)object;

-(void) reloadGroupData;
-(void) reloadOthersData;
-(id) fetchObjectForIndex:(NSInteger)index;

-(void) hideRightBarButton;
-(NSString *) getLeftNavTitle;

-(void) addLeftSideImage:(UIImage *)image forTarget:(id)target;
-(void) addLeftSideTitle:(NSString *)title forTarget:(id)target;
-(void) addRightSideImage:(UIImage *)image forTarget:(id)target;
-(void) addRightSideTitle:(NSString *)title forTarget:(id)target;
@end
