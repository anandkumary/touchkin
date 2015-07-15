//
//  TKLoginVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/15/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKLoginVC.h"
#import "TKNavigationView.h"

#define MAXLENGTH 10

@interface TKLoginVC ()
@property (weak, nonatomic) IBOutlet TKNavigationView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *stdCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation TKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationView.title = @"Verify your phone number";
    
    [self.phoneNumberTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
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
        [textField resignFirstResponder];
    }
}
- (IBAction)countryCodeButtonAction:(id)sender {
}
- (IBAction)backButtonAction:(id)sender {
    
}
- (IBAction)forwardButtonAction:(id)sender {
    [self.navigationView animateTop:^(BOOL onComplete) {
        [self performSegueWithIdentifier:@"register" sender:nil];
    }];
    
}

@end
