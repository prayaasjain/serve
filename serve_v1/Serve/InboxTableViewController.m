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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"id"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:@"id"];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        if ([indexPath section] == 0) {
//            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
//            playerTextField.adjustsFontSizeToFitWidth = YES;
//            playerTextField.textColor = [UIColor blackColor];
//            if ([indexPath row] == 0) {
//                playerTextField.placeholder = @"example@gmail.com";
//                playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
//                playerTextField.returnKeyType = UIReturnKeyNext;
//            }
//            else {
//                playerTextField.placeholder = @"Required";
//                playerTextField.keyboardType = UIKeyboardTypeDefault;
//                playerTextField.returnKeyType = UIReturnKeyDone;
//                playerTextField.secureTextEntry = YES;
//            }
//            playerTextField.backgroundColor = [UIColor whiteColor];
//            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
//            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
//            playerTextField.textAlignment = UITextAlignmentLeft;
//            playerTextField.tag = 0;
//            //playerTextField.delegate = self;
//            
//            playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
//            [playerTextField setEnabled: YES];
//            
//            [cell.contentView addSubview:playerTextField];
//            
//        }
//    }
//    if ([indexPath section] == 0) { // Email & Password Section
//        if ([indexPath row] == 0) { // Email
//            cell.textLabel.text = @"Email";
//        }
//        else {
//            cell.textLabel.text = @"Password";
//        }
//    }
//    else { // Login button section
//        cell.textLabel.text = @"Log in";
//    }
//    return cell;    
//}


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
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Settings";
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(140, 70, 70, 70)];
    [profileImageView setImage:[UIImage imageNamed:@"food1.jpg"]];
    
    profileImageView.layer.cornerRadius = 35;
    //profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    profileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    profileImageView.layer.borderWidth = .5;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [profileImageView setClipsToBounds:YES];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor serveBackgroundColor];
    [headerView addSubview:profileImageView];
    
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
