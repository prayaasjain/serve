//
//  GoogleMapApi.h
//  Serve
//
//  Created by Akhil Khemani on 5/30/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>

@interface GoogleMapApi : NSObject<GMSMapViewDelegate>

+ (GMSMapView *)displayMapwithAddress:(NSString *)address forFrame:(CGRect)frame;

@end
