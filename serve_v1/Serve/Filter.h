//
//  Filter.h
//  
//
//  Created by Akhil Khemani on 7/3/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Filter : NSManagedObject

@property (nonatomic, retain) NSNumber * availability;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * sortBy;
@property (nonatomic, retain) NSNumber * type;

@end
