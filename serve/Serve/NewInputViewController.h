//
//  NewInputViewController.h
//  Serve
//
//  Created by Akhil Khemani on 5/19/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface NewInputViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

- (id)initWithListing:(Listing *)listing;

@end
