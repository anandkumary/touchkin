//
//  TKMessagePreviewVC.m
//  TouchKin
//
//  Created by Shankar K on 01/08/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMessagePreviewVC.h"
#import "TKDataEngine.h"
#import "TKNetworkManager.h"
#import <AVFoundation/AVFoundation.h>

@interface TKMessagePreviewVC ()
@property (nonatomic) NSMutableArray *familyList;
@property (strong, nonatomic) IBOutlet UIView *VideoplayView;
@property (strong,nonatomic) NSMutableArray *sharedWithArray;
@property (retain,nonatomic) AVPlayer *player;
@property (retain,nonatomic) AVPlayerLayer *avlayer;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation TKMessagePreviewVC
@synthesize sharedWithArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = NAVIGATIONTYPECAMERA;
    
    self.navTitle = @"Share Video";
    
    [self addVideoPlayer];

    [self reloadOthersData];
    
    [self.view bringSubviewToFront:self.sendBtn];
    
    [self addLeftSideTitle:@"Cancel" forTarget:self];
    
    [self hideRightBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) navleftBarAction :(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) addVideoPlayer {
    
    self.player = [AVPlayer playerWithURL:self.videoURL];
    
    self.avlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.avlayer.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    
    [self.VideoplayView.layer addSublayer:self.avlayer];
    
    [self.player play];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.player pause];
    
}

- (IBAction)send_touch:(id)sender {
    
    NSString *userId = [sharedWithArray componentsJoinedByString:@","];
        
    [TKNetworkManager uploadVideoFor:self.videoURL withUserID:userId];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) didSelectHeaderTitleAtIndex:(NSInteger)index {
    
        OthersCircle *circle = [self fetchObjectForIndex:index];
        
        if(!sharedWithArray){
            sharedWithArray = [[NSMutableArray alloc] init];
        }
        
        if ([sharedWithArray containsObject:circle.userId]) {
            [sharedWithArray removeObject:circle.userId];
        }else{
            [sharedWithArray addObject:circle.userId];
        }
}
    
@end
