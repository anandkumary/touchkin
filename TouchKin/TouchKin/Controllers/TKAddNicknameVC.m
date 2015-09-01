//
//  TKAddNicknameVC.m
//  TouchKin
//
//  Created by Shankar K on 27/08/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKAddNicknameVC.h"
#import "MLNetworkModel.h"

@interface TKAddNicknameVC()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *avatarPics;
@property (weak, nonatomic) IBOutlet UILabel *userNames;
@property (weak, nonatomic) IBOutlet UITextField *addNickNames;
@property (nonatomic, assign) CGFloat spaceConstriant;

@end

@implementation TKAddNicknameVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self addinfo];
    self.spaceConstriant = self.topConstraints.constant;
    self.addNickNames.delegate = self;
   // [self.addNickName addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    self.avatarPics.layer.cornerRadius = self.avatarPics.frame.size.width/2;
    self.avatarPics.layer.borderColor = [UIColor orangeColor].CGColor;
    self.avatarPics.layer.borderWidth = 2.0;
    self.avatarPics.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) addinfo
{
    self.avatarPics.image = _avatarImage;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if(height == 480.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topConstraints.constant = +150;
            [self.view layoutIfNeeded];
        }];
        
    }else if (height == 568.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topConstraints.constant = +50;
            [self.view layoutIfNeeded];
        }];
    }
    else if (height >= 667.00){
        
        [UIView animateWithDuration:0.4 animations:^{
            self.topConstraints.constant = +25;
            [self.view layoutIfNeeded];
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        self.topConstraints.constant = self.spaceConstriant;
        [self.view layoutIfNeeded];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.addNickNames resignFirstResponder];
    return YES;
}

- (IBAction)addnickNameActions:(id)sender {
    
    if (![_addNickNames.text isEqualToString:@""]) {
        NSString *str = [NSString stringWithFormat:@"%@",_dict[@"requestId"]];
        [_dict setValue:_addNickNames.text forKey:@"nickname"];
    MLNetworkModel *model = [[MLNetworkModel alloc] init];

    [model postRequestPath:[NSString stringWithFormat:@"user/connection-request/%@/accept",str] withParameter:_dict withHandler:^(id responseObject, NSError *error) {
        NSLog(@"response = %@",responseObject);
                if(error ==  nil) {
                    }
                    else {
                    }
            }];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
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
