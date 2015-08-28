//
//  TKHomeBaseController.m
//  TouchKin
//
//  Created by Anand kumar on 7/17/15.
//  Copyright (c) 2015 Anand kumar. All rights reserved.
//

#import "TKHomeBaseController.h"
#import "UIColor+Navigation.h"
#import "TKHomeBaseNavigationView.h"
#import "TKDataManager.h"
#import "TKBaseViewController.h"
#import "AppDelegate.h"
#import "TKDataEngine.h"
#import "TKAddNewVC.h"

@interface TKHomeBaseController ()<TKHomeBaseNavigationViewDelegate>
@property (nonatomic,strong)  TKHomeBaseNavigationView *navView;
@end

@implementation TKHomeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleDataModelChange:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object:nil];
    
    [self initailizeNavigation];
    
    NSInteger count = [[TKDataManager sharedInstance] getNotificationCount];

    if(count){
        [self.navView.rightButton setTitle:[NSString stringWithFormat:@" %d ",count] forState:UIControlStateNormal];
    }
    else{
        [self.navView.rightButton setTitle:@"" forState:UIControlStateNormal];
   
    }
    
    [self.navView.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navView.rightButton.titleLabel.layer.cornerRadius = 9.0;
   // self.navView.rightButton.titleLabel.backgroundColor = [UIColor redColor];
    self.navView.rightButton.titleLabel.layer.backgroundColor = [UIColor navigationColor].CGColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleDataModelChange:(NSNotification*)note {
    
    NSInteger count = [[TKDataManager sharedInstance] getNotificationCount];
    
    if(count){
       
        [self.navView.rightButton setTitle:[NSString stringWithFormat:@" %d ",count] forState:UIControlStateNormal];
    }
    else {
        
    }
}


-(void)initailizeNavigation {
    
    self.navView = [[[NSBundle mainBundle] loadNibNamed:@"TKHomeBaseNavigationView" owner:self options:nil] objectAtIndex:0];
    
    self.navView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,70);
    [self.navView updateConstraints];
    [self.navView setBackgroundColor:[UIColor clearColor]];
    [self.navView layoutIfNeeded];
    
    [self.view addSubview:self.navView];
    
    [self.navView.leftButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navView.delegate = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) setDelegate:(id)object {
    
    self.navView.delegate = object;
}

-(void) setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    [self.navView setTitle:navTitle];
}

-(void) setType:(NavigationType)type {
    _type = type;
    [self.navView setNavType:type];
    
    if(NAVIGATIONTYPENORMAL == type){
        self.navView.collectionView.hidden = YES;
    }
}

-(void) menuButtonAction:(UIButton *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    TKBaseViewController *baseVC = (TKBaseViewController *) delegate.window.rootViewController;
    
    [baseVC openMenu];
}

-(void) hideRightBarButton {
    
    self.navView.rightButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

-(void) addLeftSideImage:(UIImage *)image forTarget:(id)target {
   
    [self.navView.leftButton setImage:image forState:UIControlStateNormal];
    
    [self.navView.leftButton addTarget:target action:@selector(navleftBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) addRightSideImage:(UIImage *)image forTarget:(id)target {
    
    if(image){
        [self.navView.rightButton setImage:image forState:UIControlStateNormal];
    }
    
    [self.navView.rightButton addTarget:target action:@selector(navRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) addLeftSideTitle:(NSString *)title forTarget:(id)target {
    
    [self.navView.leftButton setTitle:title forState:UIControlStateNormal];
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    
    [self.navView.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.navView.leftButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    [self.navView.leftButton removeTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navView.leftButton addTarget:target action:@selector(navleftBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) addRightSideTitle:(NSString *)title forTarget:(id)target {
    
    
    [self.navView.rightButton setImage:nil forState:UIControlStateNormal];
    
    [self.navView.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.navView.rightButton.titleLabel.layer.cornerRadius = 0;
    
    self.navView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    //self.navView.rightButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    [self.navView.rightButton setTitle:title forState:UIControlStateNormal];
    [self.navView.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    self.navView.rightButton.titleLabel.backgroundColor = [UIColor whiteColor];
    
    
    [self.navView.rightButton addTarget:target action:@selector(navRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSString *) getLeftNavTitle{
    
   return  self.navView.leftButton.titleLabel.text;
}

-(void) reloadGroupData {
    
    self.navView.groupList = [[TKDataEngine sharedManager] familyList];
}

-(void) reloadOthersData {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[TKDataEngine sharedManager] familyList]];
    
    MyCircle * myCircle = (MyCircle *)[array objectAtIndex:0];
    
    NSMutableArray  *myConnection = [NSMutableArray arrayWithArray: myCircle.myConnectionList];
    
    for (id obj in array) {
        
        if(![obj isKindOfClass:[MyCircle class]]){
            
            OthersCircle *others =(OthersCircle *)obj;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId CONTAINS[cd] %@",others.userId];
            
            NSArray *filterResult = [myConnection filteredArrayUsingPredicate:predicate];

            if(!filterResult.count){
                [myConnection addObject:obj];
  
            }
        }
    }
    
    //[array removeObjectAtIndex:0];
    
     self.navView.groupList = myConnection;
    
    [self.view bringSubviewToFront:self.navView];

}

-(id) fetchObjectForIndex:(NSInteger)index {
    
    return self.navView.groupList[index];
}

-(void) homeBaseDidUserTappedOutside:(TKHomeBaseNavigationView *)view {
    
    CGRect frame = self.navView.frame;
    frame.size.height = 70;
    self.navView.frame = frame;
    
}

-(void) homeBaseDidOpen:(TKHomeBaseNavigationView *)view {
    
    CGRect frame = self.navView.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    self.navView.frame = frame;
}
-(void) homeBaseDidClose:(TKHomeBaseNavigationView *)view {
    
    CGRect frame = self.navView.frame;
    frame.size.height = 70;
    self.navView.frame = frame;
}

- (void) homeBaseDidTapCareForSomeone:(TKHomeBaseNavigationView *)view {
    
    TKAddNewVC *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TKAddNewVC"];
    
    [self addChildViewController:addVC];
    [self.view addSubview:addVC.view];
    [addVC didMoveToParentViewController:self];
}

-(void)navleftBarAction:(id)sender{
    
}

-(void)navRightBarAction:(id)sender {
    
}
@end
