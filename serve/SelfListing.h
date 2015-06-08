//
//  ListingItem.h
//  Serve
//
//  Created by Akhil Khemani on 6/1/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SelfListing : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * cuisine;
@property (nonatomic, retain) NSNumber * deleteFromServer;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * serveCount;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * uploadedToServer;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * pickUp;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
