//
//  ReviewSubmitViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.∫
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingNavigationData.h"
#import "MyListingsViewController.h"

//@class ReviewSubmitViewController;

@protocol SaveAndSyncDelegate;

@protocol SaveAndSyncDelegate <NSObject>

- (void)saveAndSyncMethod;

@end

@interface ReviewSubmitViewController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,MKMapViewDelegate>

//- (id)initWithListing:(ListingNavigationData *)listing;
//- (void)updateListingWith:(ListingNavigationData *)newListing;

- (id)initWithListing:(id<ServeListingProtocol>)listing;
@property (nonatomic, assign) id<SaveAndSyncDelegate> ssdelegate;

@end
