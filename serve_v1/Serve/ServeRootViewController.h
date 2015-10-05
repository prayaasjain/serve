//
//  ServeRootViewController.h
//  Serve
//
//  Created by Akhil Khemani on 8/23/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideoutViewController.h"

@protocol ServeRootViewControllerDelegate <NSObject>

- (void)logOutFlow;

@end

@interface ServeRootViewController : UIViewController<UITabBarControllerDelegate>

@property (weak, nonatomic) id<ServeRootViewControllerDelegate> delegate;

@end
