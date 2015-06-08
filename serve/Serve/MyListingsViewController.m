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
#import "ServeCoreDataController.h"
#import "SelfListing.h"
#import "SelfListingCell.h"

const CGFloat iconWidth = 25.0f;
const CGFloat iconHeight = 25.0f;

static NSString * const addListingCellIdentifier = @"addListingCell";
static NSString * const selfListingCellIdentifier = @"selfListingCell";

@interface MyListingsViewController ()
@property (nonatomic ,strong) UITableView* homeTable;
- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)addNewListingButtonPressed:(id)sender;

@property (strong, nonatomic) NewInputViewController *inputViewController;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *listingItem;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *dates;




@end

@implementation MyListingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavigationController];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
 
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 500, 640)
                                                  style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    self.homeTable.tableFooterView = [UIView new];
    //[self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:@"addListingCell"];
    
    [self.homeTable registerClass:[SelfListingCell class] forCellReuseIdentifier:@"selfListingCell"];
    self.homeTable.tableFooterView = [UIView new];
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadRecordsFromCoreData];

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
    UIImage *myListImage = [UIImage imageNamed:@"trash.png"];
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
    //return
    return [self.dates count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///
    // Similar to UITableViewCell, but
//    AddListingCell *cell = (AddListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[AddListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = @"Add New Listing";
//    cell.detailTextLabel.text = @"Akhil2";

    //cell.accessoryView = ;
    
    // Just want to test, so I hardcode the data
    //cell.descriptionLabel.text = @"Testing";
    
    /////
    

    ///
        SelfListingCell *cell1 = (SelfListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];
        if (cell1 == nil) {
            cell1 = [[SelfListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = @"BURGER WITH FRIES";
        cell1.serveCount = [NSNumber numberWithInt:5];
        cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];

    ///
    
    ///
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    SelfListing *item  = [self.dates objectAtIndex:indexPath.row];
//    
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addListingCellIdentifier];
//    }
//    
//    //Friend *friend = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = item.name;
//    cell.textLabel.font = [cell.textLabel.font fontWithSize:10];
//    cell.imageView.image = [UIImage imageNamed:@"food1.jpg"];
//    
//    cell.detailTextLabel.text = @"Raju";
//    cell.detailTextLabel.font = [cell.textLabel.font fontWithSize:10];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell1;

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
        NewInputViewController *secondView = [[NewInputViewController alloc] init];
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

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SelfListing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
//        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", 1]];
        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
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
