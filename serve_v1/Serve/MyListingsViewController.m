//
//  MyListingsViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "MyListingsViewController.h"
#import "NewInputViewController.h"
#import "AddListingCell.h"
#import "ServeCoreDataController.h"
#import "Listing.h"
#import "PublicListingViewController.h"
#import "ServeSyncEngine.h"
#import "ServeLoginViewController.h"
#import "AppDelegate.h"
#import "UIColor+Utils.h"
#import "PublicListingCell.h"

typedef enum : NSInteger
{
    addlistingheaderbuttonTag = 0,
    addlistingnavigationbuttonTag,
} Tags;

//const CGFloat iconWidth = 25.0f;
//const CGFloat iconHeight = 25.0f;

static NSString * const addListingCellIdentifier = @"addListingCell";
static NSString * const selfListingCellIdentifier = @"publicListingCellIdentifier";

@interface MyListingsViewController ()<NewViewControllerDelegate>
@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)addNewListingButtonPressed:(id)sender;
- (IBAction)refreshButtonTouched:(id)sender;

@property (strong, nonatomic) NewViewController *inputViewController;
@property (strong, nonatomic) PublicListingViewController *publicListingViewController;
@property (strong, nonatomic) ServeLoginViewController *loginViewController;
@property (nonatomic, strong) UIButton *addListingHeaderButton;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *selfListings;

@end

@implementation MyListingsViewController

@synthesize selfListings;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpNavigationController];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] masterManagedObjectContext];
    //  NSLog(@"from viewdidload");
    //[self loadRecordsFromCoreData];
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    [self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:addListingCellIdentifier];
    self.homeTable.tableFooterView = [UIView new];
    //self.homeTable.bounces = NO;
    //self.homeTable.editing = YES;
    self.homeTable.backgroundColor = [UIColor serveBackgroundColor];
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ServeSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
          NSLog(@"from viewdidappear");
        [self loadRecordsFromCoreData];
        [self.homeTable reloadData];
    }];
    [[ServeSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) setUpNavigationController {
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"My Listings"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    self.navigationController.toolbarHidden = YES;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 50, 28);
    [button2 setTitle:@"+" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [button2 setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateSelected];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:26.0]];
    [button2 addTarget:self action:@selector(addNewListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = addlistingnavigationbuttonTag;
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.rightBarButtonItem = filterBarButton;

}


#pragma mark - Logout Action Sheet stuff


#pragma mark - TableViewController stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
        return 1;
    }
    
    return [self.selfListings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0)
    {
        return 60.0f;
    }
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    if(indexPath.section==0)
    {
        UITableViewCell *addListingCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
        addListingCell.textLabel.text = @"Post an Ad";
        addListingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [addListingCell setImage:[UIImage imageNamed:@"edit.png"]];
        
        return addListingCell;
    }
    
    
    else
    {

        PublicListingCell *cell1 = (PublicListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];
        
        if(self.selfListings.count)
        {
            Listing *item  = [self.selfListings objectAtIndex:indexPath.row];
            
            if (cell1 == nil) {
                cell1 = [[PublicListingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier withListing:item];
            }
            if(item.image)
            {
                cell1.imageView.image = [UIImage imageWithData:item.image];
            }
            else
            {
                cell1.imageView.image = [UIImage imageNamed:@"no-image.png"];
            }
            cell1.serveCountLabel.text = [[item serveCount] stringValue];
            cell1.titleLabel.text = [item name];
            cell1.addressLabel.text = @"1235,Wildwood Ave,Sunnyvale";//[item address1];
        }
        
        return cell1;
    }
    
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;//70
}


- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    self.addListingHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.addListingHeaderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addListingHeaderButton setTitle:@"+ ADD NEW LISTING" forState:UIControlStateNormal];
    [self.addListingHeaderButton setTitleColor:[UIColor servetextLabelGrayColor] forState:UIControlStateNormal];
    [self.addListingHeaderButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.addListingHeaderButton setBackgroundColor:[UIColor whiteColor]];
    [self.addListingHeaderButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [self.addListingHeaderButton addTarget:self action:@selector(addNewListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    //[self.addListingHeaderButton setImage: [UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    //[self.addListingHeaderButton setImage: [UIImage imageNamed:@"edit_selected.png"] forState:UIControlStateSelected];
    [self.addListingHeaderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.addListingHeaderButton setTag:addlistingheaderbuttonTag];
    
    //return self.addListingHeaderButton;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0)
    {
        [self addNewListingButtonPressed:nil];
    }
    
    else
    {
        id<ServeListingProtocol> listing = [self.selfListings objectAtIndex:indexPath.row];
        self.inputViewController= [[NewViewController alloc] initWithExistingItem:listing];
        self.inputViewController.view.backgroundColor = [UIColor lightGrayColor];
        self.inputViewController.delegate = self;
        UINavigationController *navigationController1 = nil;
        navigationController1 = [[UINavigationController alloc] initWithRootViewController:self.inputViewController];
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor servetextLabelGrayColor],NSForegroundColorAttributeName,
                                                   nil];
        navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
        navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
        [self presentViewController:navigationController1 animated:YES completion:nil];
    }
}


#pragma mark Newviewcontroller delegate callbacks

- (void)newViewController:(NewViewController *)viewController didSaveItem:(id<ServeListingProtocol>)savedItem
{
    NSLog(@"Reached here successfully");
    
    [self.managedObjectContext performBlockAndWait:^
     {
         NSError *error = nil;
         BOOL saved = [self.managedObjectContext save:&error];
         if (!saved) {
             // do some real error handling
             NSLog(@"Could not save Date due to %@", error);
         }
         [[ServeCoreDataController sharedInstance] saveMasterContext];
     }
     ];

    [self.homeTable reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[ServeSyncEngine sharedEngine] startUpSync];

}

- (void)newViewController:(NewViewController *)viewController deleteItem:(id<ServeListingProtocol>)item
{
    [self.managedObjectContext performBlockAndWait:^{
        if ([[item objectId] isEqualToString:@""] || [item objectId] == nil) {
            [self.managedObjectContext deleteObject:item];
        } else {
            [item setSyncStatus:[NSNumber numberWithInt:ServeObjectDeleted]];
        }
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            NSLog(@"Error saving main context: %@", error);
        }
        [[ServeCoreDataController sharedInstance] saveMasterContext];

    }];

    [self.homeTable reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[ServeSyncEngine sharedEngine] startUpSync];
    
}


- (void)newViewController:(NewViewController *)viewController didCancelItemEdit:(id<ServeListingProtocol>)item inMode:(NSInteger)mode
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(mode==CreateMode)
    {
        [self.managedObjectContext deleteObject:(Listing*)item];
        [[ServeCoreDataController sharedInstance] saveMasterContext];
    }
}


- (void)addNewListingButtonPressed:(id)sender {
    
    if([sender tag] == addlistingheaderbuttonTag)
    {
        [self.addListingHeaderButton setSelected:YES];
        [self.addListingHeaderButton setBackgroundColor:[UIColor servePrimaryColor]];
    }
    
    self.inputViewController= [[NewViewController alloc] initWithNewItem];
    self.inputViewController.view.backgroundColor = [UIColor lightGrayColor];
    self.inputViewController.delegate = self;
    UINavigationController *navigationController1 = nil;
    navigationController1 = [[UINavigationController alloc] initWithRootViewController:self.inputViewController];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor servetextLabelGrayColor],NSForegroundColorAttributeName,
                                               nil];
    navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    [self presentViewController:navigationController1 animated:YES completion:nil];

    
}

- (IBAction)refreshButtonTouched:(id)sender {
    [[ServeSyncEngine sharedEngine] startUpSync];
}

- (void)loadRecordsFromCoreData {
    
    NSLog(@"loadRecordsFromCoreData");
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"author = %@", @"Akhil"];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"syncStatus != %d", ServeObjectDeleted];
        NSPredicate *predicate3 =[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2,nil]];
        
        [request setPredicate:predicate3];
        
        self.selfListings = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveAndSyncMethod {
    [[ServeSyncEngine sharedEngine] startUpSync];
}

- (void)checkSyncStatus {
    if ([[ServeSyncEngine sharedEngine] syncInProgress]) {
    } else {
        [self loadRecordsFromCoreData];
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
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end

