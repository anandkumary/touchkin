//
//  TKNotificationViewController.m
//  TouchKin
//
//  Created by Anand Kumar on 8/22/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKNotificationViewController.h"
#import "UIImageView+WebCache.h"
#import "Notification.h"
#import "TKNotificationCell.h"
#import "TKDataManager.h"

@interface TKNotificationViewController ()
@property (nonatomic,strong)NSArray *notificationList;
@end

@implementation TKNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = @"Notification";
    self.type = NAVIGATIONTYPENORMAL;
    
    [self addLeftSideTitle:@"Cancel" forTarget:self];
    [self hideRightBarButton];
    

    self.notificationList = [[TKDataManager sharedInstance] getAllNotification];
    
    [self.notificationList setValue:@(YES) forKey:@"isRead"];
    
    [[TKDataManager sharedInstance] saveAllWithContext:[[TKDataManager sharedInstance]mainContext] withCallback:^(BOOL success, id responseObject) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navleftBarAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.notificationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKNotificationCell *cell = (TKNotificationCell*)[tableView dequeueReusableCellWithIdentifier:@"TKNotificationCell" forIndexPath:indexPath];
    
    Notification *note = [self.notificationList objectAtIndex:indexPath.row];
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",note.userId]];
    
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2;
    
    [cell.avatar sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        cell.avatar.image = image;
    }];
    
    cell.notificationTxt.text = note.notificationMessage;
    cell.datelbl.text = @"Today";
    //cell.datelbl.text = note.receivedDate;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notification *note = [self.notificationList objectAtIndex:indexPath.row];

    if([self.delegate respondsToSelector:@selector(didNotificationSelectedForUserId:)]){
        [self.delegate didNotificationSelectedForUserId:note.userId];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
