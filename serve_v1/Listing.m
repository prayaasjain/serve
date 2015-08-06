//
//  Listing.m
//  Serve
//
//  Created by Akhil Khemani on 6/24/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "Listing.h"
#import "NSManagedObject+JSON.h"
#import "ServeSyncEngine.h"


@implementation Listing

@dynamic image;
@dynamic updatedAt;
@dynamic createdAt;
@dynamic uploadedToServer;
@dynamic deleteFromServer;
@dynamic zip;
@dynamic type;
@dynamic author;
@dynamic state;
@dynamic pickUp;
@dynamic phone;
@dynamic objectId;
@dynamic name;
@dynamic desc;
@dynamic cuisine;
@dynamic city;
@dynamic address2;
@dynamic address1;
@dynamic longitude;
@dynamic latitude;
@dynamic syncStatus;
@dynamic serveCount;


- (NSDictionary *)JSONToCreateObjectOnServer {

//    if(!self.createdAt)
//    {
//        self.createdAt = [NSDate date];
//    }
//    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"Date", @"__type",
//                          [[ServeSyncEngine sharedEngine] dateStringForAPIUsingDate:self.createdAt], @"iso" , nil];

    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.address1, @"address1",
                                    self.serveCount, @"serveCount",
                                    self.author,@"author",
                                     nil];
    return jsonDictionary;
}

- (NSString*) title {
    return self.name;
}


- (NSString *)subtitle {
    return self.address1;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.latitude doubleValue]; // or self.latitudeValue à la MOGen
    coord.longitude = [self.longitude doubleValue];
    return coord;
}



@end
