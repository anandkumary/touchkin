
//
//  TKRegisterVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKRegisterVC.h"
#import "TKNavigationView.h"
#import "TKDataEngine.h"
#import "MLNetworkModel.h"

@interface TKRegisterVC ()
@property (weak, nonatomic) IBOutlet TKNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;

@end

@implementation TKRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.title = @"Verify OTP";
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

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
- (IBAction)otpSendButtonAction:(id)sender {
    
    TKDataEngine *engine = [TKDataEngine sharedManager];
    
    NSString *phone = [engine getPhoneNumber];
    NSString *deviceToken = [engine getDeviceToken];
    NSString *OtpCode = self.otpTextField.text;
    
    
   NSDictionary *dict = @{@"mobile": phone,@"code":[NSNumber numberWithInteger:OtpCode.integerValue] ,@"mobile_os": @"ios",@"mobile_device_id": deviceToken};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    [model postRequestPath:@"user/verify-mobile" withParameter:dict withHandler:^(id responseObject, NSError *error) {
       
        NSLog(@"resss =%@",responseObject);
        
    }];
    
    
}
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
