
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
#import "TKPassCodeView.h"
#import "TKProfileVC.h"

@interface TKRegisterVC ()<TKPassCodeViewDelegate>

@property (weak, nonatomic) IBOutlet TKNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet TKPassCodeView *passcodeview;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;

@end

@implementation TKRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.title = @"Verify OTP";
    self.passcodeview.delegate = self;
    
    [self.resendBtn setTitle:[[TKDataEngine sharedManager] getPhoneNumber] forState:UIControlStateNormal];
    
    [self.resendBtn addTarget:self action:@selector(resendBtnAction:) forControlEvents:UIControlStateNormal];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resendBtnAction:(UIButton *)sender {
    
    NSDictionary *dict = @{@"mobile":sender.titleLabel.text};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postRequestPath:@"signup" withParameter:dict withHandler:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) passcode:(TKPassCodeView *)view didTextEntered:(NSString *)text {
    
    TKDataEngine *engine = [TKDataEngine sharedManager];
    
    NSString *phone = [engine getPhoneNumber];
    NSString *deviceToken = [engine getDeviceToken];
    NSString *OtpCode = text;
    
    
   NSDictionary *dict = @{@"mobile": phone,@"code":[NSNumber numberWithInteger:OtpCode.integerValue] ,@"mobile_os": @"ios",@"mobile_device_id": deviceToken};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    [model postRequestPath:@"user/verify-mobile" withParameter:dict withHandler:^(id responseObject, NSError *error) {
        
        [engine saveUserInfo:responseObject];

        [engine setPhoneNumber:responseObject[@"mobile"]];
        [engine setSessionId:responseObject[@"id"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];

        
        if(responseObject[@"first_name"]){
            
            // [engine getMyFamilyInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                TKProfileVC *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"TKProfileVC"];
                
                profile.profileType = LOGINPROFILE;
                
                [self.navigationController pushViewController:profile animated:YES];
            });
    }
        


       
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
