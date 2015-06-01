//
//  Listing.h
//  Serve
//
//  Created by Prayaas Jain on 5/31/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Listing : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger serves;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *cuisine;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSDate *pickupDate;

@property (nonatomic, assign) CLLocationCoordinate2D locationCenter;

@end
