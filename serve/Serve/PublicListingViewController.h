//
//  PublicListingViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/16/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicListingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *serverItems;

@end
