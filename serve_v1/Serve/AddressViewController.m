//
//  AddressViewController.m
//  Serve
//
//  Created by Akhil Khemani on 8/7/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()

@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) MKMapView *map;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) MKLocalSearchRequest      *locationSearchRequest;
@property (strong, nonatomic) MKLocalSearch             *locationSearch;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.map.delegate = self;

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
    [self.map setRegion:region animated:YES];
    [self.map regionThatFits:region];
    //////////
    
    [self.view addSubview:self.map];
    [self configureSearch];
    
    // Do any additional setup after loading the view.
}


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
    
    //[self.view addSubview:self.map];
    self.navigationItem.titleView = self.searchController.searchBar;
    
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
//    [self loadRecordsFromCoreDataWithSearchString:searchString];
//    [self.homeTable reloadData];
//    
//    if([searchString length] == 0) {
//        [self loadRecordsFromCoreDataWithSearchString:nil];
//        [self.homeTable reloadData];
//    }
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //[self.navigationItem setLeftBarButtonItem: nil animated:YES];
    //[self.navigationItem setRightBarButtonItem: nil animated:YES];
    
//    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
//    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor redColor];
//        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}]];
//    }
    return YES;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
