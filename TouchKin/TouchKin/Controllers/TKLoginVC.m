//
//  TKLoginVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKLoginVC.h"
#import "TKNavigationView.h"
#import "Country.h"
#import "TKCountryVC.h"
#import "MLNetworkModel.h"
#import "TKDataEngine.h"

#define MAXLENGTH 10

@interface TKLoginVC ()<TKCountryDelegate>

@property (weak, nonatomic) IBOutlet TKNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *stdCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (strong, nonatomic) NSArray *countryList;


@end

@implementation TKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationView.title = @"Verify your phone number";
    
    [self.phoneNumberTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    Country *dataSource = [[Country alloc] init];
    self.countryList = [dataSource countries];

    NSArray *filtered = [self.countryList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code CONTAINS[cd] %@)", countryCode]];
    NSDictionary *dict = [filtered objectAtIndex:0];
    
    [self.stdCodeBtn setTitle:dict[@"dial_code"] forState:UIControlStateNormal];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.navigationView animateDown];

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

-(void)textFieldDidChange:(UITextField *)textField {
    
    if(textField.text.length >= 10){
      textField.text = [textField.text substringToIndex:MAXLENGTH];
        [self performLogin];
        [textField resignFirstResponder];
    }
}
- (IBAction)countryCodeButtonAction:(id)sender {
    
    TKCountryVC *countryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKCountryVC"];
    
    countryVC.delegate = self;
    
    [self presentViewController:countryVC animated:YES completion:nil];
}
- (IBAction)backButtonAction:(id)sender {
    
}
- (IBAction)forwardButtonAction:(id)sender {
    //[self.navigationView animateTop:^(BOOL onComplete) {
        [self performSegueWithIdentifier:@"register" sender:nil];
    // }];
    
}

-(void)selectedCountry:(NSString *)stdCode {
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.stdCodeBtn setTitle:stdCode forState:UIControlStateNormal];
    });

}

-(void) performLogin {
    
    NSString *phone = [NSString stringWithFormat:@"%@%@",self.stdCodeBtn.titleLabel.text,self.phoneNumberTextField.text];
    
   phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *deviceOS = @"ios";
    NSString *deviceToken = [[TKDataEngine sharedManager] getDeviceToken];
    
    NSDictionary *dict = @{@"mobile": phone,@"mobile_os": deviceOS,@"mobile_device_id": deviceToken};
    
    MLNetworkModel *model = [[MLNetworkModel alloc] init];
    
    [model postRequestPath:@"user/signup" withParameter:dict withHandler:^(id responseObject, NSError *error) {
        
        NSLog(@"res %@",responseObject);
        if(![responseObject objectForKey:@"message"]){
            
            TKDataEngine *engine =  [TKDataEngine sharedManager];
            
            [engine saveUserInfo:responseObject];
            [engine setPhoneNumber:responseObject[@"mobile"]];
            [engine setSessionId:responseObject[@"id"]];
            
            [engine getMyFamilyInfo];
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if(responseObject[@"mobile_verified"]){
                    [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 else{
                     [self  forwardButtonAction:nil];
                 }
                
             });
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                TKDataEngine *engine =  [TKDataEngine sharedManager];
                [engine setPhoneNumber:phone];
                [self  forwardButtonAction:nil];
                
            });
            
           
        }
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
