//
//  ImageViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewController.h"

@class PickImageViewController;

@protocol PickImageViewControllerDelegate <NSObject>

- (void)addItemViewController:(PickImageViewController *)controller didFinishEnteringItem:(UIImage *)item;

@end

@interface PickImageViewController : UIViewController

@property (nonatomic, strong) UIImage *imageRecievedFromPhotoStream;
@property (nonatomic, weak) id <PickImageViewControllerDelegate> delegate;

//- (IBAction) didTapButton:(id)sender;

@end
