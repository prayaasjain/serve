//
//  GoogleMapApi.m
//  Serve
//
//  Created by Akhil Khemani on 5/30/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "GoogleMapApi.h"

@implementation GoogleMapApi

 GMSMapView *localMapView_;

+ (CLLocationCoordinate2D) getLatLongFromAddressString: (NSString*) addressStr {
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
    
    //to get address from latlong make a call to
    [self getAddressFromLatLong:center];
    
    return center;
    
}

+ (GMSMapView *)displayMapwithAddress:(NSString *)address forFrame:(CGRect)frame
{
    
    CLLocationCoordinate2D center;
    center=[self getLatLongFromAddressString:address];
    double  latitude=center.latitude;
    double  longitude=center.longitude;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:17];
    
    localMapView_ = [GMSMapView mapWithFrame:frame camera:camera];
    localMapView_.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(latitude+.001, longitude+.001);
//    marker.title = @"My";
//    marker.snippet = @"Location";
//    marker.map = localMapView_;
//    marker.appearAnimation = kGMSMarkerAnimationPop;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker2.title = @"Your Listing";
    marker2.snippet = @"Location";
    marker2.map = localMapView_;
    marker2.appearAnimation = kGMSMarkerAnimationPop;
    //marker2.icon = [UIImage imageNamed:@"trash.png"];
    
    return localMapView_;
}

+ (void)getAddressFromLatLong:(CLLocationCoordinate2D)center
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
     }];
}

@end
