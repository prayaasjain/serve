//
//  PickUpInfoViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewSubmitViewController.h"
#import "ListingNavigationData.h"

@interface PickUpInfoViewController : UIViewController<UIActionSheetDelegate>

@property (strong, nonatomic) ReviewSubmitViewController *reviewSubmitViewController;

- (id)initWithListing:(ListingNavigationData *)listing;
- (void)updateListingWith:(ListingNavigationData *)newListing;

@end
