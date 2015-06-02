//
//  ListingItem.h
//  Serve
//
//  Created by Akhil Khemani on 6/1/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListingItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * serveCount;
@property (nonatomic, retain) NSString * cuisine;
@property (nonatomic, retain) NSString * desc;

@end
