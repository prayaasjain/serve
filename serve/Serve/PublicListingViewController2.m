//
//  MyListingsViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PublicListingViewController2.h"
#import "NewInputViewController.h"
#import "InputViewController.h"
#import "AddListingCell.h"
#import "ServeCoreDataController.h"
//#import "SelfListing.h"
#import "Listing.h"
#import "SelfListingCell.h"
#import "PublicListingViewController.h"

//const CGFloat iconWidth = 25.0f;
//const CGFloat iconHeight = 25.0f;

static NSString * const addListingCellIdentifier = @"addListingCell";
static NSString * const selfListingCellIdentifier = @"selfListingCell";

@interface PublicListingViewController2 ()
@property (nonatomic ,strong) UITableView* homeTable;

- (IBAction)addNewListingButtonPressed:(id)sender;

@property (strong, nonatomic) NewInputViewController *inputViewController;
@property (strong, nonatomic) PublicListingViewController *publicListingViewController;

//coredata
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *listingItem;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *dates;

@end

@implementation PublicListingViewController2

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
    [self.homeTable registerClass:[AddListingCell class] forCellReuseIdentifier:addListingCellIdentifier];
    [self.homeTable registerClass:[SelfListingCell class] forCellReuseIdentifier:selfListingCellIdentifier];
    self.homeTable.tableFooterView = [UIView new];
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadRecordsFromCoreData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self loadRecordsFromCoreData];
    [self.homeTable reloadData];
    
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
    [userButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [userButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
    UIBarButtonItem *userBarButton = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    /////
    
    //messageButton
    UIImage *messageImage = [UIImage imageNamed:@"message1.png"];
    UIButton *messageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:messageImage forState:UIControlStateNormal];
    [messageButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
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
    //self.toolbarItems = items;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return
    
//    if (section == 0) {
//        return 1;
//    }
//    
//    else{
        return [self.dates count];
    //}
    
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
    
    if(self.dates.count)
    {
        Listing *item  = [self.dates objectAtIndex:indexPath.row];
        
        if (cell1 == nil) {
            cell1 = [[SelfListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier];
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.titleLabel.text = item.name;
        cell1.serveCount = item.serveCount;
        //cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];//item.image
        
        cell1.imageView.image = [UIImage imageWithData:item.image];//item.image
        cell1.typeString = @"Non-Veg";//item.type
        //[UIImage imageWithData:self.currentListing.image]
        
    }
    

    {
        return cell1;
    }
    
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

- (IBAction)addNewListingButtonPressed:(id)sender {
    
    //if(self.inputViewController == nil)
    {
        NewInputViewController *secondView = [[NewInputViewController alloc] init];
        self.inputViewController = secondView;
        
    }
    [self.navigationController pushViewController:self.inputViewController animated:YES];
}

- (IBAction)PublicListingButtonPressed:(id)sender {
    
    if(self.publicListingViewController == nil){
        PublicListingViewController *secondView = [[PublicListingViewController alloc] init];
        self.publicListingViewController = secondView;
    }
    [self.navigationController pushViewController:self.publicListingViewController animated:YES];
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

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Listing"];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
