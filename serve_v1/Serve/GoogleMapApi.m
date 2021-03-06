////
////  GoogleMapApi.m
////  Serve
////
////  Created by Akhil Khemani on 5/30/15.
////  Copyright (c) 2015 Akhil Khemani. All rights reserved.
////
//
//#import "GoogleMapApi.h"
//
//@implementation GoogleMapApi
//
// GMSMapView *localMapView_;
//
//+ (CLLocationCoordinate2D) getLatLongFromAddressString: (NSString*) addressStr {
//    double latitude = 0, longitude = 0;
//    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//    if (result) {
//        NSScanner *scanner = [NSScanner scannerWithString:result];
//        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
//            [scanner scanDouble:&latitude];
//            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
//                [scanner scanDouble:&longitude];
//            }
//        }
//    }
//    CLLocationCoordinate2D center;
//    center.latitude=latitude;
//    center.longitude = longitude;
//    
//    //to get address from latlong make a call to
//    //[self getAddressFromLatLong:center];
//    
//    return center;
//    
//}
//
//+ (GMSMapView *)displayMapwithAddress:(NSString *)address forFrame:(CGRect)frame
//{
//    localMapView_.delegate = (id <GMSMapViewDelegate>) self;
//    //localMapView_.delegate =  self;
//    
//    CLLocationCoordinate2D center;
//    center=[self getLatLongFromAddressString:address];
//    double  latitude=center.latitude;
//    double  longitude=center.longitude;
//
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
//                                                            longitude:longitude
//                                                                 zoom:17];
//    
//    localMapView_ = [GMSMapView mapWithFrame:frame camera:camera];
//    localMapView_.myLocationEnabled = YES;
//    
//    // Creates a marker in the center of the map.
////    GMSMarker *marker = [[GMSMarker alloc] init];
////    marker.position = CLLocationCoordinate2DMake(latitude+.001, longitude+.001);
////    marker.title = @"Burger";
////    marker.snippet = @"Location";
////    marker.map = localMapView_;
////    marker.appearAnimation = kGMSMarkerAnimationPop;
////    
////    GMSMarker *marker3 = [[GMSMarker alloc] init];
////    marker3.position = CLLocationCoordinate2DMake(latitude+.002, longitude+.002);
////    marker3.title = @"Pizza";
////    marker3.snippet = @"Location";
////    marker3.map = localMapView_;
////    marker3.appearAnimation = kGMSMarkerAnimationPop;
////    
////    GMSMarker *marker4 = [[GMSMarker alloc] init];
////    marker4.position = CLLocationCoordinate2DMake(latitude-.001, longitude-.001);
////    marker4.title = @"Tandoori Chicken";
////    marker4.snippet = @"Location";
////    marker4.map = localMapView_;
////    marker4.appearAnimation = kGMSMarkerAnimationPop;
//    
//    
//    GMSMarker *marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(latitude, longitude);
////    marker2.title = @"Akhil";
////    marker2.snippet = @"Khemani";
//    marker2.map = localMapView_;
//    marker2.appearAnimation = kGMSMarkerAnimationPop;
//    marker2.infoWindowAnchor = CGPointMake(0.5, 0.5);
//    marker2.icon = [UIImage imageNamed:@"trash.png"];
//    //marker2.icon = [UIImage imageNamed:@"trash.png"];
//    
//    
//    [localMapView_ setSelectedMarker:marker2];
//    //localMapView_.delegate = self;
//    
//
//    
//    
//    return localMapView_;
//}
//
//- (BOOL)mapView:(GMSMapView*)mapView didTapMarker:(GMSMarker*)marker
//{
//    [mapView setSelectedMarker:marker];
//    return YES;
//}
//
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    
//    UIView * windowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 224, 221) ];
//    
//    windowView.backgroundColor = [UIColor redColor];
//   
//    return windowView;
//    
//    
//    
////    InfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
////    view.name.text = @"Place Name";
////    view.description.text = @"Place description";
////    view.phone.text = @"123 456 789";
////    view.placeImage.image = [UIImage imageNamed:@"customPlaceImage"];
////    view.placeImage.transform = CGAffineTransformMakeRotation(-.08);
////    return view;
//}
//
//+ (void)getAddressFromLatLong:(CLLocationCoordinate2D)center
//{
//    CLGeocoder *ceo = [[CLGeocoder alloc]init];
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
//    
//    [ceo reverseGeocodeLocation: loc completionHandler:
//     ^(NSArray *placemarks, NSError *error) {
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         NSLog(@"placemark %@",placemark);
//         //String to hold address
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//         NSLog(@"addressDictionary %@", placemark.addressDictionary);
//         
//         NSLog(@"placemark %@",placemark.region);
//         NSLog(@"placemark %@",placemark.country);  // Give Country Name
//         NSLog(@"placemark %@",placemark.locality); // Extract the city name
//         NSLog(@"location %@",placemark.name);
//         NSLog(@"location %@",placemark.ocean);
//         NSLog(@"location %@",placemark.postalCode);
//         NSLog(@"location %@",placemark.subLocality);
//         
//         NSLog(@"location %@",placemark.location);
//         //Print the location to console
//         NSLog(@"I am currently at %@",locatedAt);
//         
//     }];
//}
//
//@end
