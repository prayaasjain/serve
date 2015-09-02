//
//  ServeLoginViewController.m
//  Serve
//
//  Created by Akhil Khemani on 7/12/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ServeLoginViewController.h"
#import "MyListingsViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "ServeRootViewController.h"
#import "UIColor+Utils.h"

typedef enum : NSInteger
{
    EmailInputTag = 0,
    PasswordInputTag,
    
} Tags;

static NSString * const emailPlaceholder = @"Email address";
static NSString * const passwordPlaceholder = @"Password (Minimum 6 characters)";

@interface ServeLoginViewController ()

@property (nonatomic, strong) UITextField *emailInput;
@property (nonatomic, strong) UITextField *passInput;
@property (nonatomic, strong) UILabel *promptLabel;
@property (strong, nonatomic) MyListingsViewController *myListingsViewController;
@property (strong, nonatomic) ServeRootViewController *rootViewController;

- (IBAction)signup:(id)sender;

@end

@implementation ServeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 350, 190, 50)];
    self.promptLabel.text = @"Successful signup";
    self.promptLabel.textColor = [UIColor greenColor];
    self.promptLabel.hidden = YES;
    
    self.emailInput = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 320, 35)];
    self.emailInput.backgroundColor = [UIColor whiteColor];
    self.emailInput.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.emailInput.layer.borderWidth = 0.2;
    self.emailInput.layer.cornerRadius =9;
    self.emailInput.text = emailPlaceholder;
    self.emailInput.textColor = [UIColor servetextLabelGrayColor];
    self.emailInput.font = [UIFont systemFontOfSize:11.0f];
    self.emailInput.textAlignment = NSTextAlignmentCenter;
    self.emailInput.delegate =self;
    self.emailInput.tag = EmailInputTag;
    
    self.passInput= [[UITextField alloc]initWithFrame:CGRectMake(20, 145, 320, 35)];
    self.passInput.backgroundColor = [UIColor whiteColor];
    self.passInput.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passInput.layer.borderWidth = 0.2;
    self.passInput.layer.cornerRadius =5;
    self.passInput.text = passwordPlaceholder;
    self.passInput.textColor = [UIColor servetextLabelGrayColor];
    self.passInput.font = [UIFont systemFontOfSize:11.0f];
    self.passInput.textAlignment = NSTextAlignmentCenter;
    self.passInput.delegate =self;
    self.passInput.tag = PasswordInputTag;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 210, 80, 38);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = .2f;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor redColor]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signupButton.frame = CGRectMake(200, 210, 80, 38);
    signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButton.layer.borderWidth = .2f;
    signupButton.layer.cornerRadius = 5;
    [signupButton setTitle:@"Signup" forState:UIControlStateNormal];
    [signupButton.titleLabel setTextColor:[UIColor blueColor]];
    [signupButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *passResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    passResetButton.frame = CGRectMake(215, 170, 140, 38);
    [passResetButton setTitle:@"Forgot your password ?" forState:UIControlStateNormal];
    [passResetButton.titleLabel setTextColor:[UIColor redColor]];
    [passResetButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:9.0]];
    [passResetButton addTarget:self action:@selector(passwordReset:) forControlEvents:UIControlEventTouchUpInside];
     passResetButton.titleLabel.textColor = [UIColor redColor];
    
    
    UIButton *fbsignupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbsignupButton.frame = CGRectMake(170, 300, 80, 38);
    fbsignupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    fbsignupButton.layer.borderWidth = .2f;
    fbsignupButton.layer.cornerRadius = 5;
    [fbsignupButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [fbsignupButton.titleLabel setTextColor:[UIColor blueColor]];
    [fbsignupButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [fbsignupButton addTarget:self action:@selector(loginWithFacebook:) forControlEvents:UIControlEventTouchUpInside];
   
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];

    [self.view addSubview:button];
    [self.view addSubview:signupButton];
    [self.view addSubview:passResetButton];
    [self.view addSubview:self.passInput];
    [self.view addSubview:self.emailInput];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:fbsignupButton];
    

    // Tab the view to dismiss keyboard
    UITapGestureRecognizer *tapViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tapViewGR];
}

//- (void)_loginWithFacebook {
//    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
//    
//    // Login PFUser using Facebook
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];
//}


- (IBAction)loginWithFacebook:(id)sender {
    //NSArray *permissions;
    NSArray *permissions = @[ @"public_profile",@"email",@"user_friends"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        
//        [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                NSLog(@"The user is no longer associated with their Facebook account.");
//            }
//        }];
        
    
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            self.rootViewController = [[ServeRootViewController alloc]init];
            //[self.navigationController pushViewController:self.rootViewController animated:YES];
            [self presentViewController:self.rootViewController animated:YES completion:nil];
        } else {
            NSLog(@"User logged in through Facebook!");
            self.rootViewController = [[ServeRootViewController alloc]init];
            [self presentViewController:self.rootViewController animated:YES completion:nil];
            //[self.navigationController pushViewController:self.rootViewController animated:YES];
        }
        
        if (![PFFacebookUtils isLinkedWithUser:user]) {
            [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissions block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Woohoo, user is linked with Facebook!");
                }
            }];
        }
        
    }];
    
}
- (IBAction)logoutWithFacebook:(id)sender {

    [PFUser logOut];
    
//    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"The user is no longer associated with their Facebook account.");
//        }
//    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField.text isEqualToString:emailPlaceholder]||[textField.text isEqualToString:passwordPlaceholder])
    {
        textField.text = @"";
        textField.textColor = [UIColor redColor];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];
    
    if([self.emailInput.text isEqualToString:@""])
    {
        self.emailInput.text = emailPlaceholder;
        self.emailInput.textColor = [UIColor grayColor];
    }
    
    if([self.passInput.text isEqualToString:@""])
    {
        self.passInput.text = passwordPlaceholder;
        self.passInput.textColor = [UIColor grayColor];
    }
    
    
    
}

- (void)didTapOnView {
    [self.emailInput resignFirstResponder];
    [self.passInput resignFirstResponder];
    
}
- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    
    //this method could be for error code
    //takes error code and constructs message, or maybe takes the whole error userinfo dict.
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [error show];
}

#pragma mark Functional methods

- (IBAction)signup:(id)sender {
    PFUser *pfUser = [PFUser user];
    pfUser.username = self.emailInput.text;
    pfUser.password = self.passInput.text;
    [pfUser setObject:@"AddressLine1" forKey:@"address1"];
    
    __weak typeof(self) weakSelf = self;
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            weakSelf.promptLabel.textColor = [UIColor greenColor];
            weakSelf.promptLabel.text = @"Signup successful!";
            weakSelf.promptLabel.hidden = NO;
            
            self.rootViewController = [[ServeRootViewController alloc]init];
            [self presentViewController:self.rootViewController animated:YES completion:nil];
                                       //:self.rootViewController animated:YES];
            
        } else {
    
            NSLog(@"Error:%@",[error userInfo]);
            [self showErrorWithTitle:@"Error in SignUP" message:[[error userInfo]objectForKey:@"error"] cancelButtonTitle:@"OK"];
            weakSelf.promptLabel.textColor = [UIColor redColor];
            weakSelf.promptLabel.text = [error userInfo][@"error"];
            weakSelf.promptLabel.hidden = NO;
        }
    }];
}
- (IBAction)login:(id)sender {
    __weak typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:self.emailInput.text
                                 password:self.passInput.text
                                    block:^(PFUser *pfUser, NSError *error)
     {
         if (pfUser && !error) {
             
             // Proceed to next screen after successful login.
             weakSelf.promptLabel.textColor = [UIColor greenColor];
             weakSelf.promptLabel.text = @"Login Successful";
             weakSelf.promptLabel.hidden = NO;
             //present the self.listing view controller
             
             self.rootViewController = [[ServeRootViewController alloc]init];
            //[self.navigationController pushViewController:self.self.myListingsViewController animated:YES];
            [self presentViewController:self.rootViewController animated:YES completion:nil];
             
             
         } else {
            
             [self showErrorWithTitle:@"Error in Login" message:[[error userInfo]objectForKey:@"error"] cancelButtonTitle:@"OK"];
             // The login failed. Show error.
             weakSelf.promptLabel.textColor = [UIColor redColor];
             weakSelf.promptLabel.text = [error userInfo][@"error"];
             weakSelf.promptLabel.hidden = NO;
         }
     }];
}
- (IBAction)passwordReset:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [PFUser requestPasswordResetForEmailInBackground:self.emailInput.text
                                               block:^(BOOL succeeded, NSError *error)
     {
         if (succeeded) {
             
             // Proceed to next screen after successful login.
             weakSelf.promptLabel.textColor = [UIColor greenColor];
             weakSelf.promptLabel.text = @"succeeded reset";
             weakSelf.promptLabel.hidden = NO;
             
         } else {
            
             NSLog(@"Error:%@",[error userInfo]);
             // The login failed. Show error.
            [self showErrorWithTitle:@"Error in Password Reset" message:[[error userInfo]objectForKey:@"error"] cancelButtonTitle:@"OK"];
             weakSelf.promptLabel.textColor = [UIColor redColor];
             weakSelf.promptLabel.text = [error userInfo][@"could not reset, invalid email"];
             weakSelf.promptLabel.hidden = NO;
         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 code = 101;
 error = "invalid login parameters";
 
 code = 202;
 error = "username akhilkhemani@gmail.com already taken";
 
 code = 125;
 error = "invalid email address";
 
 */


@end
