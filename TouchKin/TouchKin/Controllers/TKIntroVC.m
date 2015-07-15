//
//  TKIntroVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKIntroVC.h"

static NSString * const KLOGINSCREEN  = @"Login";

@interface TKIntroVC ()
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end

@implementation TKIntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.phoneBtn.layer.borderWidth = 1.0;
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
- (IBAction)PhoneButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:KLOGINSCREEN sender:nil];
}
- (IBAction)faceBookButtonAction:(id)sender {
}

@end
