//
//  MyListingsViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PublicListingViewController.h"
#import "NewInputViewController.h"
#import "InputViewController.h"
#import "AddListingCell.h"
#import "ServeCoreDataController.h"
#import "Listing.h"
#import "SelfListingCell.h"
#import "GoogleMapApi.h"

//const CGFloat iconWidth = 25.0f;
//const CGFloat iconHeight = 25.0f;

static NSString * const addListingCellIdentifier = @"addListingCell";
static NSString * const selfListingCellIdentifier = @"selfListingCell";

@interface PublicListingViewController ()
@property (nonatomic ,strong) UITableView* homeTable;

@property (strong, nonatomic) NewInputViewController *inputViewController;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)switchButtonPressed:(id)sender;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *listingItem;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *serverItems;
@property (nonatomic, assign) BOOL listMode;;

@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UIView *mapView;

@end

@implementation PublicListingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNavigationController];
    
    
    self.listMode = YES;
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
 
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 500, 640)
                                                  style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    self.homeTable.tableFooterView = [UIView new];
    [self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:addListingCellIdentifier];
    [self.homeTable registerClass:[SelfListingCell class] forCellReuseIdentifier:selfListingCellIdentifier];
    self.homeTable.tableFooterView = [UIView new];
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    self.listView = self.view;
    self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.backgroundColor = [UIColor yellowColor];
    //[self loadRecordsFromCoreData];
    
    self.mapView = [GoogleMapApi displayMapwithAddress:@"1235,Wildwood Ave,Sunnyvale,CA" forFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [self loadRecordsFromCoreData];
    [self.homeTable reloadData];
    
}

- (void) setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    //[self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //self.navigationController.toolbarHidden = YES;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
   
    searchController.searchResultsUpdater = self.homeTable;
    //searchController.hidesNavigationBarDuringPresentation = NO;
    //searchController.dimsBackgroundDuringPresentation = NO;
    //definesPresentationContext = YES;
    //searchController.searchBar.scopeButtonTitles = @[@"Posts", @"Users", @"Subreddits"];
    //[self presentViewController:self.searchController animated:YES completion:nil];

    //myListButton
    UIImage *myListImage = [UIImage imageNamed:@"refresh.png"];
    UIButton *myListButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [myListButton setImage:myListImage forState:UIControlStateNormal];
    [myListButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myListButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *myListBarButton = [[UIBarButtonItem alloc] initWithCustomView:myListButton];
    /////
    
    //userButton
    UIImage *userImage = [UIImage imageNamed:@"person.png"];
    UIButton *userButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setImage:userImage forState:UIControlStateNormal];
    [userButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [userButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    /////
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 28);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = .5f;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Map" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flipBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 50, 28);
    button2.layer.borderColor = [UIColor whiteColor].CGColor;
    button2.layer.borderWidth = .5f;
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"Filter" forState:UIControlStateNormal];
    [button2.titleLabel setTextColor:[UIColor whiteColor]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button2 addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];

    self.navigationItem.titleView = searchController.searchBar;
    self.navigationItem.leftBarButtonItem = filterBarButton;
    self.navigationItem.rightBarButtonItem = flipBarButton;

    //add button
    UIImage *image = [UIImage imageNamed:@"plus.png"];
    UIButton *addButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:image forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNewListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(0, -40, iconWidth*3, iconHeight*3)];
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];

    /////
    
//    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
//                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                  target:nil
//                                  action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(backButtonPressed:)];
    [cancelButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    

    NSArray *items2 = [NSArray arrayWithObjects:cancelButton, nil];
    self.toolbarItems = items2;
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchButtonPressed:(id)sender {
    
    if (self.listMode == YES) {
        [UIView transitionFromView:self.listView toView:self.mapView
                          duration:0.7
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        self.listMode = NO; // a = !a;
    }
    else {
        [UIView transitionFromView:self.mapView toView:self.listView
                          duration:.7
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        self.listMode = YES; // a = !a;
    }
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.serverItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    SelfListingCell *cell1 = (SelfListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];

    if(self.serverItems.count)
    {
        Listing *item  = [self.serverItems objectAtIndex:indexPath.row];
        
        if (cell1 == nil) {
            cell1 = [[SelfListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = item.name;
        cell1.serveCount = item.serveCount;
        //cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];
        cell1.imageView.image = [UIImage imageWithData:item.image];
        cell1.typeString = @"Non-Veg";//item.type
    }
        return cell1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//        if(section==0)
//        {
//            return @"ITEM DETAILS";
//        }
    
//        if(section==1)
//        {
//            return @"YOUR LISTINGS";
//        }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
       return 10.0f;
    }
    else
    {
        return 0.0f;
    }
}

//- (IBAction)addNewListingButtonPressed:(id)sender {
//    
//    if(self.inputViewController == nil){
//        NewInputViewController *secondView = [[NewInputViewController alloc] init];
//        self.inputViewController = secondView;
//    }
//    [self.navigationController pushViewController:self.inputViewController animated:YES];
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if(indexPath.section == 0)
//    {
//        if(self.inputViewController == nil){
//            NewInputViewController *secondView = [[NewInputViewController alloc] init];
//            self.inputViewController = secondView;
//        }
//        self.inputViewController.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:self.inputViewController animated:YES];
//    }
//    
//}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        self.serverItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
