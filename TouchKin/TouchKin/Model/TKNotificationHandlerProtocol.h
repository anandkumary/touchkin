//
//  TKNotificationHandlerProtocol.h
//  TouchKin
//
//  Created by Anand Kumar on 9/3/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKNotificationHandlerProtocol <NSObject>

-(void) didNotificationSelectedForUserId:(id)userId;
@end
