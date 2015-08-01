//
//  TKCameraVC.m
//  TouchKin
//
//  Created by Anand kumar on 8/1/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKCameraVC.h"

@interface TKCameraVC ()
@property (weak, nonatomic) IBOutlet UIView *videoLayer;
@property (weak, nonatomic) IBOutlet UIButton *startbtn;
@property (weak, nonatomic) IBOutlet UIButton *togglebtn;

@end

@implementation TKCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)toggleButtonAction:(id)sender {
}
- (IBAction)startButtonAction:(id)sender {
}

@end
