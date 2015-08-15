//
//  CustomAnnotation.h
//  Serve
//
//  Created by Akhil Khemani on 8/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAnnotation :NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *title;
@property(nonatomic,strong) UIImage *image;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end


