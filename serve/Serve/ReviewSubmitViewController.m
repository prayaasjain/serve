//
//  ReviewSubmitViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ReviewSubmitViewController.h"
#import "MapCell.h"
#import "GoogleMapApi.h"
#import "ListingItemDetailCell.h"

const CGFloat reviewProgressButtonSize = 19.0f;
const CGFloat reviewProgressButtonY = 365.0f;
const CGFloat reviewProgressButtonX = 80.0f;
const CGFloat reviewProgressButtonInset = -2.0f;
const CGFloat reviewProgressIndicatorTextSize = 9.0f;

static NSArray *deleteButtonActionSheetItems = nil;
const CGFloat reviewDeleteButtonTag = 1;

@interface ReviewSubmitViewController ()

@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, strong) UIActionSheet *deleteButtonActionSheet;

//starting fresh
@property (nonatomic ,strong) UITableView* homeTable;

@property (nonatomic, strong) Listing *currentListing;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)showActionSheet:(id)sender;

@end

@implementation ReviewSubmitViewController

GMSMapView *mapView_;

- (id)initWithListing:(Listing *)_listing {
    
    if(self = [super init]) {
        self.currentListing = _listing;
    }
    
    return self;
}

- (void)updateListingWith:(Listing *)_newListing {
    self.currentListing = _newListing;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //google map setUP
    //    NSString *searchAddress = @"1235,wildwood ave,sunnyvale,california" ;
    //    mapView_ = [GoogleMapApi displayMapwithAddress:searchAddress];
    //[self.view addSubview:mapView_];
    
    [self setUpActionSheets];
    [self setUpNavigationController];
    [self.view setBackgroundColor:[UIColor blackColor]];
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
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender {
    NSLog(@"Trying to submit");
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
    
    if ([buttonTitle isEqualToString:@"Other Button 1"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Other Button 2"]) {
        NSLog(@"Other 2 pressed");
    }
    if ([buttonTitle isEqualToString:@"Other Button 3"]) {
        NSLog(@"Other 3 pressed");
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
        return 1;
    }
    
    if(section==1)
    {
        return 1;
    }
    
    return 2;
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string = @"Heading";
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    return view;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    if(section==0)
    //    {
    //        return @"ITEM DETAILS";
    //    }
    
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
        return 260.0f;
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
    
    
    
    ListingItemDetailCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell2 == nil) {
        cell2 = [[ListingItemDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell2.imageView.image=[UIImage imageNamed:@"food1.jpg"];
//    cell2.Label.text = @"BURGER WITH FRIES";
    cell2.Label.text = self.currentListing.title;
    cell2.descriptionLabel.text = @"Description :We are trying to fit in a long description over here lets see till where does it fit and if the second line appears as we want or not and theres actually more text";
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //[[cell2 imageView] setImage:[UIImage imageNamed:@"food1.jpg"]];
    //        [[cell2 textLabel] setText: @"Burger"];
    //        [[cell2 detailTextLabel] setText: @"Serves -2"];
    
    
    
    
    //    switch (indexPath.section)
    //    {
    //        case 0:
    //            break;
    //        case 1:
    ////            customCell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    ////            customCell.detailTextLabel.numberOfLines = 0;
    //            break;
    //    }
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


/*
 - (void)displayMapwithLatitude:(double)latitude Longitude:(double)longitude {
 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
 longitude:longitude
 zoom:17];
 CGRect frame = CGRectMake(50, 200, 300, 300);
 
 //CGRect frame = CGRectMake(0, 0, 50, 50);
 
 mapView_ = [GMSMapView mapWithFrame:frame camera:camera];
 mapView_.myLocationEnabled = YES;
 //self.view = mapView_;
 
 // Creates a marker in the center of the map.
 GMSMarker *marker = [[GMSMarker alloc] init];
 marker.position = CLLocationCoordinate2DMake(latitude+.001, longitude+.001);
 marker.title = @"My";
 marker.snippet = @"Location";
 marker.map = mapView_;
 marker.appearAnimation = kGMSMarkerAnimationPop;
 
 ///
 GMSMarker *marker2 = [[GMSMarker alloc] init];
 marker2.position = CLLocationCoordinate2DMake(latitude, longitude);
 marker2.title = @"Your Listing";
 marker2.snippet = @"Location";
 marker2.map = mapView_;
 
 marker2.appearAnimation = kGMSMarkerAnimationPop;
 //marker2.icon = [UIImage imageNamed:@"trash.png"];
 
 }
 
 
 - (CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
 double latitude = 0, longitude = 0;
 NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
 NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
 if (result) {
 NSScanner *scanner = [NSScanner scannerWithString:result];
 if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
 [scanner scanDouble:&latitude];
 if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
 [scanner scanDouble:&longitude];
 }
 }
 }
 CLLocationCoordinate2D center;
 center.latitude=latitude;
 center.longitude = longitude;
 NSLog(@"View Controller get Location Logitute : %f",center.latitude);
 NSLog(@"View Controller get Location Latitute : %f",center.longitude);
 return center;
 
 }
 
 */