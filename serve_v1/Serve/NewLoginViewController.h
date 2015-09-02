//
//  NewLoginViewController.h
//  Serve
//
//  Created by Prayaas Jain on 8/1/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeRootViewController.h"

@interface NewLoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *appTitleLabel;
@property (nonatomic, strong) UITextField *emailInput;
@property (nonatomic, strong) UITextField *passInput;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *termsLabel;
@property (nonatomic, strong) UILabel *orLabel;
//@property (strong, nonatomic) MyListingsViewController *myListingsViewController;
@property (strong, nonatomic) ServeRootViewController *rootViewController;

- (IBAction)signup:(id)sender;

@end
