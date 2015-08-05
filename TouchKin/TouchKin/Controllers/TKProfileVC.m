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
#import "TKUtility.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface TKProfileVC ()<UIScrollViewDelegate,YLImagePickerDelegate,TKSingleTextFieldCellDelegate,TKGenderCellDelegate,TKDoubleTextfieldCellDelegate> {
    
    MyConnection *userInfo;
    MLNetworkModel *model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *avatarBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *overlayBg;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@end

@implementation TKProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"My Profile";
    self.type = NAVIGATIONTYPENORMAL;
    
    userInfo = [[TKDataEngine sharedManager] userInfo];
    
    if(!userInfo){
        userInfo = [[MyConnection alloc] init];
        
        userInfo.mobile = [[TKDataEngine sharedManager] getPhoneNumber];
        userInfo.userId = [[TKDataEngine sharedManager]getUserId];
        
    }
    
    NSString *urlString= [NSString stringWithFormat:@"https://s3-ap-southeast-1.amazonaws.com/touchkin-dev/avatars/%@.jpeg",userInfo.userId];
    
    NSURL * url = [NSURL URLWithString:urlString];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    
    if(!image){
     
        
        [self.avatar setImageWithURL:url placeholderImage:nil options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            self.avatar.image = image;
        }];

    }
    
    else {
        self.avatar.image = image;
  
    }

    
    self.tableview.estimatedRowHeight = 72;
    
    self.tableview.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    
    self.avatarBg.layer.cornerRadius = self.avatarBg.frame.size.width/2;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    
    self.avatar.backgroundColor = [UIColor redColor];
    
    self.avatar.clipsToBounds = YES;
    
    self.overlayBg.layer.cornerRadius = self.overlayBg.frame.size.width/2;
    
    self.savebtn.layer.cornerRadius = 6.0f;
    
    [self.savebtn addTarget:self action:@selector(savebuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(self.profileType == LOGINPROFILE){
        
        [self addLeftSideTitle:@"Skip" forTarget:self];
        // [self addRightSideTitle:@"Done" forTarget:self];
    }
    //  else
        {
        [self hideRightBarButton];
    }
    

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navleftBarAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) navRightBarAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [cell settextValue:userInfo.age];
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
    
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Saving..."];
    
    NSDictionary *dict = @{@"first_name": userInfo.fname,@"gender":userInfo.gender ,@"yob": @(userInfo.yob)};
    
    model = [[MLNetworkModel alloc] init];
    [model postPath:@"user/complete-profile" withParameter:dict withHandler:^(MLClient *sender, id responseObject, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[TKDataEngine sharedManager] setUserInfo:userInfo];

        });
        
        
        NSLog(@"res = %@",responseObject);
        
    }];

    
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
    
    [self scrollTableviewTopToIndex:indexpath];
}

-(void) genderCell:(TKGenderCell *)cell didSelectedGenderType:(BOOL)genderType {
    
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    [self scrollTableviewTopToIndex:indexpath];
    
    userInfo.gender = (genderType == YES) ? @"male" : @"female";
}

-(void) doubleTextFieldCelldidBeginEditing:(TKDoubleTextfieldCell *)cell {
    
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    [self scrollTableviewTopToIndex:indexpath];
}

-(void) doubleTextFieldCell:(TKDoubleTextfieldCell *)cell didEndEditText:(NSString *)string {
    
    userInfo.age = string;
    
    NSInteger year = [TKUtility getCurrentYear];
    
    userInfo.yob = (int)year - userInfo.age.intValue;
    
    [cell setYobValue:[NSString stringWithFormat:@"%d",(int)year - userInfo.age.intValue]];
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary* keyboardInfo = [aNotification userInfo];

    CGRect keyboardFrameEnd = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.tableBottomConstraint.constant = keyboardFrameEnd.size.height;
    [self.view layoutIfNeeded];

   
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

-(void) scrollTableviewTopToIndex:(NSIndexPath *)indexpath {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
}

@end
