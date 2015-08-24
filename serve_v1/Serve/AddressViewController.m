//
//  AddressViewController.m
//  Serve
//
//  Created by Akhil Khemani on 8/7/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "AddressViewController.h"
#import "UIColor+Utils.h"

@interface AddressViewController ()

@property (nonatomic, strong) UIView *mapView;
@property (nonatomic, strong) MKMapView *map;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) MKLocalSearchRequest      *locationSearchRequest;
@property (strong, nonatomic) MKLocalSearch             *locationSearch;

@property (nonatomic ,strong) UITableView* homeTable;
@property (nonatomic ,strong) NSMutableArray* searchResults;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResults = [[NSMutableArray alloc]init];
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height-70)];
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
    
    //[self.view addSubview:self.map];
    [self configureSearch];
    
    
    self.homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    //self.homeTable.scrollsToTop = NO;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    self.homeTable.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.homeTable.separatorColor=[UIColor grayColor];
    
    [self.homeTable setHidden:NO];
    [self.homeTable setBackgroundColor:[UIColor serveAppFontColor]];
    self.homeTable.separatorColor=[UIColor blackColor];
    //self.homeTable.backgroundView.alpha = 0.4;
    
    [self.view addSubview:self.map];
    [self.view addSubview:self.homeTable];
    
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
    self.searchController.searchBar.barTintColor = [UIColor lightGrayColor];//this part still not giving ideal results
    
    //[self.view addSubview:self.map];
    self.navigationItem.titleView = self.searchController.searchBar;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    
    [self addressSearchRequestWithSearchString:searchString];
    [self.homeTable reloadData];
//    [self loadRecordsFromCoreDataWithSearchString:searchString];
//    [self.homeTable reloadData];
//    
//    if([searchString length] == 0) {
//        [self loadRecordsFromCoreDataWithSearchString:nil];
//        [self.homeTable reloadData];
//    }
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //[self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //[self.map setHidden:YES];
    [self.homeTable setHidden:NO];
    [self.homeTable reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //[self.map setHidden:YES];
    [self.homeTable setHidden:YES];
    [self.homeTable reloadData];
}

- (void)addressSearchRequestWithSearchString:(NSString *)searchString {
    
    [self.searchResults removeAllObjects];
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:searchString];
    
    //CLLocationCoordinate2D parisCenter = CLLocationCoordinate2DMake(37.3903482, -121.9908367);
    [searchRequest setRegion:self.map.region];
    
    MKCoordinateRegion region;
    region = self.map.region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0;
    span.longitudeDelta = 0;
    region.span = span;
    [searchRequest setRegion:region];

    
    // Create the local search to perform the search
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                
                [self.searchResults addObject:mapItem];
                //[self.searchResults addObject:[[mapItem placemark] title]];
//                [self.map addAnnotation:[mapItem placemark]];
                //NSLog(@"Name: %@, Placemark title: %@", [mapItem name], [[mapItem placemark] title]);
            }
            [self.homeTable reloadData];
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
    

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [theSearchBar resignFirstResponder];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
//        //Error checking
//        
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        MKCoordinateRegion region;
//        region.center.latitude = placemark.region.center.latitude;
//        region.center.longitude = placemark.region.center.longitude;
//        MKCoordinateSpan span;
//        double radius = placemark.region.radius / 1000; // convert to km
//        
//        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
//        span.latitudeDelta = radius / 112.0;
//        
//        region.span = span;
//        
//        [self.map setRegion:region animated:YES];
//    }];
    // Create a search request with a string

    
    //self.searchResults = nil;
    //[self addressSearchRequestWithSearchString:theSearchBar.text];

    //[self.homeTable reloadData];
    
    [self.homeTable setHidden:YES];
    [self.map setHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View delegates

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Settings";
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    //    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(140, 70, 70, 70)];
    //    [profileImageView setImage:[UIImage imageNamed:@"food1.jpg"]];
    //
    //    profileImageView.layer.cornerRadius = 35;
    //    //profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    //    profileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    //    profileImageView.layer.borderWidth = .5;
    //    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    //    [profileImageView setClipsToBounds:YES];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = @"+ ADD NEW LISTING";
    textView.editable = NO;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor serveBackgroundColor];
    [headerView addSubview:textView];
    [textView sizeToFit];
    
    
    
    
    return self.searchController.searchBar;;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView.backgroundColor = [UIColor clearColor];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell1 = [[UITableViewCell alloc]init];
    
    if([self.searchResults objectAtIndex:indexPath.row])
    {
        MKMapItem *result = [self.searchResults objectAtIndex:indexPath.row];
        cell1.textLabel.text = [[result placemark] title];
        cell1.backgroundColor = [UIColor serveAppFontColor];
        
        cell1.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
        cell1.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        cell1.textLabel.numberOfLines = 0;
        cell1.textLabel.textColor = [UIColor blackColor];
        
        //[UIColor colorWithRed:0. green:0.39 blue:0.106 alpha:0.7];//fix this color
        
    
    }
    
    return cell1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MKMapItem *selectedPoint = [self.searchResults objectAtIndex:indexPath.row];
    [self.map addAnnotation:[selectedPoint placemark]];
    
    
    CLLocationCoordinate2D location = [[selectedPoint placemark] coordinate];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
//    location.latitude  = 37.3903482;
//    location.longitude = -121.9908367;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = location;
    [self.map setRegion:region animated:YES];
    [self.map regionThatFits:region];
    
    [self.searchController.searchBar resignFirstResponder];
    [self.homeTable setHidden:YES];
    [self.view endEditing:YES];
    
    //NSLog(@"HHHHHH%@",[selectedAddress]);
}



@end
