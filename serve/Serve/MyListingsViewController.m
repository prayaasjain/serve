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
        return [self.dates count];
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
  
    
    SelfListing *item  = [self.dates objectAtIndex:indexPath.row];
    SelfListingCell *cell1 = (SelfListingCell *)[self.homeTable dequeueReusableCellWithIdentifier:selfListingCellIdentifier];
    if (cell1 == nil) {
        cell1 = [[SelfListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selfListingCellIdentifier];
    }

    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.titleLabel.text = item.name;
    cell1.serveCount = item.serveCount;
    cell1.imageView.image = [UIImage imageNamed:@"food1.jpg"];//item.image
    cell1.typeString = @"Non-Veg";//item.type


    if (indexPath.section == 0) {
        return cell;
    }
    else{
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
    return 10.0f;
}

- (IBAction)addNewListingButtonPressed:(id)sender {
    
    if(self.inputViewController == nil){
        NewInputViewController *secondView = [[NewInputViewController alloc] init];
        self.inputViewController = secondView;
    }
    [self.navigationController pushViewController:self.inputViewController animated:YES];
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
        
        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
