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
#import "PublicListingCell.h"
#import "ServeSyncEngine.h"
#import "FilterTableViewController.h"
#import "ServeListingProtocol.h"
#import "ReviewSubmitViewController.h"
#import "UIColor+Utils.h"
#import "CustomAnnotation.h"
#import "APPViewController.h"

static NSString * const publicListingCellIdentifier = @"publicListingCellIdentifier";

@interface PublicListingViewController ()

@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)switchButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL listMode;;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) UIBarButtonItem *flipViewBarButton;
@property (nonatomic, strong) UIButton *flipViewButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) NSMutableArray *mapPins;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) MKPointAnnotation *selectedAnnotation;

//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PublicListingViewController

@synthesize serverItems;
@synthesize map = _map;
@synthesize managedObjectContext;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    


    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    [self loadRecordsFromCoreDataWithSearchString:nil];
    [self setUpNavigationController];
    [self configureSearch];

    self.listMode = YES;
    self.listView = [[UIView alloc]initWithFrame:CGRectZero];
    self.listView.frame = self.view.bounds;

    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    //[self.homeTable registerClass:[PublicListingCell class] forCellReuseIdentifier:publicListingCellIdentifier];
    [self.listView addSubview:self.homeTable];
    [self.listView setBackgroundColor:[UIColor whiteColor]];
    
    self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self initializePins];
    [self.mapView addSubview:_map];
    
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refresh addTarget:self action:@selector(refresh:)
      forControlEvents:UIControlEventValueChanged];
    [self.homeTable addSubview:self.refresh];
    
    self.view = self.listView;
    
}

- (MKMapView *)map {
    if(!_map)
    {
        _map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _map.delegate = self;
        //////////
        CLLocationCoordinate2D location = self.map.userLocation.coordinate;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        location.latitude  = 37.3903482;
        location.longitude = -121.9908367;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        region.span = span;
        region.center = location;
        [_map setRegion:region animated:YES];
        [_map regionThatFits:region];
    }
    
    return _map;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ServeSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
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

- (void) setUpNavigationController {
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    self.navigationItem.hidesBackButton = YES;
    //[self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //self.navigationController.toolbarHidden = YES;

    self.flipViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flipViewButton.frame = CGRectMake(0, 0, 50, 28);
    self.flipViewButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.flipViewButton.layer.borderWidth = .2f;
    self.flipViewButton.layer.cornerRadius = 5;
    [self.flipViewButton setTitle:@"Map" forState:UIControlStateNormal];
    [self.flipViewButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.flipViewButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [self.flipViewButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.flipViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.flipViewButton];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton.frame = CGRectMake(0, 0, 50, 28);
    self.filterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.filterButton.layer.borderWidth = .2f;
    self.filterButton.layer.cornerRadius = 5;
    [self.filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [self.filterButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.filterButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [self.filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.filterButton];
    
    self.navigationItem.leftBarButtonItem = self.filterBarButton;
    self.navigationItem.rightBarButtonItem = self.flipViewBarButton;
    
}


#pragma mark - Table View delegates

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return [self.serverItems count];
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
            //cell1 = [[PublicListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicListingCellIdentifier];
            
            cell1 = [[PublicListingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicListingCellIdentifier withListing:item];

        }

        cell1.selectionStyle = UITableViewCellSelectionStyleBlue;

        if(item.image)
        {
            cell1.imageView.image = [UIImage imageWithData:item.image];
            //cell1.contentMode = UIViewContentModeScaleAspectFill;
        }
        else
        {
            cell1.imageView.image = [UIImage imageNamed:@"no-image.png"];
        }
        cell1.serveCountLabel.text = [[item serveCount] stringValue];
        cell1.titleLabel.text = [item name];
        cell1.addressLabel.text = [item address1];
        //[self.map addAnnotation:item];
        
    }
        return cell1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = nil;
    id<ServeListingProtocol> listing = [self.serverItems objectAtIndex:indexPath.row];
    ReviewSubmitViewController *listingDetailsViewController = [[ReviewSubmitViewController alloc]initWithListing:listing];
    
    
//    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:listingDetailsViewController];
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               [UIColor whiteColor],NSForegroundColorAttributeName,
//                                               nil];
//    navigationController1.navigationBar.barTintColor = [UIColor darkGrayColor];//#007AFF
//    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
//    navigationController1.toolbar.barTintColor = [UIColor darkGrayColor];
//    [self presentViewController:navigationController1 animated:YES completion:nil];
    
    
    UINavigationController *navigationController1 = nil;
    navigationController1 = [[UINavigationController alloc] initWithRootViewController:listingDetailsViewController];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor servetextLabelGrayColor],NSForegroundColorAttributeName,
                                               nil];
    navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    [self presentViewController:navigationController1 animated:YES completion:nil];

   
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    [self.homeTable scrollRectToVisible:searchBarFrame animated:NO];
    return NSNotFound;
}


#pragma mark - Search Controller

- (void)configureSearch {
    //new code//
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    //[self.searchController.searchBar sizeToFit];
    //self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation =NO;
    self.searchController.searchBar.barTintColor = [UIColor clearColor];//this part still not giving ideal results
    self.navigationItem.titleView = self.searchController.searchBar;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    [self loadRecordsFromCoreDataWithSearchString:searchString];
    [self.homeTable reloadData];
    
    if([searchString length] == 0) {
        [self loadRecordsFromCoreDataWithSearchString:nil];
        [self.homeTable reloadData];
        [self.map deselectAnnotation:self.selectedAnnotation animated:YES];
    }

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationItem setLeftBarButtonItem: self.filterBarButton animated:YES];
    [self.navigationItem setRightBarButtonItem: self.flipViewBarButton animated:YES];
    
    [self selectAnnotationUsingSearchResults];
    
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


#pragma mark - Action items and Frc

- (void)loadRecordsFromCoreDataWithSearchString:(NSString*)searchString {

    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"author != %@", @"Akhil"];
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

- (void)initializePins {
    
    NSMutableArray *tempoPins = [[NSMutableArray alloc]init];
    NSMutableArray *tempoPins2 = [[NSMutableArray alloc]init];
    self.mapPins = nil;
    
    for (Listing *item in self.serverItems) {
        
//        CLLocationCoordinate2D location2 = CLLocationCoordinate2DMake([item.latitude doubleValue], [item.longitude doubleValue]);
//        [item setCoordinate:location2];
        
        
        //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D location ;
        location = CLLocationCoordinate2DMake([item.latitude doubleValue], [item.longitude doubleValue]);
        CustomAnnotation *annotation = [[CustomAnnotation alloc]initWithLocation:location];
        [annotation setObjectId:[item objectId]];
        [annotation setTitle:[item name]];
        //[annotation setImage:[UIImage imageWithData:[item image]]];
        annotation.listing = item;
        [tempoPins addObject:annotation];
        
        //[tempoPins2 addObject:item];
    }
    
    self.mapPins = [[NSMutableArray alloc] initWithArray:tempoPins];
    [self.map addAnnotations:tempoPins];
    
    

    
    
    
  //  [self.map addAnnotations:self.serverItems];

}

- (void)selectAnnotationUsingSearchResults {
    
    Listing *selectedItem = [self.serverItems firstObject];
    
    for (id annotation in self.mapPins)
    {
        if ([annotation isKindOfClass:[CustomAnnotation class]]&&[[annotation objectId] isEqualToString:[selectedItem objectId]])
        {
            [self.map selectAnnotation:annotation animated:YES];
            self.selectedAnnotation = annotation;
            
        }
    }
    
//    Listing *selectedItem = [self.serverItems firstObject];
//    [self.map selectAnnotation:selectedItem animated:YES];
 
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[CustomAnnotation class]])
    {
        
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // If appropriate, customize the callout by adding accessory views (code not shown).
        }
        else
            pinView.annotation = annotation;
        
        
        // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add a custom image to the left side of the callout.
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plate_filled_selected.png"]];
        pinView.leftCalloutAccessoryView = myCustomImage;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CustomAnnotation *tempAnnotation = (CustomAnnotation *)view.annotation;
    Listing *temp = tempAnnotation.listing;
        
    id<ServeListingProtocol>listing = temp;
    NSLog(@" %@",[listing name]);

    ReviewSubmitViewController *listingDetailsViewController = [[ReviewSubmitViewController alloc]initWithListing:listing];

    UINavigationController *navigationController1 = nil;
    navigationController1 = [[UINavigationController alloc] initWithRootViewController:listingDetailsViewController];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor servetextLabelGrayColor],NSForegroundColorAttributeName,
                                               nil];
    navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    [self presentViewController:navigationController1 animated:YES completion:nil];

    

}

- (IBAction)switchButtonPressed:(id)sender {
    
    if (self.listMode == YES) {
        [UIView transitionFromView:self.listView toView:self.mapView
                          duration:0.7
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        self.listMode = NO;
        self.view = self.mapView;
        [self.flipViewButton setTitle:@"List" forState:UIControlStateNormal];
    }
    else {
        [UIView transitionFromView:self.mapView toView:self.listView
                          duration:.7
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:NULL];
        self.listMode = YES;
        self.view = self.listView;
        [self.flipViewButton setTitle:@"Map" forState:UIControlStateNormal];
    }
    
}

- (IBAction)filterButtonPressed:(id)sender {
    
//    //Animation way two
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    transition.type = kCATransitionFromBottom; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    
    FilterTableViewController *secondView = [[FilterTableViewController alloc] init];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:secondView];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor],NSForegroundColorAttributeName,
                                               nil];
    navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    navigationController1.toolbar.barTintColor = [UIColor servePrimaryColor];
    [self presentViewController:navigationController1 animated:YES completion:nil];
    
    
//    
//    APPViewController *secondView = [[APPViewController alloc] init];
//    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:secondView];
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               [UIColor serveRedButtonColor],NSForegroundColorAttributeName,
//                                               nil];
//    navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
//    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
//    navigationController1.toolbar.barTintColor = [UIColor darkGrayColor];
//    [self presentViewController:navigationController1 animated:YES completion:nil];
    
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [[ServeSyncEngine sharedEngine] startSync];
}

- (void)checkSyncStatus {
    if ([[ServeSyncEngine sharedEngine] syncInProgress]) {
    } else {
        [self.refresh endRefreshing];
        [self loadRecordsFromCoreDataWithSearchString:nil];
        [self.homeTable reloadData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    //[self.searchController resignFirstResponder];
//
//}

/*
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 - (NSFetchedResultsController *)fetchedResultsController {
 if (_fetchedResultsController) return _fetchedResultsController;
 
 NSFetchedResultsController *frc = nil;
 
 if (self.managedObjectContext) {  // using UIManagedDocument for Core Data storage
 NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Listing"];
 NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
 [request setSortDescriptors:@[sortDescriptor]];
 NSManagedObjectContext *moc = self.managedObjectContext;
 frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
 [frc setDelegate:self];
 
 _fetchedResultsController = frc;
 
 NSError *error = nil;
 [_fetchedResultsController performFetch:&error];
 
 [self configureAnnotations];
 }
 
 return _fetchedResultsController;
 }
 
 
 - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
 }
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 }
 
 - (void)controller:(NSFetchedResultsController *)controller
 didChangeObject:(id)anObject
 atIndexPath:(NSIndexPath *)indexPath
 forChangeType:(NSFetchedResultsChangeType)type
 newIndexPath:(NSIndexPath *)newIndexPath
 {
 switch (type) {
 case NSFetchedResultsChangeInsert:
 [self fetchedResultsChangeInsert:anObject];
 break;
 case NSFetchedResultsChangeDelete:
 [self fetchedResultsChangeDelete:anObject];
 break;
 case NSFetchedResultsChangeUpdate:
 [self fetchedResultsChangeUpdate:anObject];
 break;
 case NSFetchedResultsChangeMove:
 // do nothing
 break;
 
 default:
 break;
 }
 }
 
 - (void)fetchedResultsChangeUpdate:(Listing *)listing
 {
 [self fetchedResultsChangeDelete:listing];
 [self fetchedResultsChangeInsert:listing];
 }
 
 - (void)fetchedResultsChangeInsert:(Listing *)listing
 {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.map addAnnotation:listing];
 });
 
 }
 
 - (void)fetchedResultsChangeDelete:(Listing *)listing
 {
 [self.map removeAnnotation:listing];
 }
 
 - (void)configureAnnotations
 {
 [self.map removeAnnotations:self.map.annotations];
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.map addAnnotations:[self.fetchedResultsController fetchedObjects]];
 });
 }
 
 
 - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
 {
 MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyPin"];
 if (!annotationView) {
 annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
 annotationView.canShowCallout = YES;
 annotationView.animatesDrop = YES;
 }
 
 annotationView.annotation = annotation;
 
 return annotationView;
 }
 
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

//- (void)replaceRefreshButtonWithActivityIndicator {
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
//    [activityIndicator startAnimating];
//    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
//    self.navigationItem.leftBarButtonItem = activityItem;
//}

//- (void)removeActivityIndicatorFromRefreshButon {
//    self.navigationItem.leftBarButtonItem = self.filterBarButton;
//
//}