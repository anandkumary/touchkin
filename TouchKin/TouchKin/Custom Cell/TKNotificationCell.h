//
//  TKNotificationCell.h
//  TouchKin
//
//  Created by Anand Kumar on 8/24/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *datelbl;

@property (weak, nonatomic) IBOutlet UILabel *notificationTxt;

@end
