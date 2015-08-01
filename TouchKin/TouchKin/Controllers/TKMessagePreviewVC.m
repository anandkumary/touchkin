//
//  TKMessagePreviewVC.m
//  TouchKin
//
//  Created by Shankar K on 01/08/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKMessagePreviewVC.h"
#import "TKDataEngine.h"
#import "TKMeViewController.h"
@interface TKMessagePreviewVC ()
@property (nonatomic) NSMutableArray *familyList;
@property (strong, nonatomic) IBOutlet UIView *VideoplayView;
@property (strong,nonatomic) NSMutableArray *sharedWithArray;
@end

@implementation TKMessagePreviewVC
@synthesize sharedWithArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadGroupData];

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
- (IBAction)send_touch:(id)sender {
    
    NSLog(@"Pressed");
    
}

-(void) didSelectHeaderTitleAtIndex:(NSInteger)index {
    
    self.familyList = [[TKDataEngine sharedManager] familyList];
    
    if(index > 0){
        
        OthersCircle *circle = [self.familyList objectAtIndex:index];
        
        if(!sharedWithArray){
            sharedWithArray = [[NSMutableArray alloc] init];
        }
        
        if ([sharedWithArray containsObject:circle.userId]) {
            [sharedWithArray removeObject:circle.userId];
        }else{
            [sharedWithArray addObject:circle.userId];
        }



    }
    

    
    
    
}
@end
