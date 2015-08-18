//
//  NewViewController.h
//  Serve
//
//  Created by Akhil Khemani on 7/15/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeListingProtocol.h"
#import "MyListingsViewController.h"

typedef enum : NSInteger
{
    EditMode = 0,
    CreateMode
    
} Mode;

@class NewViewController;

@protocol NewViewControllerDelegate <NSObject>

- (void)newViewController:(NewViewController *)viewController didSaveItem:(id<ServeListingProtocol>)savedItem;
//- (void)newViewController:(NewViewController *)viewController didCancelItemEdit:(id<ServeListingProtocol>)item;

- (void)newViewController:(NewViewController *)viewController didCancelItemEdit:(id<ServeListingProtocol>)item inMode:(NSInteger)mode;

@end

@interface NewViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) id<NewViewControllerDelegate> delegate;

- (BOOL)shouldPresentPhotoCaptureController;

- (instancetype)initWithExistingItem:(id<ServeListingProtocol>)item;
- (instancetype)initWithNewItem;

@end
