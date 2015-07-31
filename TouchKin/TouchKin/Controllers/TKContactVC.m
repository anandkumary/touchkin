//
//  TKContactVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/31/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKContactVC.h"
#import "TKContactCell.h"
#import "PhoneContact.h"
#import "YMLPhoneContactPerson.h"

@interface TKContactVC ()<PhoneContactDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contactTable;

@property (nonatomic, strong) NSMutableArray *contactList;

@property (nonatomic, assign) NSInteger selectedrow;
@end

@implementation TKContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"Contacts";
    self.type = NAVIGATIONTYPENORMAL;
    
    [self addLeftSideTitle:@"Cancel" forTarget:self];
    [self addRightSideTitle:@"Done" forTarget:self];
    
    PhoneContact * contact = [[PhoneContact alloc]init];
    contact.delegate = self;
    [contact fetchContact];
    
    self.selectedrow = -1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navleftBarAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightBarAction:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) phoneContact:(PhoneContact *)phoneContact didFinishFetching:(NSMutableArray *)contacts {
    
    self.contactList = [NSMutableArray arrayWithArray:contacts];
    
    
    NSSortDescriptor *sortDescriptor =
    
    [NSSortDescriptor sortDescriptorWithKey:@"firstName"
                                  ascending:YES
                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    [_contactList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [self.contactTable reloadData];
    
   
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TKContactCell *cell  = (TKContactCell *)[tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    YMLPhoneContactPerson *person = [self.contactList objectAtIndex:indexPath.row];
    
    if (person.lastName.length){
        
        [cell.textLabel  setText:[NSString stringWithFormat:@"%@ %@",  person.firstName, person.lastName]];
    }
    else{
        [cell.textLabel  setText:person.firstName];
    }
    
    
    [cell.detailTextLabel setText:@"No Phone Number"];
    
    if(person.phoneNumbers.count){
        
        NSString *phoneNumber =[person.phoneNumbers objectAtIndex:0];
        
        if(phoneNumber.length){
            [cell.detailTextLabel setText:phoneNumber];
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    if(self.selectedrow == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.selectedrow != -1){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedrow inSection:0]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    self.selectedrow = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
