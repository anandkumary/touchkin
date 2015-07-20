//
//  TKPageController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKPageController.h"
#import "TKCircularView.h"
#import "TKDashboardView.h"
#import "UILabel+Attribute.h"

@interface TKPageController ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIView *bgImage;
@property (weak, nonatomic) IBOutlet TKCircularView *circularView;
@property (weak, nonatomic) IBOutlet TKDashboardView *dashboardView;

@end

@implementation TKPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgImage.layer.cornerRadius = self.bgImage.frame.size.width/2;
    
    self.dashboardView.layer.cornerRadius = self.dashboardView.frame.size.width/2;
    
    self.dashboardView.type = self.boardType;
    
    // self.topLabel.text = @"Its 7:30 am for Eric in New York";
    
    [self.topLabel setText:@"Its 7:30 am for Eric in New York" highlightText:@"7:30 am" withColor:nil];
    
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

@end
