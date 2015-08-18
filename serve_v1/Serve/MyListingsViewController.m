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
#import "Listing.h"
#import "PublicListingViewController.h"
#import "ServeSyncEngine.h"
#import "ServeLoginViewController.h"
#import "AppDelegate.h"
#import "UIColor+Utils.h"
#import "PublicListingCell.h"

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

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *selfListings;

//temporary signOut
@property (nonatomic, strong) UIActionSheet *logoutActionSheet;

@end

@implementation MyListingsViewController

@synthesize selfListings;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpActionSheets];
    [self setUpNavigationController];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] masterManagedObjectContext];
    [self loadRecordsFromCoreData];
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.homeTable.separatorColor=[UIColor grayColor];
    self.homeTable.tableFooterView = [UIView new];
    [self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:addListingCellIdentifier];
    self.homeTable.tableFooterView = [UIView new];
    //self.homeTable.editing = YES;
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ServeSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
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
}


#pragma mark - Logout Action Sheet stuff

- (void)setUpActionSheets{
    
    //here i want to have the display name of the pf user
    NSString *userName = [PFUser currentUser].username;
    
    NSArray *logoutButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"akhil",
                                    @"LogOut",@"Cancel", nil];

    self.logoutActionSheet= [[UIActionSheet alloc]initWithTitle:[logoutButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[logoutButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[logoutButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void)showActionSheet:(id)sender {
    [self.logoutActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"LogOut"])
    {
        [PFUser logOut];
        NSLog(@"LogOut successful");
        
        if(self.loginViewController == nil){
            ServeLoginViewController *secondView = [[ServeLoginViewController alloc] init];
            self.loginViewController = secondView;
        }
        [self.navigationController pushViewController:self.loginViewController animated:YES];
        
    }

    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

#pragma mark - TableViewController stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return
    
    if (section == 0) {
            return 1;
        }
    
    else{
        return [self.selfListings count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///
    // Similar to UITableViewCell, but
    AddListingCell *cell = (AddListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:addListingCellIdentifier];
    if (cell == nil) {
        cell = [[AddListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addListingCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  
    
    
    PublicListingCell *cell1 = (PublicListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];
    
    if(self.selfListings.count)
    {
        Listing *item  = [self.selfListings objectAtIndex:indexPath.row];
        
        if (cell1 == nil) {
        cell1 = [[PublicListingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier withListing:item];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
  
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
    
    if (indexPath.section == 0) {
        return cell;
    }
    else{
        return cell1;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section==0)
    {
       return 10.0f;
    }
    else
    {
        return 0.0f;
    }
}


#pragma mark - swipe cell to delete 

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    
    if ([tableView isEqual:self.homeTable]){
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        
        
    }];
    editAction.backgroundColor = [UIColor blueColor];;
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        
    }];
    
    return @[deleteAction,editAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Your Label";
}

- (void) setEditing:(BOOL)editing
           animated:(BOOL)animated{
    
    [super setEditing:editing
             animated:animated];
    
    [self.homeTable setEditing:editing
                        animated:animated];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObject *listing = [self.selfListings objectAtIndex:indexPath.row];
//        [self.managedObjectContext performBlockAndWait:^{
//            // 1
//            if ([[listing valueForKey:@"objectId"] isEqualToString:@""] || [listing valueForKey:@"objectId"] == nil) {
//                [self.managedObjectContext deleteObject:listing];
//            } else {
//                [listing setValue:[NSNumber numberWithInt:ServeObjectDeleted] forKey:@"syncStatus"];
//            }
//            NSError *error = nil;
//            BOOL saved = [self.managedObjectContext save:&error];
//            if (!saved) {
//                NSLog(@"Error saving main context: %@", error);
//            }
//            
//            [[ServeCoreDataController sharedInstance] saveMasterContext];
//            [self loadRecordsFromCoreData];
//            [self.homeTable reloadData];
//        }];
    }
}

*/

#pragma mark save , cancel and submit


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

- (void)newViewController:(NewViewController *)viewController didCancelItemEdit:(id<ServeListingProtocol>)item
{
    [self.managedObjectContext deleteObject:(Listing*)item];
    [[ServeCoreDataController sharedInstance] saveMasterContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
//        if(self.inputViewController == nil){
//            NewViewController *secondView = [[NewViewController alloc] init];
//            self.inputViewController = secondView;
//        }
        
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
    
    else
    {
        self.inputViewController= [[NewViewController alloc] initWithExistingItem:[self.selfListings objectAtIndex:indexPath]];
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



- (IBAction)addNewListingButtonPressed:(id)sender {
    
}


- (IBAction)refreshButtonTouched:(id)sender {
    [[ServeSyncEngine sharedEngine] startUpSync];
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", @"Akhil"];
        [request setPredicate:predicate];
        
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
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButon];
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




@end

