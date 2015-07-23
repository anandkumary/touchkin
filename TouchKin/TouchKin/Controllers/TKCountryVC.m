//
//  TKCountryVC.m
//  TouchKin
//
//  Created by Anand kumar on 7/21/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKCountryVC.h"
#import "Country.h"

@interface TKCountryVC ()<UISearchBarDelegate>

@property (strong, nonatomic) NSArray *dataRows;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSArray *alphaIndex;

@property (nonatomic, strong) NSArray *filteredArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TKCountryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedRow = -1;
    
    self.alphaIndex = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    self.navTitle = @"Country Code";
    self.type = NAVIGATIONTYPENORMAL;
    
    Country *dataSource = [[Country alloc] init];
    _dataRows = [dataSource countries];
    
    self.filteredArray = self.dataRows;
    
    [self addLeftSideTitle:@"Cancel" forTarget:self];
    [self addRightSideTitle:@"Done" forTarget:self];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCode" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:kCountryName];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode];
    
    if (self.selectedRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.selectedRow != -1){
       
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    self.selectedRow = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

}



-(void)navleftBarAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightBarAction:(UIButton *)sender {
    
    if (self.selectedRow != -1) {
      
        if([self.delegate respondsToSelector:@selector(selectedCountry:)]){
            
            NSDictionary *dict = [self.dataRows objectAtIndex:self.selectedRow];
            [self.delegate selectedCountry:dict[@"dial_code"]];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    
//    return self.alphaIndex;
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    
//    return index;
//}

#pragma mark - UISearchBarDelegate 

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
   self.filteredArray = [self.dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@)", searchText]];
    
    self.selectedRow = -1;
    
    [self.tableview reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if(!searchBar.text.length){
        self.filteredArray = self.dataRows;
        
        [self.tableview reloadData];
    }
    
    [searchBar resignFirstResponder];
    
}

@end
