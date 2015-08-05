//
//  TKAddNewVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/29/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKAddNewVC.h"
#import "TKNetworkManager.h"

@interface TKAddNewVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userNametxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumbertxt;

@property (nonatomic, assign) CGFloat spaceConstriant;

@end

@implementation TKAddNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spaceConstriant = self.topConstraint.constant;
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
- (IBAction)addContactbutton:(id)sender {
    
}
- (IBAction)AddButtonAction:(id)sender {
    
    [TKNetworkManager sendRequestForUser:self.userNametxt.text withMobileNumber:self.mobileNumbertxt.text];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.topConstraint.constant = self.spaceConstriant;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.topConstraint.constant = -80;
        
        [self.view layoutIfNeeded];
    }];
    
}


@end
