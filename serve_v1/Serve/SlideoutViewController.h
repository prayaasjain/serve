//
//  NewSlideoutViewController.h
//  Serve
//
//  Created by Akhil Khemani on 8/24/15.
//  Copyright © 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideoutViewControllerDelegate <NSObject>

- (void)didPressLogout;

@end

@interface SlideoutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<SlideoutViewControllerDelegate> delegate;

@end
