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

static NSString * const publicListingCellIdentifier = @"publicListingCellIdentifier";

@interface PublicListingViewController ()
@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)switchButtonPressed:(id)sender;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) BOOL listMode;;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) UIBarButtonItem *filterBarButton;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation PublicListingViewController

@synthesize serverItems;
@synthesize managedObjectContext;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    
    [self loadRecordsFromCoreData];

    [self setUpNavigationController];
    
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
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //setting up mapview
    self.mapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.backgroundColor = [UIColor yellowColor];
    self.mapView = [GoogleMapApi displayMapwithAddress:@"1235,Wildwood Ave,Sunnyvale,CA" forFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh:)
      forControlEvents:UIControlEventValueChanged];
    //[self.homeTable addSubview:refresh];
     //self.view = self.listView;
    
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ServeSyncEngineSyncCompleted" object:nil];
//    [[ServeSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
//}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [[ServeSyncEngine sharedEngine] startUpSync];
    //[refreshControl endRefreshing];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    //[self loadRecordsFromCoreData];
//    [self.homeTable reloadData];
//    [super viewWillAppear: animated];
//}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //[self checkSyncStatus];
//    [
//     
//     [NSNotificationCenter defaultCenter] addObserverForName:@"ServeSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        [self loadRecordsFromCoreData];
//        [self.homeTable reloadData];
//    }];
//    [[ServeSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];

    //[self loadRecordsFromCoreData];
//    [self.homeTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (void) setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    //[self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //self.navigationController.toolbarHidden = YES;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //self.searchController.searchResultsUpdater = self.homeTable;
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
    self.filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];

    self.navigationItem.titleView = self.searchController.searchBar;
    self.navigationItem.leftBarButtonItem = self.filterBarButton;
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
    
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithTitle:@"Refresh"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refresh:)];
    [refreshButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    

    NSArray *items2 = [NSArray arrayWithObjects:cancelButton,refreshButton, nil];
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
    
    NSLog(@"Count : %lu",(unsigned long)[self.serverItems count]);
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
            cell1 = [[PublicListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:publicListingCellIdentifier];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = item.name;
        cell1.serveCount = item.serveCount;
        cell1.addressString = item.address1;
        //cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];
        cell1.imageView.image = [UIImage imageWithData:item.image];
        cell1.typeString = item.type;
    }
        return cell1;
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author != %@", @"akhil"];
        [request setPredicate:predicate];
        
        self.serverItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)checkSyncStatus {
//    if ([[ServeSyncEngine sharedEngine] syncInProgress]) {
//        [self replaceRefreshButtonWithActivityIndicator];
//    } else {
//        [self removeActivityIndicatorFromRefreshButon];
//    }
//}

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

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"syncInProgress"]) {
//        [self checkSyncStatus];
//    }
//}


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


// text view
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self textViewAnimationStart:textField];
//    
//    if([textField.text isEqualToString:titlePlaceholder])
//    {
//        textField.text = @"";
//        textField.textColor = [UIColor blackColor];
//    }
//    else if ([textField.text isEqualToString:cuisinePlaceholder])
//    {
//        textField.text = @"";
//        textField.textColor = [UIColor blackColor];
//    }
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self textViewAnimationEnd];
//    
//    if ([textField.text isEqualToString:@""]) {
//        
//        if(textField.tag == TitleInputTag){
//            textField.text = titlePlaceholder;
//            textField.textColor = [UIColor grayColor];
//        }
//        
//        else if(textField.tag == CusineInputTag){
//            textField.text = cuisinePlaceholder;
//            textField.textColor = [UIColor grayColor];
//        }
//        
//        [textField resignFirstResponder];
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    //[self.searchController resignFirstResponder];
//
//}

@end
