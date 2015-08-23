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
#import "ServeSyncEngine.h"
#import "MyListingsViewController.h"
#import "ServeListingProtocol.h"
#import "UIColor+Utils.h"


@interface ReviewSubmitViewController ()


@property (nonatomic, strong) MKMapView *map;

//starting fresh
@property (nonatomic ,strong) UITableView* homeTable;
@property (strong, nonatomic, readwrite) id<ServeListingProtocol> displayItem;
@property (nonatomic, strong) UIView *requestView;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ReviewSubmitViewController


- (id)initWithListing:(id<ServeListingProtocol>)listing {
    
    if(self = [super init]) {
        self.displayItem = listing;
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    ////
    self.requestView = [[UIView alloc]initWithFrame:CGRectZero];
    self.requestView.backgroundColor = [UIColor servePrimaryColor];
    self.requestView.translatesAutoresizingMaskIntoConstraints  = NO;
    UILabel *submitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    submitLabel.text = @"REQUEST for PICKUP";
    [submitLabel setTextColor:[UIColor whiteColor]];
    [submitLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [self.requestView addSubview:submitLabel];
    submitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *submitLabelCenterXConstraint = [NSLayoutConstraint
                                                        constraintWithItem:submitLabel attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual toItem:self.requestView
                                                        attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *submitLabelCenterYConstraint = [NSLayoutConstraint
                                                        constraintWithItem:submitLabel attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.requestView
                                                        attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.requestView addConstraints:@[submitLabelCenterXConstraint,submitLabelCenterYConstraint]];
//    UITapGestureRecognizer *submitTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitButtonPressed:)];
//    [self.requestView addGestureRecognizer:submitTap];

    
    
    
    ////
    
    [self setUpNavigationController];
    
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
//    [self.homeTable registerClass:[MapCell class] forCellReuseIdentifier:@"MapCell"];
    [self.homeTable registerClass:[ListingItemDetailCell class] forCellReuseIdentifier:@"ListingItemDetailCell"];
    self.homeTable.tableFooterView = [UIView new];
    [self.homeTable setBackgroundColor:[UIColor serveBackgroundColor]];
    
    [self.view addSubview:self.homeTable];
    [self.view setBackgroundColor:[UIColor serveBackgroundColor]];
    [self.view addSubview:self.requestView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeTable reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //[self.requestView setFrame:CGRectMake(0, 600, self.view.frame.size.width, 100)];
    
    NSLayoutConstraint *submitButtonWidthConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.requestView attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual toItem:self.view
                                                       attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *submitButtonHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.requestView attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:nil
                                                        attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    
    NSLayoutConstraint *submitButtonBottomConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.requestView attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    
    NSLayoutConstraint *submitButtonLeftConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.requestView attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    [self.view addConstraints:@[submitButtonWidthConstraint,submitButtonHeightConstraint,submitButtonBottomConstraint,submitButtonLeftConstraint
                                ]];
}



- (void) setUpNavigationController {
    [self.navigationItem setTitle:@"Details"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = YES;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 28);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}



-(void)setPlacemarkInMapUsingAddress:(NSString *)searchAddress
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        
        region.span = span;
        
        [self.map setRegion:region animated:YES];
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 260.0f;
    }
    else
    {
        return 230.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier =@"ListingItemDetailCell";
    
    ListingItemDetailCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell2 == nil) {
        cell2 = [[ListingItemDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell2.imageView.image = [UIImage imageWithData:[self.displayItem image]];
    cell2.titleLabel.text = [self.displayItem name];
    cell2.descInput = [self.displayItem desc];
    cell2.serveCount = [self.displayItem serveCount];
    cell2.typeInput = [self.displayItem type];
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.backgroundColor = [UIColor whiteColor];
    cell2.layer.borderColor = [[UIColor blackColor]CGColor];
    cell2.layer.borderWidth = 1;
    

    MapCell *cell1 = [[MapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MapCellIdentifier" withLatitude:[self.displayItem latitude] withLongitude:[self.displayItem longitude]];
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.backgroundColor = [UIColor whiteColor];
    cell1.layer.borderColor = [[UIColor blackColor]CGColor];
    cell1.layer.borderWidth = 1;
    
    
    if(indexPath.section == 0)
    {
        return cell2;
    }
    else
    {
        return cell1;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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

 
