//
//  TKKinBookVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKKinBookVC.h"
#import "TKKinBookCollectionCell.h"
#import "MLNetworkModel.h"
#import "TKDataEngine.h"
#import "kinBook.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>


@interface TKKinBookVC ()<TKKinBookCollectionCellDelegate>

@property (nonatomic, strong) NSMutableArray *kinbookList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TKKinBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = NAVIGATIONTYPENORMAL;
    self.navTitle = @"KinBook";

    [self hideRightBarButton];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSString *userId = nil;
   // userId = [[TKDataEngine sharedManager] currentUserId];
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model getRequestPath:@"/kinbook/messages" withParameter:nil withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"res = %@", responseObject);
        self.kinbookList = nil;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseDictionary:responseObject];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) parseDictionary:(NSArray *)kinList {
    
    for (NSDictionary *dict in kinList) {
        
        if(!self.kinbookList){
            self.kinbookList = [[NSMutableArray alloc] init];
        }
        
        kinBook *kin = [[kinBook alloc] initWithDict:dict];
        
        [self.kinbookList addObject:kin];
    }
    
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  self.kinbookList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKKinBookCollectionCell *cell = (TKKinBookCollectionCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"kinBookCell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 15.0;
    cell.clipsToBounds = YES;
    cell.delegate = self;
    
    kinBook *kin = [self.kinbookList objectAtIndex:indexPath.section];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kin.thumbnail];
    
    cell.thumbnail.image = nil;
    cell.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    
     if(!image)
        {
        [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:kin.thumbnail] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.thumbnail.image = image;

        }];
        
    }
    else {
        cell.thumbnail.image = image;
    }
    return cell;
}

-(void) didPlayButtonSelected:(TKKinBookCollectionCell *)cell {
    
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    kinBook *kin = [self.kinbookList objectAtIndex:path.section];
    
    NSURL *movieURL = [NSURL URLWithString:kin.iPhoneMedia];
  MPMoviePlayerViewController * movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [movieController.moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
    
    [self presentMoviePlayerViewControllerAnimated:movieController];
   
    [movieController.moviePlayer play];
}

-(void) kinBookDidSelectDelete:(TKKinBookCollectionCell *)cell {
    
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    kinBook *kin = [self.kinbookList objectAtIndex:path.section];

    NSDictionary *dict = @{@"message_id" : kin.kinId};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postRequestPath:@"kinbook/message/delete" withParameter:dict withHandler:^(id responseObject, NSError *error) {
        
        if(error == nil){
            [self.kinbookList removeObject:kin];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
}

-(void) kinBookDidSelectSendTouch:(TKKinBookCollectionCell *)cell {
    
}

@end
