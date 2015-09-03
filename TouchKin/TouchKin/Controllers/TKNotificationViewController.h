//
//  TKNotificationViewController.h
//  TouchKin
//
//  Created by Anand Kumar on 8/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseController.h"
#import "TKNotificationHandlerProtocol.h"
//IB_DESIGNABLE
@interface TKNotificationViewController : TKHomeBaseController
@property (nonatomic, assign) id<TKNotificationHandlerProtocol> delegate;
@end
