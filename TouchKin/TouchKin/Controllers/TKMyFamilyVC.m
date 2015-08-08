//
//  TKMyFamilyVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/18/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMyFamilyVC.h"
#import "TKMyFamilyRequestCell.h"
#import "TKMyFamilyCollectionCell.h"

#import "TKDataEngine.h"
#import "MyCircle.h"
#import "OthersCircle.h"
#import "MyConnection.h"
#import "UIImageView+WebCache.h"
#import "TKAddNewVC.h"
#import "MLNetworkModel.h"

#import "UIColor+Navigation.h"


@interface TKMyFamilyVC () <TKMyFamilyCollectionCellDelegate,TKMyFamilyRequestCellDelegate>{
    
    NSInteger selectedSection;
    
    NSInteger previousSelected;

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *familyList;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) NSMutableDictionary *PendingCount;
- (IBAction)CareForSomeoneAction:(id)sender;

@end

@implementation TKMyFamilyVC
@synthesize refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview.estimatedRowHeight = 90;
    
    selectedSection = -1;
    previousSelected= -1;
    
    self.tableview.backgroundColor = [UIColor whiteColor];
    
    self.type = NAVIGATIONTYPENORMAL;
    self.title = @"My Family";
    self.PendingCount = [[NSMutableDictionary alloc]init];
    self.familyList = [[NSMutableArray alloc] initWithArray: [[TKDataEngine sharedManager] familyList]];
    
    [self hideRightBarButton];
    //NSLog(@"family = %@",[[TKDataEngine sharedManager] familyList]);
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableview addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) refreshTable{
    
    self.familyList = [[NSMutableArray alloc] initWithArray: [[TKDataEngine sharedManager] familyList]];

    [self performSelector:@selector(endRefresh) withObject:self afterDelay:5.0];
    
}

-(void)endRefresh{
    [self.refreshControl endRefreshing];
    [self.tableview reloadData];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIView *)createHeaderViewForIndex:(NSInteger)index {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    [view setBackgroundColor:[UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0]];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [img setBackgroundColor:[UIColor clearColor]];
    img.layer.cornerRadius = img.frame.size.width/2;
    //img.layer.borderColor   = [UIColor colorWithRed:(207.0/255.0) green:(207.0/255.0) blue:(207.0/255.0) alpha:1.0].CGColor;
    //img.layer.borderWidth  = 2.0;
    [view addSubview:img];
    UILabel *lbl_image = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [lbl_image setBackgroundColor:[UIColor clearColor]];
    lbl_image.layer.cornerRadius = img.frame.size.width/2;
    //lbl_image.layer.borderColor   = [UIColor colorWithRed:(207.0/255.0) green:(207.0/255.0) blue:(207.0/255.0) alpha:1.0].CGColor;
    //lbl_image.layer.borderWidth  = 2.0;
    lbl_image.clipsToBounds = YES;

    img.clipsToBounds = YES;
    
    NSURL *url = nil;
   
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(88, 18, 180, 25)];
    [lbl setText:@"Anand Kumar"];
    [lbl setFont:[UIFont systemFontOfSize:20]];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;

    UILabel *subTitle_label = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 180, 40)];
    [subTitle_label setFont:[UIFont systemFontOfSize:14]];
    [subTitle_label setTextColor:[UIColor colorWithRed:(70.0/255.0) green:(69.0/255.0) blue:(69.0/255.0) alpha:0.8]];
    subTitle_label.lineBreakMode = NSLineBreakByWordWrapping;
    subTitle_label.numberOfLines = 2.0;
   
    MyCircle *circle = [self.familyList objectAtIndex:index];
    
    BOOL isPending = NO;
    
    if(![circle isKindOfClass:[MyCircle class]]){
        OthersCircle *others = [self.familyList objectAtIndex:index];
        [lbl setText:others.fname];
      //  [subTitle_label setText:[NSString stringWithFormat:@"Add Kin for %@ ",lbl.text]];
       
        if (others.connectionList.count > 0){
            
            [subTitle_label setText:[NSString stringWithFormat:@"%@ circle has %d kin",lbl.text,(int)others.connectionList.count]];
        }
        else if(others.connectionList.count == 0) {
            [subTitle_label setText:[NSString stringWithFormat:@"Invite someone to care for %@",lbl.text]];
        }

        [view addSubview:subTitle_label];

        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",others.userId]];
        
        isPending = others.isPending;
    }
    else{
        
        [lbl setText:circle.userName];
        
        if (circle.requestList.count > 0 & circle.myConnectionList.count > 0){
            
             [subTitle_label setText:[NSString stringWithFormat:@"Your circle has %d kin & %d request",(int)circle.myConnectionList.count,(int)circle.requestList.count]];
        }
        else if(circle.myConnectionList.count > 1){
          [subTitle_label setText:[NSString stringWithFormat:@"Your circle has %lu kin",(unsigned long)circle.myConnectionList.count]];
        }
        else {
            [subTitle_label setText: @"Invite someone to care for you."];
        }

        [view addSubview:subTitle_label];
        
         url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",circle.userId]];
    }

    [lbl setTextColor:[UIColor blackColor]];

    [view addSubview:lbl];
    
    __weak typeof(UIImageView *) weakSelf = img;
    __weak typeof(UILabel *) weakLabel = lbl_image;
    
    [img sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image ==nil) {
                weakLabel.hidden = NO;
                [weakLabel setText:[NSString stringWithFormat:@"%@",[lbl.text substringToIndex:1]]];
                [weakLabel setFont:[UIFont systemFontOfSize:33]];
                [weakLabel setTextColor:[UIColor whiteColor]];
                [weakLabel setBackgroundColor:[UIColor randomColor]];
                weakLabel.textAlignment = NSTextAlignmentCenter;

                [view addSubview:lbl_image];
                
            }else {
                lbl_image.hidden = YES;
                
                [weakSelf setImage:image];
            }
        });
        
    }];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 90/2 - 40/2, 40, 40)];
    [headerButton setBackgroundColor:[UIColor clearColor]];
    [headerButton setTag:index];
    [headerButton addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [headerButton setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];

    if(selectedSection == index && previousSelected != selectedSection){
        [headerButton setImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateNormal];
    }
    
    [headerButton setUserInteractionEnabled:YES];
    UIButton *headerButton1 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 15, 60, 60)];

    if(isPending){
        
        [headerButton1 setBackgroundColor:[UIColor clearColor]];
        [headerButton1 addTarget:self action:@selector(headerButtonPendingAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerButton1 setTag:index];
        if (![_PendingCount objectForKey:[NSString stringWithFormat:@"%ld",(long)index]]) {
            [_PendingCount setObject:lbl.text forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }else{
            [_PendingCount setObject:lbl.text forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }
        NSLog(@"Pending:%@",_PendingCount);
        [headerButton1 setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        [headerButton setHidden:YES];
        [view addSubview:headerButton1];
        [subTitle_label setText:[NSString stringWithFormat:@"Waiting for %@ to accept your request",lbl.text]];
        [view addSubview:subTitle_label];


    }
    
    [view addSubview:headerButton];

    return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createHeaderViewForIndex:section];
}

#pragma  mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.familyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalRows = 0;
    if(selectedSection == section && previousSelected != selectedSection){
        totalRows += 1;
        MyCircle *circle = [self.familyList objectAtIndex:section];
        if([circle isKindOfClass:[MyCircle class]])
            {
            totalRows = 1 + circle.requestList.count;
        }
    }
    
    return totalRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row != 0){
        
    TKMyFamilyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
        
        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2;
        cell.avatar.clipsToBounds = YES;
        
        cell.lbl_imageView_requestCell.layer.cornerRadius = cell.lbl_imageView_requestCell.frame.size.width/2;
        cell.lbl_imageView_requestCell.clipsToBounds = YES;
        
        MyCircle *circle = [self.familyList objectAtIndex:indexPath.section];
        
        MyConnection *connect = circle.requestList[indexPath.row - 1];
        
        cell.delegate = self;
        
        cell.userNameLbl.text = connect.nickName;
        [cell.lbl_imageView_requestCell setText:[cell.userNameLbl.text substringToIndex:1]];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",connect.userId]];
        
        [cell.avatar sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image ==nil) {
                
                cell.lbl_imageView_requestCell.hidden = NO;
                
            }else{
                cell.avatar.image = image;
                cell.lbl_imageView_requestCell.hidden = YES;
                
            }
        }];

        return cell;
    }
    else {
        
        TKMyFamilyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
        
        MyCircle *circle = [self.familyList objectAtIndex:indexPath.section];
        
        if([circle isKindOfClass:[MyCircle class]]){
            
            cell.familyType = MYFAMILYTYPE;
            cell.connectList = circle.myConnectionList;
            cell.delegate = self;
            cell.accessoryType = UITableViewCellAccessoryNone;

        }else {
            
            OthersCircle *others = [self.familyList objectAtIndex:indexPath.section];
            
            cell.familyType = OTHERSFAMILYTYPE;
            cell.connectList = others.connectionList;
            cell.delegate = self;
            
            cell.accessoryType = UITableViewCellAccessoryNone;

//            if (others.isPending) {
//                cell.accessoryType = UITableViewCellAccessoryDetailButton;
//            }
        }
        
        return cell;
    }
    
}

-(void) headerButtonAction:(UIButton *) sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);

    }];
    
    NSInteger delayOffset = 0;
    
    if(selectedSection != -1){
        
        delayOffset = 0.5;
        
        previousSelected = selectedSection;
        
        [self.tableview beginUpdates];
        
        MyCircle *circle = [self.familyList objectAtIndex:selectedSection];
        
        if([circle isKindOfClass:[MyCircle class]]){
            
            NSMutableArray *indexPathList = [self createNumberOfRow:circle.requestList.count forSection:selectedSection];
            [self.tableview deleteRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else {
           
             [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:previousSelected],nil] withRowAnimation:UITableViewRowAnimationFade];
        }

        
        [self.tableview endUpdates];
        
        selectedSection = -1;
        
    }
    else if(previousSelected != sender.tag)
        {
        
        selectedSection = sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayOffset * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self.tableview beginUpdates];
            MyCircle *circle = [self.familyList objectAtIndex:selectedSection];
        
            if([circle isKindOfClass:[MyCircle class]]){
                NSMutableArray *indexPathList = [self createNumberOfRow:circle.requestList.count forSection:selectedSection];
                [self.tableview insertRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationMiddle];
            }
            else {
                  [self.tableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:selectedSection],nil] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            
            [self.tableview endUpdates];
        });
    }
    else if (previousSelected == sender.tag){
        
        selectedSection = sender.tag;
        previousSelected = -1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayOffset * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
        [self.tableview beginUpdates];
            
            MyCircle *circle = [self.familyList objectAtIndex:selectedSection];
            
            if([circle isKindOfClass:[MyCircle class]]){
                NSMutableArray *indexPathList = [self createNumberOfRow:circle.requestList.count forSection:selectedSection];
                [self.tableview insertRowsAtIndexPaths:indexPathList withRowAnimation:UITableViewRowAnimationMiddle];
            }
            else {
                [self.tableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:selectedSection],nil] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableview endUpdates];
        });
    }
}

-(NSMutableArray *) createNumberOfRow:(NSInteger) count forSection:(int)section{
    
    NSMutableArray *array = nil;
    
    for (int i = 0; i <= count; i++) {
        if(!array){
            array = [[NSMutableArray alloc] init];
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        [array addObject:path];
    }
    
    return array;
}

-(void) didCellSelectAtIndex:(NSInteger)index {
    
    TKAddNewVC *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKAddNewVC"];
    
    [self addChildViewController:addVC];
    [self.view addSubview:addVC.view];
    [addVC didMoveToParentViewController:self];
    
}

-(void) requestDidCancelCell:(TKMyFamilyRequestCell *)cell {
    
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    MyCircle *circle = [self.familyList objectAtIndex:indexPath.section];
    
    MyConnection *connect = circle.requestList[indexPath.row - 1];
    
    NSDictionary *requestDict = @{@"requestId": connect.userId};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postRequestPath:[NSString stringWithFormat:@"user/connection-request/%@/reject",connect.requestId] withParameter:requestDict withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"response = %@",responseObject);
        
        if(error ==  nil) {
            
            NSDictionary *dict = responseObject;
            
            if(dict[@"status"]){
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [circle.requestList removeObject:connect];
                    
                    [self.tableview reloadData];
                    
                });
            }
        }
        
    }];
}

-(void) requestDidAcceptCell:(TKMyFamilyRequestCell *)cell {
    
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    MyCircle *circle = [self.familyList objectAtIndex:indexPath.section];
    
    MyConnection *connect = circle.requestList[indexPath.row - 1];
    
    NSDictionary *requestDict = @{@"requestId": connect.userId};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postRequestPath:[NSString stringWithFormat:@"user/connection-request/%@/accept",connect.requestId] withParameter:requestDict withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"response = %@",responseObject);
        
        if(error ==  nil) {
            
            NSArray *array = responseObject;
            
            NSDictionary *dict = [array objectAtIndex:0];
            
            if([dict[@"status"] isEqualToString:@"closed"] ){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [circle.requestList removeObject:connect];
                    
                    [self.tableview reloadData];
                    
                });
            }
            else {
                
                
            }
        }
        
    }];
    

}

- (IBAction)CareForSomeoneAction:(id)sender
{
    TKAddNewVC *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKAddNewVC"];
    
    [self addChildViewController:addVC];
    [self.view addSubview:addVC.view];
    [addVC didMoveToParentViewController:self];
}


-(void)headerButtonPendingAction:(UIButton *)sender
{

    UIButton *temp = sender;
    NSLog(@"%ld",(long)temp.tag);
    NSString *str=  [NSString stringWithFormat:@"A message has been sent to %@",[self.PendingCount objectForKey:[NSString stringWithFormat:@"%ld",(long)temp.tag]]];
    
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Request Pending" message:str delegate:self cancelButtonTitle:@"Withdraw request" otherButtonTitles:@"Resend Request", nil];
    [Alert show];
 
}

@end
