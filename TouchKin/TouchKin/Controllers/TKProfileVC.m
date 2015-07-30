//
//  TKProfileVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/28/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKProfileVC.h"
#import "MLNetworkModel.h"

@interface TKProfileVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

@implementation TKProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //@{@"first_name": UserName.text,@"gender":gender,@"yob": yearTextfield};
    
//    MLNetworkModel *model = [[MLNetworkModel alloc] init];
//    
//    [model postPath:@"user/complete-profile" withParameter:nil withHandler:^(MLClient *sender, id responseObject, NSError *error) {
//        
//    }];
    
    
    self.tableview.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // CGRect frame =
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
