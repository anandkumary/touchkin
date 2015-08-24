//
//  AppDelegate.h
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

typedef void (^MLAlertBlock)(NSInteger alertTag , NSError *error);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isConnectedToWifi;
@property (nonatomic, assign) BOOL isConnectedTo3G;

-(BOOL) isNetWorkConnected;

-(void) showAlertViewWithText:(NSString *)alertText alertType:(AlertType)type withHandler:(MLAlertBlock)block;

@end

