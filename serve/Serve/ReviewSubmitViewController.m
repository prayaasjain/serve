//
//  ReviewSubmitViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ReviewSubmitViewController.h"
#import "MapCell.h"
#import "ListingItemDetailCell.h"
#import "ServeCoreDataController.h"

const CGFloat reviewProgressButtonSize = 19.0f;
const CGFloat reviewProgressButtonY = 365.0f;
const CGFloat reviewProgressButtonX = 80.0f;
const CGFloat reviewProgressButtonInset = -2.0f;
const CGFloat reviewProgressIndicatorTextSize = 9.0f;

static NSArray *deleteButtonActionSheetItems = nil;
const CGFloat reviewDeleteButtonTag = 1;

@interface ReviewSubmitViewController ()

///core data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *listingItem;
@property (strong, nonatomic) NSString *entityName;

@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, strong) UIActionSheet *deleteButtonActionSheet;

//starting fresh
@property (nonatomic ,strong) UITableView* homeTable;
@property (nonatomic, strong) ListingNavigationData *currentListing;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)showActionSheet:(id)sender;

@end

@implementation ReviewSubmitViewController

GMSMapView *mapView_;

- (id)initWithListing:(ListingNavigationData *)_listing {
    
    if(self = [super init]) {
        self.currentListing = _listing;
    }
    
    return self;
}

- (void)updateListingWith:(ListingNavigationData *)_newListing {
    self.currentListing = _newListing;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
    self.listingItem = [NSEntityDescription insertNewObjectForEntityForName:@"SelfListing" inManagedObjectContext:self.managedObjectContext];
    
    [self setUpActionSheets];
    [self setUpNavigationController];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.homeTable];
    
    
    ///table setup
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height)
                                                  style:UITableViewStylePlain];
    
    
    self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    //self.homeTable.separatorInset = UIEdgeInsetsMake(-20, -10, 10, 20);
    //self.homeTable.separatorColor=[UIColor grayColor];
    self.homeTable.tableFooterView = [UIView new];
    //[self.homeTable registerClass:[UITableViewCellStyleDefault class] forCellReuseIdentifier:@"addListingCell"];
    [self.homeTable registerClass:[MapCell class] forCellReuseIdentifier:@"MapCell"];
    [self.homeTable registerClass:[ListingItemDetailCell class] forCellReuseIdentifier:@"ListingItemDetailCell"];
    self.homeTable.tableFooterView = [UIView new];
    [self.homeTable setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeTable reloadData];
}

- (UIView *)progressIndicator {
    
    _progressIndicator = [[UIView alloc]initWithFrame:CGRectMake(35, 45, 100, 40)];
    
    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step1Button setTitle:@"1" forState:UIControlStateNormal];
    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step1Button.layer.borderWidth=1.0f;
    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step1Button.layer.cornerRadius = 10;
    step1Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step1Label = [[UILabel alloc]initWithFrame:CGRectMake(_progressIndicator.frame.origin.x, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 60, 20)];
    [step1Label setText:@"Item Details"];
    [step1Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_progressIndicator.frame.origin.x+16+reviewProgressButtonSize, _progressIndicator.frame.origin.y+reviewProgressButtonSize/2, 75, 1.0f)];
    lineView1.backgroundColor = [UIColor blackColor];
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step2Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16+reviewProgressButtonSize+lineView1.frame.size.width,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[part1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step2Button.layer.borderWidth=1.0f;
    step2Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step2Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step2Button.layer.cornerRadius = 10;
    step2Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step2Label = [[UILabel alloc]initWithFrame:CGRectMake(step1Label.frame.origin.x+lineView1.frame.size.width+8, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 80, 20)];
    [step2Label setText:@"Pickup Information"];
    [step2Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x+lineView1.frame.size.width+reviewProgressButtonSize, _progressIndicator.frame.origin.y+reviewProgressButtonSize/2, 75, 2.0f)];
    lineView2.backgroundColor = [UIColor blackColor];
    
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step3Button setFrame:CGRectMake(lineView2.frame.origin.x+lineView2.frame.size.width,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [step3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step3Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step3Button.layer.borderWidth=1.0f;
    step3Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step3Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step3Button.layer.cornerRadius = 10;
    step3Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step3Label = [[UILabel alloc]initWithFrame:CGRectMake(step2Label.frame.origin.x+lineView2.frame.size.width+26, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 80, 20)];
    [step3Label setText:@"Review/Submit"];
    [step3Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
    [step3Label setTextColor:[UIColor redColor]];
    
    [_progressIndicator addSubview:step1Button];
    [_progressIndicator addSubview:step1Label];
    [_progressIndicator addSubview:lineView1];
    [_progressIndicator addSubview:step2Button];
    [_progressIndicator addSubview:step2Label];
    [_progressIndicator addSubview:lineView2];
    [_progressIndicator addSubview:step3Button];
    [_progressIndicator addSubview:step3Label];
    
    return _progressIndicator;
}

- (void) setUpNavigationController {
    [self.navigationItem setTitle:@"Review & Submit"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backButtonPressed:)];
    
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Submit"
                                     style: UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(submitButtonPressed:)];
    
    //trash button
    UIImage *trashImage = [UIImage imageNamed:@"trash.png"];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:trashImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, trashImage.size.width, trashImage.size.height)];
    button.tag = reviewDeleteButtonTag;
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    /////
    
    ///setting color of back and continue buttons to black
    [submitButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [backButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    ////////////////////////////////////////////////////////////
    
    NSArray *items = [NSArray arrayWithObjects:backButton, itemSpace, trashButton, itemSpace, submitButton, nil];
    self.toolbarItems = items;
    
}

- (IBAction)backButtonPressed:(id)sender {
    
//    NSError *error;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"ListingItem" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSLog(@"Zip: %@", [info valueForKey:@"cuisine"]);
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender {
    
    //save to core data
    [self.listingItem setValue:self.currentListing.title forKey:@"name"];
    [self.listingItem setValue:self.currentListing.serveCount forKey:@"serveCount"];
    [self.listingItem setValue:self.currentListing.type forKey:@"type"];
    [self.listingItem setValue:self.currentListing.cuisine forKey:@"cuisine"];
    [self.listingItem setValue:self.currentListing.desc forKey:@"desc"];
    [self.listingItem setValue:self.currentListing.addressLine1 forKey:@"address1"];
    [self.listingItem setValue:self.currentListing.addressLine2 forKey:@"address2"];
    [self.listingItem setValue:self.currentListing.city forKey:@"city"];
    [self.listingItem setValue:self.currentListing.state forKey:@"state"];
    [self.listingItem setValue:self.currentListing.zip forKey:@"zip"];
    [self.listingItem setValue:self.currentListing.phoneNumber forKey:@"phone"];
    //[self.listingItem setValue:self.currentListing.image forKey:@"image"];
    [self.listingItem setValue:[NSNumber numberWithInt:self.currentListing.locationCenter.latitude]forKey:@"latitude"];
    [self.listingItem setValue:[NSNumber numberWithInt:self.currentListing.locationCenter.longitude]forKey:@"longitude"];
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) setUpActionSheets {
    
    deleteButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"Are you sure you want to delete the listing?",
                                    @"Discard Listing",@"Cancel", nil];
    
    self.deleteButtonActionSheet= [[UIActionSheet alloc]initWithTitle:[deleteButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[deleteButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[deleteButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void) showActionSheet:(id)sender {
    NSInteger senderTag = [sender tag];
    
    if(senderTag == reviewDeleteButtonTag)
    {
        [self.deleteButtonActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Discard Listing"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if(section==0)
//    {
//        return 1;
//    }
//    
//    if(section==1)
//    {
//        return 1;
//    }
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if(section==0)
        {
            return @"STEP 3/3";
        }
    
    //    if(section==1)
    //    {
    //        return @"PICKUP INFORMATION";
    //    }
    //
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        return 260.0f;
    }
    
    if(indexPath.section==1)
    {
        return 230.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MapCellIdentifier = @"MapCell";
    static NSString *CellIdentifier =@"ListingItemDetailCell";
    
    ///
    // Similar to UITableViewCell, but
    
    NSString *searchAddress = @"1235,WILDWOOD AVE,SUNNYVALE,CA 94089";
    //NSString *searchAddress = @"19,CHACHAN MANSION, LADENLA ROAD, DARJEELING,INDIA 734101";
    //[MapCell initMapForCellWithAddress:searchAddress];
    
    MapCell *cell1 = (MapCell *)[self.homeTable dequeueReusableCellWithIdentifier:MapCellIdentifier];
    //cell1 = [[MapCell alloc]];
    cell1 = [[MapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MapCellIdentifier withAddress:searchAddress];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell1.backgroundColor = [UIColor darkGrayColor];
    
    ListingItemDetailCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell2 == nil) {
        cell2 = [[ListingItemDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
//    cell2.imageView.image=[UIImage imageNamed:@"food1.jpg"];
//    cell2.Label.text = @"BURGER WITH FRIES";
//    cell2.descInput = @"This is a test description string with a count of 160 This is a test description string with a count of 160 This is a test description string with a count of160";
//    cell2.servesCount = 10;
//    cell2.cuisineInput = @"Chinese";
//    cell2.typeInput =@"Non-Veg";
    //cell2.backgroundColor = [UIColor darkGrayColor];
    
//    cell2.imageView.image = self.currentListing.image;
    cell2.imageView.image = [UIImage imageWithData:self.currentListing.imageData];
    cell2.Label.text = self.currentListing.title;
    cell2.descInput = self.currentListing.desc;
    cell2.serveCount = self.currentListing.serveCount;
    cell2.cuisineInput = self.currentListing.cuisine;
    cell2.typeInput = self.currentListing.type;
    cell2.imageView.image = self.currentListing.image;
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell2.layer.shadowOffset = CGSizeMake(0, 20);
//    cell2.layer.shadowColor = [[UIColor redColor]CGColor];
//    cell2.layer.shadowRadius = 3;
//    cell2.layer.shadowOpacity = .75f;
    cell2.layer.borderColor = [[UIColor blackColor]CGColor];
    cell2.layer.borderWidth = 1;
    
    cell1.layer.borderColor = [[UIColor blackColor]CGColor];
    cell1.layer.borderWidth = 1;
    
    
    if(indexPath.section == 0)
    {
        return cell2;
    }
    
    if(indexPath.section==1)
    {
        return cell1;
    }
    
    return cell1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 45.0f;
    }
    
    return 0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

 
