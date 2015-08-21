//
//  CustomAnnotation.m
//  Serve
//
//  Created by Akhil Khemani on 8/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation

@synthesize coordinate;
@synthesize listing;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}


//- (CLLocationCoordinate2D)coordinate {
//    NSLog(@"Akhil2");
//    return coordinate;
//}

@end
