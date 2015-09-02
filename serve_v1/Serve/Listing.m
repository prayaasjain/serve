//
//  Listing.m
//  Serve
//
//  Created by Akhil Khemani on 8/22/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "Listing.h"
#import "NSManagedObject+JSON.h"
#import "ServeSyncEngine.h"
#import "ServeCoreDataController.h"


@implementation Listing

@dynamic address1;
@dynamic address2;
@dynamic author;
@dynamic city;
@dynamic createdAt;
@dynamic cuisine;
@dynamic deleteFromServer;
@dynamic desc;
@dynamic image;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic objectId;
@dynamic phone;
@dynamic pickUp;
@dynamic serveCount;
@dynamic state;
@dynamic syncStatus;
@dynamic type;
@dynamic updatedAt;
@dynamic uploadedToServer;
@dynamic zip;
@dynamic image2;
@dynamic image3;
@dynamic image4;

@synthesize coordinate;

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
                                    //self.image,@"image",
                                    self.type,@"type",
                                    nil];
    return jsonDictionary;
    
    
    
}

- (NSString*) title {
    return self.name;
}

- (NSString *) subtitle {
    return self.objectId;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.latitude doubleValue]; // or self.latitudeValue à la MOGen
    coord.longitude = [self.longitude doubleValue];
    NSLog(@"Akhil");
    
    //coordinate = coord;
    
    return coord;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    
    coordinate = newCoordinate;
    
    NSLog(@"Prayaas ");
}

+ (NSString *)objectId {
    return self.objectId;
}

//-(void)setTitle:(NSString *)name {
//    self.name = name;
//}


+ (id<ServeListingProtocol>)createNewListinginContext:(NSManagedObjectContext *)context
{
    Listing *newItem = nil;
    
    newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Listing" inManagedObjectContext:context];
    
    if (newItem)
    {
        //newItem.image = [UIImage imageNamed:@"food1-gray.jpg"];
        newItem.author = @"Akhil";
        newItem.uploadedToServer = [NSNumber numberWithBool:NO];
        newItem.deleteFromServer = [NSNumber numberWithBool:NO];
        newItem.type = 0;
        newItem.desc = @"";
        newItem.serveCount = [NSNumber numberWithInt:2];
        newItem.syncStatus = [NSNumber numberWithInt:ServeObjectCreated];
        
        NSUUID  *UUID = [NSUUID UUID];
        NSString* stringUUID = [UUID UUIDString];
        [newItem setObjectId:stringUUID];
    }
    
    return newItem;
}

@end
