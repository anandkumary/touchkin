//
//  TKAddNewVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/29/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKAddNewVC.h"
#import "TKNetworkManager.h"
#import "Country.h"
#import "TKCountryVC.h"
#import "TKContactVC.h"

@interface TKAddNewVC ()<TKCountryDelegate,UITextFieldDelegate,TKContactVCDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userNametxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumbertxt;
@property (weak, nonatomic) IBOutlet UIButton *stdCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *enterName;
@property (nonatomic, assign) CGFloat spaceConstriant;
@property (strong, nonatomic) NSArray *countryList;
@property (nonatomic,copy) NSString *CRmobile;

@end

@implementation TKAddNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spaceConstriant = self.topConstraint.constant;
    self.CRmobile = [NSString stringWithFormat:@"%@",self.mobileNumber];

    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    Country *dataSource = [[Country alloc] init];
    self.countryList = [dataSource countries];
    
    NSArray *filtered = [self.countryList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code CONTAINS[cd] %@)", countryCode]];
    NSDictionary *dict = [filtered objectAtIndex:0];
    
    [self.stdCodeBtn setTitle:dict[@"dial_code"] forState:UIControlStateNormal];
    
  //  [self.userNametxt addTarget:self action:@selector(selector) forControlEvents:(UIControlEvents)]
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TKContactVC *contactVc = (TKContactVC *)[segue destinationViewController];
    
    contactVc.delegate = self;
}

-(void)Contact:(TKContactVC *)controller withName:(NSString *)name andMobileNumber:(NSString *)mobile {
    
    self.userNametxt.text = name;
    self.mobileNumbertxt.text = mobile;
}

- (IBAction)addContactbutton:(id)sender
{
    
}
- (IBAction)AddButtonAction:(id)sender
{
    if (![self.userNametxt.text isEqualToString:@""] && ![self.enterName.text isEqualToString:@""] && ![self.mobileNumbertxt.text isEqualToString:@""]) {
        if (self.careType == ADDCAREGIVERSFORME) {
            NSString *str = [NSString stringWithFormat:@"%@%@",self.stdCodeBtn.titleLabel.text,self.mobileNumbertxt.text];
            
                    [TKNetworkManager sendRequestForUser:self.userNametxt.text withMobileNumber:str];
            
                    [UIView animateWithDuration:0.4 animations:^{
                        self.topConstraint.constant = self.spaceConstriant;
                        [self.view layoutIfNeeded];
            
                    } completion:^(BOOL finished) {
            
                        [self.view removeFromSuperview];
                        [self removeFromParentViewController];
                    }];
        }else{
            NSString *str = [NSString stringWithFormat:@"%@%@",self.stdCodeBtn.titleLabel.text,self.mobileNumbertxt.text];
            NSLog(@"%@",self.CRmobile);
                    [TKNetworkManager sendRequestForCareReceiverUser:self.userNametxt.text withcareGivermobileno:str withMobileNumber:self.CRmobile];
            
                    [UIView animateWithDuration:0.4 animations:^{
                        self.topConstraint.constant = self.spaceConstriant;
                        [self.view layoutIfNeeded];
                        
                    } completion:^(BOOL finished) {
                        
                        [self.view removeFromSuperview];
                        [self removeFromParentViewController];
                    }];
        }

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Data Missing" message:@"Please Enter details in all Fields" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if(height == 480.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.topConstraint.constant = +150;
            [self.view layoutIfNeeded];
            
        }];
        
    }else if (height == 568.00){
        [UIView animateWithDuration:0.4 animations:^{
            
            self.topConstraint.constant = +90;
            [self.view layoutIfNeeded];
            
        }];
        
    }
    else if (height >= 667.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.topConstraint.constant = +50;
            [self.view layoutIfNeeded];
            
        }];

    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.topConstraint.constant = self.spaceConstriant;
        [self.view layoutIfNeeded];
        
    }];
}

-(IBAction)countryCodeButtonAction:(id)sender {
    
    TKCountryVC *countryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKCountryVC"];
    countryVC.delegate = self;
    [self presentViewController:countryVC animated:YES completion:nil];
    
}


-(void)selectedCountry:(NSString *)stdCode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stdCodeBtn setTitle:stdCode forState:UIControlStateNormal];
    });
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.userNametxt resignFirstResponder];
    [self.mobileNumbertxt resignFirstResponder];
    [self.enterName resignFirstResponder];
    return YES;
    
}


@end
