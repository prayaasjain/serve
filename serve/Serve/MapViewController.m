//
//  MapViewController.m
//  MapsCustomInfoWindow
//
//  Created by Jon Friskics on 4/22/14.
//  Copyright (c) 2014 Jon Friskics. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;

// this will hold the custom info window we're displaying
@property (strong, nonatomic) UIView *displayedInfoWindow;

/* these three will be used to guess the state of the map animation since there's no
 delegate method to track when the camera update ends */
@property BOOL markerTapped;
@property BOOL cameraMoving;
@property BOOL idleAfterMovement;

/* Since I'm creating the info window based on the marker's position in the
 mapView:idleAtCameraPosition: method, I need a way for that method to know
 which marker was most recently tapped, so I'm using this to store that most
 recently tapped marker */
@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.markerTapped = NO;
    self.cameraMoving = NO;
    self.idleAfterMovement = NO;
    
    // create the map, set the delegate and initial camera, and add it to self.view
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.5463 longitude:-81.3456 zoom:12];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    // create some markers so we have something to tap
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(28.5165, -81.3455);
    marker1.title = @"This is marker 1";
    marker1.map = self.mapView;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(28.5475, -81.3443);
    marker2.title = @"This is marker 2";
    marker2.map = self.mapView;
}

/* This is what would normally load if we weren't creating our own custom info window
 that we can interact with.  I'm leaving this in here because we'll know if our custom
 version went wrong if we all of sudden see a greenish info window, because this method
 shouldn't ever be called. */
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 20, 40);
    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.4 alpha:1.0];
    
    return view;
}

// Since we want to display our custom info window when a marker is tapped, use this delegate method
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    // A marker has been tapped, so set that state flag
    self.markerTapped = YES;
    
    // If a marker has previously been tapped and stored in currentlyTappedMarker, then nil it out
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    // make this marker our currently tapped marker
    self.currentlyTappedMarker = marker;
    
    // if our custom info window is already being displayed, remove it and nil the object out
    if([self.displayedInfoWindow isDescendantOfView:self.view]) {
        [self.displayedInfoWindow removeFromSuperview];
        self.displayedInfoWindow = nil;
    }
    
    /* animate the camera to center on the currently tapped marker, which causes
     mapView:didChangeCameraPosition: to be called */
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker.position];
    [self.mapView animateWithCameraUpdate:cameraUpdate];
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    /* if we got here after we've previously been idle and displayed our custom info window,
     then remove that custom info window and nil out the object */
    if(self.idleAfterMovement) {
        if([self.displayedInfoWindow isDescendantOfView:self.view]) {
            [self.displayedInfoWindow removeFromSuperview];
            self.displayedInfoWindow = nil;
        }
    }
    
    // if we got here after a marker was tapped, then set the cameraMoving state flag to YES
    if(self.markerTapped) {
        self.cameraMoving = YES;
    }
}

// This method gets called whenever the map was moving but has now stopped
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
    /* if we got here and a marker was tapped and our animate method was called, then it means we're ready
     to show our custom info window */
    if(self.markerTapped && self.cameraMoving) {
        
        // reset our state first
        self.cameraMoving = NO;
        self.markerTapped = NO;
        self.idleAfterMovement = YES;
        
        // create our custom info window UIView and set the color to blueish
        self.displayedInfoWindow = [[UIView alloc] init];
        self.displayedInfoWindow.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.8 alpha:1.0];
        
        self.displayedInfoWindow.backgroundColor = [UIColor blackColor];
        self.displayedInfoWindow.alpha = 0.4;
        
        /* pointForCoordinate: takes a lat/lng and converts it into that lat/lngs current equivalent screen point.
         We'll use this to offset the display of the bottom of the custom info window so it doesn't overlap
         the marker icon. */
        CGPoint markerPoint = [self.mapView.projection pointForCoordinate:self.currentlyTappedMarker.position];
        self.displayedInfoWindow.frame = CGRectMake(markerPoint.x-112, markerPoint.y-140, 224, 100);
        
        // Create a label and show the marker's title, just like the default info window does
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 5, 200, 30);
        label.textColor = [UIColor whiteColor];
        label.text = self.currentlyTappedMarker.title;
        [self.displayedInfoWindow addSubview:label];
        
        // Create a button and add a target - something we can't do with the default info window
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(200, 5, 80, 30);
        [button setTitle:@"Click" forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.displayedInfoWindow addSubview:button];
        
        // add the completed custom info window to self.view
        [self.view addSubview:self.displayedInfoWindow];
    }
}

/* If the map is tapped on any non-marker coordinate, reset the currentlyTappedMarker and remove our
 custom info window from self.view */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    if([self.displayedInfoWindow isDescendantOfView:self.view]) {
        [self.displayedInfoWindow removeFromSuperview];
        self.displayedInfoWindow = nil;
    }
}

/* When the button is clicked, verify that we've got access to the correct marker.
 You might use this button to push a new VC with detail about that marker onto the navigation stack. */
- (void)buttonClicked:(id)sender
{
    NSLog(@"button clicked for this marker: %@",self.currentlyTappedMarker);
}

@end