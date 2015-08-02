//
//  TKProfileVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/28/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKProfileVC.h"
#import "MLNetworkModel.h"
#import "TKSingleTextFieldCell.h"
#import "TKDoubleTextfieldCell.h"
#import "TKGenderCell.h"
#import "TKDataEngine.h"
#import "MyConnection.h"
#import "YLImagePickerController.h"
#import "TKNetworkManager.h"

@interface TKProfileVC ()<UIScrollViewDelegate,YLImagePickerDelegate,TKSingleTextFieldCellDelegate,TKGenderCellDelegate,TKDoubleTextfieldCellDelegate> {
    
    MyConnection *userInfo;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *overlayBg;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;

@end

@implementation TKProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //@{@"first_name": UserName.text,@"gender":gender,@"yob": yearTextfield};
    
//    MLNetworkModel *model = [[MLNetworkModel alloc] init];
//    
//    [model postPath:@"user/complete-profile" withParameter:nil withHandler:^(MLClient *sender, id responseObject, NSError *error) {
//        
//    }];
    
    userInfo = [[TKDataEngine sharedManager] userInfo];
    
    self.tableview.estimatedRowHeight = 72;
    
    self.tableview.contentInset = UIEdgeInsetsMake(100, 0, 180, 0);
    
    self.avatarBg.layer.cornerRadius = self.avatarBg.frame.size.width/2;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    
    self.avatar.backgroundColor = [UIColor redColor];
    
    self.avatar.clipsToBounds = YES;
    
    self.overlayBg.layer.cornerRadius = self.overlayBg.frame.size.width/2;
    
    self.savebtn.layer.cornerRadius = 6.0f;
    
    [self.savebtn addTarget:self action:@selector(savebuttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // NSLog(@"scroll = %f",scrollView.contentOffset.y);
    
    self.bgTopConstraint.constant = (-1 * (scrollView.contentOffset.y)) + 48;
    
    [self.view layoutIfNeeded];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row <= 1){
        TKSingleTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleTextFieldCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.avatar.image = [UIImage imageNamed:@"avatar_android"];
        cell.textField.placeholder = @"Enter your name";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        [cell setTextValue:userInfo.fname];
        cell.textField.enabled = YES;


        if(indexPath.row == 0){
            cell.avatar.image = [UIImage imageNamed:@"call_profile"];
            cell.textField.placeholder = @"Enter your mobile";
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            [cell setTextValue:userInfo.mobile];
            cell.textField.enabled = NO;
        }
        
        return cell;
    }
    else if (indexPath.row == 2){
        
        TKGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genderCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        
        cell.heBtn.selected = NO;
        cell.sheBtn.selected = NO;
        
        if([userInfo.gender isEqualToString:@"male"]){
            cell.heBtn.selected = YES;
            cell.sheBtn.selected = NO;
        }
        else if ([userInfo.gender isEqualToString:@"female"] ) {
         
            cell.heBtn.selected = NO;
            cell.sheBtn.selected = YES;
        }
        
        return cell;
    }
    else {
        
        TKDoubleTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doubleTextFieldCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell settextValue:@"23"];
        return cell;
    }
}

- (IBAction)editAvatarButtonAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        YLImagePickerController *imagePicker = [[YLImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UINavigationController *nav =  [[UINavigationController alloc] initWithRootViewController:imagePicker];
        
        [nav setNavigationBarHidden:YES];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    });
    
}

- (void)YLImagePickerControllerDidCancel:(YLImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)YLImagePickerController:(YLImagePickerController *)picker didFinishPickingImage:(UIImage *)image  {
    
    self.avatar.image = image;
    
    [self uploadImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)uploadImage {
    
 NSDictionary *dict = @{@"avatar": UIImagePNGRepresentation(self.avatar.image)};
    
    [TKNetworkManager uploadImage:dict];
}

-(void)savebuttonAction:(id)sender {
    
}

-(void) singleTextFieldCell:(TKSingleTextFieldCell *)cell didEndEditingWithString:(NSString *)string {
    
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    
    if(indexpath.row == 0){
        userInfo.mobile = string;
    }else {
        userInfo.fname = string;
    }

}

-(void) singleTextFieldCelldidBeginEditing:(TKSingleTextFieldCell *)cell {
    
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    
    [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) didSelectedGenderType:(BOOL) genderType {
    
    userInfo.gender = (genderType == YES) ? @"male" : @"female";
}

-(void) doubleTextFieldCelldidBeginEditing:(TKDoubleTextfieldCell *)cell {
    
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) doubleTextFieldCell:(TKDoubleTextfieldCell *)cell didEndEditText:(NSString *)string {
    
    userInfo.age = string;
}

@end
