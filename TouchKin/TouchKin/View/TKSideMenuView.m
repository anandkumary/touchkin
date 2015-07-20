//
//  TKSideMenuView.m
//  TouchKin
//
//  Created by Anand kumar on 7/16/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKSideMenuView.h"
#import "TKMenuCell.h"

@interface TKSideMenuView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *menuList;
@end

@implementation TKSideMenuView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
        self.menuList = [NSArray arrayWithObjects:@"Dashboard",@"My Family",@"My Account",@"Devices",@"Terms of Use",@"Help & Support",@"Logout", nil];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setMenuTable:(UITableView *)menuTable {
    _menuTable = menuTable;
    _menuTable.dataSource = self;
    _menuTable.delegate = self;
    //  _menuTable.canCancelContentTouches = NO;

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return self.menuList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TKMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKMenuCell"];
    cell.menuLabel.text = self.menuList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(sideMenu:didSlecetAtIndex:)]){
        [self.delegate sideMenu:self didSlecetAtIndex:indexPath.row];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.delegate respondsToSelector:@selector(sideMenu:didSlecetAtIndex:)]){
        [self.delegate sideMenu:self didSlecetAtIndex:-1];
    }
}

@end
