//
//  MyListingsViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PublicListingViewController.h"
#import "ServeCoreDataController.h"
#import "Listing.h"
//#import "SelfListing.h"
#import "PublicListingCell.h"
#import "GoogleMapApi.h"
#import "ServeSyncEngine.h"
#import "FilterTableViewController.h"

static NSString * const publicListingCellIdentifier = @"publicListingCellIdentifier";

@interface PublicListingViewController ()
@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)switchButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) BOOL listMode;;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) UIBarButtonItem *flipViewBarButton;

//@property (strong, nonatomic) UISearchDisplayController *oldsearchController;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation PublicListingViewController

@synthesize serverItems;
@synthesize managedObjectContext;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    
    //NSLog(@"Came from viewdidload");
    [self loadRecordsFromCoreDataWithSearchString:nil];

    //setting up list view
    self.listMode = YES;
    self.listView = [[UIView alloc]initWithFrame:CGRectZero];
    self.listView.frame = self.view.bounds;
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    [self.homeTable registerClass:[PublicListingCell class] forCellReuseIdentifier:publicListingCellIdentifier];
    [self.listView addSubview:self.homeTable];
    [self.listView setBackgroundColor:[UIColor whiteColor]];
    
    //setting up mapview
    self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.backgroundColor = [UIColor yellowColor];
    self.mapView = [GoogleMapApi displayMapwithAddress:@"1235,Wildwood Ave,Sunnyvale,CA" forFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh:)
      forControlEvents:UIControlEventValueChanged];
    //[self.homeTable addSubview:refresh];
     self.view = self.listView;
    
    [self configureSearch];
    [self setUpNavigationController];
    
}

- (void)configureSearch {
    //new code//
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    //[self.searchController.searchBar sizeToFit];
    //self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation =NO;
    self.navigationItem.titleView = self.searchController.searchBar;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    [self loadRecordsFromCoreDataWithSearchString:searchString];
    [self.homeTable reloadData];
    
    if([searchString length] == 0) {
        [self loadRecordsFromCoreDataWithSearchString:nil];
        [self.homeTable reloadData];
    }

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationItem setLeftBarButtonItem: self.filterBarButton animated:YES];
    [self.navigationItem setRightBarButtonItem: self.flipViewBarButton animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.navigationItem setLeftBarButtonItem: nil animated:YES];
    [self.navigationItem setRightBarButtonItem: nil animated:YES];
    
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor redColor];
        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //this is the place it reaches when the keyboard's search button is pressed .
    //We need to handle this case well ... tThe thing is it reaches searchBarShouldEndEditing after this. Where the leftbar and
    //right bar buttons reappear ....at this point the cancel button is still there
}

- (IBAction)filterButtonPressed:(id)sender {
    
    //FilterTableViewController *secondView = [[FilterTableViewController alloc] init];
    //self.inputViewController = secondView;
    //[self.navigationController pushViewController:secondView animated:YES];
    
    
    //Animation way one
//    FilterTableViewController *secondView = [[FilterTableViewController alloc] init];
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController pushViewController:secondView animated:NO];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//                     }];
    

    //Animation way two
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFromBottom; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    FilterTableViewController *secondView = [[FilterTableViewController alloc] init];
    [self.navigationController pushViewController:secondView animated:NO];

    //[[self navigationController] popViewControllerAnimated:NO];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [[ServeSyncEngine sharedEngine] startSync];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ServeSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        //NSLog(@"Came from viewdidappear");
        [self loadRecordsFromCoreDataWithSearchString:nil];
        [self.homeTable reloadData];
    }];
    [[ServeSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ServeSyncEngineSyncCompleted" object:nil];
    [[ServeSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (void) setUpNavigationController {
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    self.navigationItem.hidesBackButton = YES;
    //[self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //self.navigationController.toolbarHidden = YES;

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
    
    

    //self.navigationItem.titleView = self.searchController.searchBar;
    
    //self.navigationItem.titleView = self.searchBar;
//    self.navigationItem.leftBarButtonItem = self.filterBarButton;
//    self.navigationItem.rightBarButtonItem = flipBarButton;

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
    
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithTitle:@"Refresh"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refresh:)];
    [refreshButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    

    NSArray *items2 = [NSArray arrayWithObjects:cancelButton,refreshButton, nil];
    self.toolbarItems = items2;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(280, 0, 50, 28);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = .2f;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Map" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.flipViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 50, 28);
    button2.layer.borderColor = [UIColor whiteColor].CGColor;
    button2.layer.borderWidth = .2f;
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"Filter" forState:UIControlStateNormal];
    [button2.titleLabel setTextColor:[UIColor whiteColor]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button2 addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.leftBarButtonItem = self.filterBarButton;
    self.navigationItem.rightBarButtonItem = self.flipViewBarButton;
    
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
        self.listMode = NO;
        self.view = self.mapView;
    }
    else {
        [UIView transitionFromView:self.mapView toView:self.listView
                          duration:.7
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        self.listMode = YES;
        self.view = self.listView;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"Count : %lu",(unsigned long)[self.serverItems count]);
    if(self.homeTable == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
    
    else{
        return [self.serverItems count];}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    PublicListingCell *cell1 = (PublicListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:publicListingCellIdentifier];

    //if(self.serverItems.count)
    {
        Listing *item  = [self.serverItems objectAtIndex:indexPath.row];
        
        if (cell1 == nil) {
            cell1 = [[PublicListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicListingCellIdentifier];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = item.name;
        cell1.serveCount = item.serveCount;
        cell1.addressString = item.address1;
        //cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];
        
        if(item.image)
        {
            cell1.imageView.image = [UIImage imageWithData:item.image];
        }
        else
        {
            cell1.imageView.image = [UIImage imageNamed:@"no-image.png"];
        }
        
        cell1.typeString = item.type;
    }
        return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected");
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    [self.homeTable scrollRectToVisible:searchBarFrame animated:NO];
    return NSNotFound;
}


- (void)loadRecordsFromCoreDataWithSearchString:(NSString*)searchString {

    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"author != %@", @"akhil"];
        NSPredicate *finalPredicate;
    
        if(searchString!=nil)
        {
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
            finalPredicate =[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2,nil]];
        }
        
        else
        {
            finalPredicate = predicate1;
        }
        
        [request setPredicate:finalPredicate];
        self.serverItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshButtonTouched:(id)sender {
    [self loadRecordsFromCoreDataWithSearchString:nil];
    [self.homeTable reloadData];
}

- (void)checkSyncStatus {
    if ([[ServeSyncEngine sharedEngine] syncInProgress]) {
        //[self replaceRefreshButtonWithActivityIndicator];
    } else {
        //[self removeActivityIndicatorFromRefreshButon];
        
        //NSLog(@"Came from checkSyncStatus");
        [self loadRecordsFromCoreDataWithSearchString:nil];
        [self.homeTable reloadData];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButon {
    self.navigationItem.leftBarButtonItem = self.filterBarButton;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}



//- (void)initializePins
//{
//    NSMutableArray *tempoPins;
//    self.mapPins = nil;
//    
//    for (PointOfInterest *location in self.frc.fetchedObjects) {
//        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//        [annotation setCoordinate:CLLocationCoordinate2DMake([location.latitude doubleValue], [location.longitude doubleValue])];
//        [annotation setTitle:@"Entry"];
//        [tempoPins addObject:annotation];
//    }
//    
//    self.mapPins = [[NSArray alloc] initWithArray:tempoPins];
//    [self.mapView addAnnotations:self.mapPins];
//}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    //[self.searchController resignFirstResponder];
//
//}

@end
