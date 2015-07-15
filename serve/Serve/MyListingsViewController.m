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
#import "SelfListingCell.h"
#import "PublicListingViewController.h"
#import "ServeSyncEngine.h"
#import "ServeLoginViewController.h"

//const CGFloat iconWidth = 25.0f;
//const CGFloat iconHeight = 25.0f;

static NSString * const addListingCellIdentifier = @"addListingCell";
static NSString * const selfListingCellIdentifier = @"selfListingCell";

@interface MyListingsViewController ()
@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)addNewListingButtonPressed:(id)sender;
- (IBAction)refreshButtonTouched:(id)sender;

@property (strong, nonatomic) NewInputViewController *inputViewController;
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
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    [self loadRecordsFromCoreData];
 
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
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    
    //add button
    UIImage *image = [UIImage imageNamed:@"plus.png"];
    UIButton *addButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:image forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNewListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(0, -40, iconWidth*3, iconHeight*3)];
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    /////
    
    //userButton
    UIImage *userImage = [UIImage imageNamed:@"person.png"];
    UIButton *userButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setImage:userImage forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [userButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    /////
    
    //messageButton
    UIImage *messageImage = [UIImage imageNamed:@"message1.png"];
    UIButton *messageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:messageImage forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(refreshButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [messageButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *messageBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    /////
    
    //myListButton
    UIImage *myListImage = [UIImage imageNamed:@"listing.png"];
    UIButton *myListButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [myListButton setImage:myListImage forState:UIControlStateNormal];
    [myListButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [myListButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    [myListButton addTarget:self action:@selector(PublicListingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myListBarButton = [[UIBarButtonItem alloc] initWithCustomView:myListButton];
    /////
    
    NSArray *items = [NSArray arrayWithObjects:myListBarButton,itemSpace, addBarButton,itemSpace, messageBarButton,itemSpace, userBarButton, nil];
    self.toolbarItems = items;
    
}


#pragma mark - Logout Action Sheet stuff

- (void)setUpActionSheets{
    
    //here i want to have the display name of the pf user
    NSString *userName = [PFUser currentUser].username;
    
    NSArray *logoutButtonActionSheetItems = [[NSArray alloc] initWithObjects:userName,
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    SelfListingCell *cell1 = (SelfListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];
    if(self.selfListings.count)
    {
        Listing *item  = [self.selfListings objectAtIndex:indexPath.row];
        
        if (cell1 == nil) {
            cell1 = [[SelfListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier];
        }

        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = item.name;
        //cell1.syncStatusValue = item.syncStatus;
        cell1.serveCount = item.serveCount;
   
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        if(self.inputViewController == nil){
            NewInputViewController *secondView = [[NewInputViewController alloc] init];
            self.inputViewController = secondView;
        }
        self.inputViewController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:self.inputViewController animated:YES];
    }
    
}



- (IBAction)addNewListingButtonPressed:(id)sender {
    
    
//    EWDBlurExampleVC *secondView = [[EWDBlurExampleVC alloc]init];
//    [self.navigationController pushViewController:secondView animated:YES];
    
    
    NewInputViewController *secondView = [[NewInputViewController alloc] init];
    self.inputViewController = secondView;
    [self.navigationController pushViewController:self.inputViewController animated:YES];
}

- (IBAction)PublicListingButtonPressed:(id)sender {
    if(self.publicListingViewController == nil){
        PublicListingViewController *secondView = [[PublicListingViewController alloc] init];
        self.publicListingViewController = secondView;
    }
    [self.navigationController pushViewController:self.publicListingViewController animated:YES];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", @"akhil"];
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
    //self.navigationItem.leftBarButtonItem = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}

@end

