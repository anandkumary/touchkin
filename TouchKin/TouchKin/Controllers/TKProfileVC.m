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

@interface TKProfileVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

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
    
    self.tableview.estimatedRowHeight = 72;
    
    self.tableview.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row <= 1){
        TKSingleTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleTextFieldCell" forIndexPath:indexPath];
        
        cell.avatar.image = [UIImage imageNamed:@"avatar_android"];
        cell.textField.placeholder = @"Enter your name";
        
        if(indexPath.row == 0){
            cell.avatar.image = [UIImage imageNamed:@"call_profile"];
            cell.textField.placeholder = @"Enter your mobile";
 
        }
        
        return cell;
    }
    else if (indexPath.row == 2){
        
        TKGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genderCell" forIndexPath:indexPath];
        return cell;
    }
    else {
        TKDoubleTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doubleTextFieldCell" forIndexPath:indexPath];
        return cell;
    }
}
@end
