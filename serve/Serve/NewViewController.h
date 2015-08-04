//
//  NewViewController.h
//  Serve
//
//  Created by Akhil Khemani on 7/15/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

- (BOOL)shouldPresentPhotoCaptureController;

@end
