//
//  TKAddNicknameVC.m
//  TouchKin
//
//  Created by Shankar K on 27/08/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKAddNicknameVC.h"
#import "MLNetworkModel.h"
#import "TKDataEngine.h"

@interface TKAddNicknameVC()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstraint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *addNickName;
@property (nonatomic, assign) CGFloat spaceConstriant;

@end

@implementation TKAddNicknameVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self addinfo];
    self.spaceConstriant = self.topconstraint.constant;
    self.addNickName.delegate = self;
   // [self.addNickName addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    self.avatarPic.layer.cornerRadius = self.avatarPic.frame.size.width/2;
    self.avatarPic.layer.borderColor = [UIColor orangeColor].CGColor;
    self.avatarPic.layer.borderWidth = 2.0;
    self.avatarPic.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) addinfo
{
    self.avatarPic.image = _avatarImage;
    self.userName.text = _name;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if(height == 480.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topconstraint.constant = +150;
            [self.view layoutIfNeeded];
        }];
        
    }else if (height == 568.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topconstraint.constant = +50;
            [self.view layoutIfNeeded];
        }];
    }
    else if (height >= 667.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topconstraint.constant = +25;
            [self.view layoutIfNeeded];
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        self.topconstraint.constant = self.spaceConstriant;
        [self.view layoutIfNeeded];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.addNickName resignFirstResponder];
    return YES;
}

- (IBAction)addnickNameActions:(id)sender {
    
    if (![_addNickName.text isEqualToString:@""]) {
        NSString *str = [NSString stringWithFormat:@"%@",_dict[@"requestId"]];
        [_dict setValue:_addNickName.text forKey:@"nickname"];
    MLNetworkModel *model = [[MLNetworkModel alloc] init];

    [model postRequestPath:[NSString stringWithFormat:@"user/connection-request/%@/accept",str] withParameter:_dict withHandler:^(id responseObject, NSError *error) {
        NSLog(@"response = %@",responseObject);
                if(error ==  nil) {
                    
                    [[TKDataEngine sharedManager] getMyFamilyInfo];
                    
                    [self.view removeFromSuperview];
                    [self removeFromParentViewController];

                    }
                    else {
                    }
            }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Data Missing" message:@"Please Enter Nick name for accepting Person otherwise request will not be accepted" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
