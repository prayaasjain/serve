//
//  MyListingsViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "MyListingsViewController.h"
#import "NewInputViewController.h"
#import "InputViewController.h"
#import "AddListingCell.h"


const CGFloat iconWidth = 25.0f;
const CGFloat iconHeight = 25.0f;

@interface MyListingsViewController ()
@property (nonatomic ,strong) UITableView* homeTable;
- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)addNewListingButtonPressed:(id)sender;

@property (strong, nonatomic) NewInputViewController *inputViewController;


@end

@implementation MyListingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavigationController];
 
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 500, 640)
                                                  style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    self.homeTable.tableFooterView = [UIView new];
    [self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:@"addListingCell"];
    self.homeTable.tableFooterView = [UIView new];
    
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void) setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    
    //add button
    UIImage *addImage = [UIImage imageNamed:@"add.png"];
    UIButton *addButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNewListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    /////
    
    //userButton
    UIImage *userImage = [UIImage imageNamed:@"user.png"];
    UIButton *userButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setImage:userImage forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [userButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    /////
    
    //messageButton
    UIImage *messageImage = [UIImage imageNamed:@"message_icon.png"];
    UIButton *messageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:messageImage forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [messageButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *messageBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    /////
    
    //myListButton
    UIImage *myListImage = [UIImage imageNamed:@"add_list.png"];
    UIButton *myListButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [myListButton setImage:myListImage forState:UIControlStateNormal];
    [myListButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myListButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *myListBarButton = [[UIBarButtonItem alloc] initWithCustomView:myListButton];
    /////
    

    NSArray *items = [NSArray arrayWithObjects:myListBarButton,itemSpace, addBarButton,itemSpace, messageBarButton,itemSpace, userBarButton, nil];
    self.toolbarItems = items;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (AddListingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addListingCell";
    
    ///
    // Similar to UITableViewCell, but
    AddListingCell *cell = (AddListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = @"Add New Listing";
//    cell.detailTextLabel.text = @"Akhil2";

    //cell.accessoryView = ;
    
    // Just want to test, so I hardcode the data
    //cell.descriptionLabel.text = @"Testing";
    
    /////
    
    

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    //Friend *friend = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = @"Akhil1";
//    cell.textLabel.font = [cell.textLabel.font fontWithSize:10];
//    cell.imageView.image = [UIImage imageNamed:@"add.png"];
//    
//    cell.detailTextLabel.text = @"Raju";
//    cell.detailTextLabel.font = [cell.textLabel.font fontWithSize:10];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (IBAction)continueButtonPressed:(id)sender {
    NSLog(@"Going to akhil view");
}

- (IBAction)addNewListingButtonPressed:(id)sender {
    
    if(self.inputViewController == nil){
        InputViewController *secondView = [[InputViewController alloc] init];
        self.inputViewController = secondView;
    }
    [self.navigationController pushViewController:self.inputViewController animated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
    NSLog(@"Going to list view");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.inputViewController == nil){
        NewInputViewController *secondView = [[NewInputViewController alloc] init];
        self.inputViewController = secondView;
    }
    self.inputViewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:self.inputViewController animated:YES];
    
}

//-(void) populateCell:(CategoryCell *) cell forIndexPath:(NSIndexPath *) indexPath {
    
//    id<CategoryUIObjectProtocol> category = [self.fetchedController objectAtIndexPath:indexPath];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = category.categoryName;
//    cell.accessoryView = ([category categoryitemSelected]) ? [self checkMarkView] : nil;
//    
//    int itemCount = category.countOfItemsAssociatedWithUICategory;
//    
//    if (itemCount > 1)
//    {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",itemCount, NSLocalizedString(@"items", @"") ];
//    }
//    else
//    {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",itemCount, NSLocalizedString(@"item", @"") ];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




////

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"detailsView" sender:self];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //I set the segue identifier in the interface builder
//    if ([segue.identifier isEqualToString:@"detailsView"]){
//        
//        NSLog(@"segue"); //check to see if method is called, it is NOT called upon cell touch
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        ///more code to prepare next view controller....
