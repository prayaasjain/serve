//
//  FilterTableViewController.m
//  Serve
//
//  Created by Akhil Khemani on 7/2/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "InboxTableViewController.h"
#import "UIColor+Utils.h"

@interface InboxTableViewController ()

@property (nonatomic, strong) NSArray *cellTitles;
- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setUpNavigationController];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setFrame:CGRectMake(0, 0, 150, 400)];
    self.cellTitles = @[@"Settings",@"Invite Friends",@"Help"];
    
}

-(void)setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    //self.navigationController.toolbarHidden = NO;
    [self.navigationItem setTitle:@"Inbox"];
    
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 25.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor serveBackgroundColor];
    
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Settings";
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    //CGRectMake(140, 70, 70, 70)
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [profileImageView setImage:[UIImage imageNamed:@"food1.jpg"]];
    profileImageView.layer.cornerRadius = 35;
    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    profileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    profileImageView.layer.borderWidth = .5;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [profileImageView setClipsToBounds:YES];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor serveBackgroundColor];
    [headerView addSubview:profileImageView];
    
    NSLayoutConstraint *profileImageCenterYConstraint = [NSLayoutConstraint
                                                    constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterY
                                                    relatedBy:NSLayoutRelationEqual toItem:headerView
                                                    attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    NSLayoutConstraint *profileImageCenterXConstraint  = [NSLayoutConstraint
                                                      constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:headerView
                                                          attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];
    
    NSLayoutConstraint *profileImageWidthConstraint  = [NSLayoutConstraint
                                                          constraintWithItem:profileImageView attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual toItem:nil
                                                          attribute:NSLayoutAttributeWidth multiplier:1 constant:70];
    NSLayoutConstraint *profileImageHeightConstraint  = [NSLayoutConstraint
                                                        constraintWithItem:profileImageView attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:profileImageView
                                                        attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    
    [headerView addConstraints:@[profileImageCenterXConstraint,profileImageCenterYConstraint,profileImageWidthConstraint,profileImageHeightConstraint]];
    
    return headerView;
}

- (IBAction)resetButtonPressed:(id)sender {

}

- (IBAction)cancelButtonPressed:(id)sender {

    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
