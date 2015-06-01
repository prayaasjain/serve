//
//  ReviewSubmitViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface ReviewSubmitViewController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

- (id)initWithListing:(Listing *)listing;

@end
