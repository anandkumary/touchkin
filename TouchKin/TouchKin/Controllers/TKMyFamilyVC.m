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
#import "UIImageView+WebCache.h"

@interface TKMyFamilyVC () {
    NSInteger selectedSection;
    
    NSInteger previousSelected;

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *familyList;

@end

@implementation TKMyFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview.estimatedRowHeight = 90;
    
    selectedSection = -1;
    previousSelected= -1;
    
    self.tableview.backgroundColor = [UIColor whiteColor];
    
    self.type = NAVIGATIONTYPENORMAL;
    self.title = @"My Family";
    
    self.familyList = [[TKDataEngine sharedManager] familyList];
    
    NSLog(@"family = %@",[[TKDataEngine sharedManager] familyList]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [img setBackgroundColor:[UIColor redColor]];
    img.layer.cornerRadius = img.frame.size.width/2;
    img.layer.borderColor   = [UIColor colorWithRed:(207.0/255.0) green:(207.0/255.0) blue:(207.0/255.0) alpha:1.0].CGColor;
    img.layer.borderWidth  = 2.0;
    [view addSubview:img];
    
    img.clipsToBounds = YES;
    
    NSURL *url = nil;
    
   
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 90/2 - 20/2, 180, 20)];
    [lbl setText:@"Anand Kumar"];
    
    MyCircle *circle = [self.familyList objectAtIndex:index];
    
    if(![circle isKindOfClass:[MyCircle class]]){
        OthersCircle *others = [self.familyList objectAtIndex:index];
        [lbl setText:others.fname];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",others.userId]];
    }
    else{
       [lbl setText:circle.userName];
        
         url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",circle.userId]];
    }

    [lbl setTextColor:[UIColor colorWithRed:(70.0/255.0) green:(69.0/255.0) blue:(69.0/255.0) alpha:1.0]];
    
    [view addSubview:lbl];
    
    __weak typeof(UIImageView *) weakSelf = img;

    [img setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setImage:image];

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
        totalRows = 2;
    }
    
    return totalRows;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row%2){
        TKMyFamilyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
        return cell;
    }
    else {
        TKMyFamilyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
        
        MyCircle *circle = [self.familyList objectAtIndex:indexPath.section];
        
        if([circle isKindOfClass:[MyCircle class]]){
            
            cell.connectList = circle.myConnectionList;
        }else {
            
            OthersCircle *others = [self.familyList objectAtIndex:indexPath.section];
            
            cell.connectList = others.connectionList;
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
        
        [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:previousSelected],[NSIndexPath indexPathForRow:1 inSection:previousSelected],nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableview endUpdates];
        
        
        selectedSection = -1;
        
    }
    
    if(previousSelected != sender.tag){
        
        selectedSection = sender.tag;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayOffset * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self.tableview beginUpdates];
            
            [self.tableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:selectedSection],[NSIndexPath indexPathForRow:1 inSection:selectedSection],nil] withRowAnimation:UITableViewRowAnimationMiddle];
            
            [self.tableview endUpdates];
        });
       
    }
}

@end
