//
//  NewPickUpInfoViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/25/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewSubmitViewController.h"

@interface NewPickUpInfoViewController :  UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) ReviewSubmitViewController *reviewSubmitViewController;

@end

