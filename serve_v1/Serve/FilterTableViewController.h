//
//  FilterTableViewController.h
//  Serve
//
//  Created by Akhil Khemani on 7/2/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController

typedef enum {
    AllDay = 0,
    RightNow,//1
    Next2Hrs,//2
    Next5Hrs//3
} PickUpAvailabilityOptions;


typedef enum {
    BestMatch = 0,
    Name,//1
    ServeCount,//2
    Distance,//3
} SortOptions;

@end
