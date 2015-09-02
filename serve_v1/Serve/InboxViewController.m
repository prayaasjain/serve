//
//  InboxViewController.m
//  Serve
//
//  Created by Akhil Khemani on 8/25/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "InboxViewController.h"
#import "UIColor+Utils.h"

@interface InboxViewController ()

@property (nonatomic ,strong) UITableView* homeTable;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Messages"];
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTable.scrollEnabled = NO;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.backgroundColor = [UIColor blackColor];
    [self.loginButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateHighlighted];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    
    [self.loginButton setImage: [UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [self.loginButton setImage: [UIImage imageNamed:@"logout.png"] forState:UIControlStateDisabled];
    
    [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 28, 0, 0)];
    
    
    //self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loginButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cellTitles = @[@"Settings",@"Invite Friends",@"Help"];
    
    [self.view addSubview:self.homeTable];
    [self.view addSubview:self.loginButton];
    
    UITabBarController *dummyTabController = [[UITabBarController alloc] init];
    CGFloat tabBarHeight = dummyTabController.tabBar.frame.size.height;
    self.loginButton.frame = CGRectMake(0, self.view.frame.size.height-tabBarHeight, self.view.frame.size.width*2/3, tabBarHeight);
    dummyTabController = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *settings = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    [settings setText:[self.cellTitles objectAtIndex:indexPath.row]];
    [settings setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    settings.textColor = [UIColor servetextLabelGrayColor];
    
    [cell addSubview:settings];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"    You have no requests to respond to right now.";
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
//    //CGRectMake(140, 70, 70, 70)
//    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    [profileImageView setImage:[UIImage imageNamed:@"food1.jpg"]];
//    profileImageView.layer.cornerRadius = 35;
//    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    profileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//    profileImageView.layer.borderWidth = .5;
//    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [profileImageView setClipsToBounds:YES];
//    
//    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
//    headerView.backgroundColor = [UIColor serveBackgroundColor];
//    [headerView addSubview:profileImageView];
//    
//    NSLayoutConstraint *profileImageCenterYConstraint = [NSLayoutConstraint
//                                                         constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterY
//                                                         relatedBy:NSLayoutRelationEqual toItem:headerView
//                                                         attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint *profileImageCenterXConstraint  = [NSLayoutConstraint
//                                                          constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterX
//                                                          relatedBy:NSLayoutRelationEqual toItem:headerView
//                                                          attribute:NSLayoutAttributeCenterX multiplier:0.67 constant:0];
//    
//    NSLayoutConstraint *profileImageWidthConstraint  = [NSLayoutConstraint
//                                                        constraintWithItem:profileImageView attribute:NSLayoutAttributeWidth
//                                                        relatedBy:NSLayoutRelationEqual toItem:nil
//                                                        attribute:NSLayoutAttributeWidth multiplier:1 constant:70];
//    NSLayoutConstraint *profileImageHeightConstraint  = [NSLayoutConstraint
//                                                         constraintWithItem:profileImageView attribute:NSLayoutAttributeHeight
//                                                         relatedBy:NSLayoutRelationEqual toItem:profileImageView
//                                                         attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
//    
//    
//    [headerView addConstraints:@[profileImageCenterXConstraint,profileImageCenterYConstraint,profileImageWidthConstraint,profileImageHeightConstraint]];
    
    return nil;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
