//
//  NewLoginViewController.m
//  Serve
//
//  Created by Prayaas Jain on 8/1/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "NewLoginViewController.h"
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

@interface NewLoginViewController () {
    UIImageView *backgroundView;
    UIImageView *backgroundView2;
    UIImageView *currentView;
    UIImageView *previousView;
    
    UIButton *createAccountButton;
    UIButton *loginButton;
    NSTimer *backgroundImageTimer;
    
    int imageIndex;
}

@property (nonatomic, strong) NSArray *backgroundImages;

@end

@implementation NewLoginViewController

@synthesize backgroundImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackground];
    [self setupLoginVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark -
#pragma mark UI Update Methods
- (void)setupBackground {
    
    backgroundImages = @[@"loginBG1.jpg",
                         @"loginBG2.jpg",
                         @"loginBG3.jpg",
                         @"loginBG4.jpg"];

    imageIndex = rand() % 4;
    
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    [backgroundView setImage:[UIImage imageNamed:[backgroundImages objectAtIndex:imageIndex]]];
    [backgroundView setAlpha:0.75];
    [self.view addSubview:backgroundView];
    
    backgroundView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [backgroundView2 setBackgroundColor:[UIColor clearColor]];
    [backgroundView2 setImage:[UIImage imageNamed:[backgroundImages objectAtIndex:imageIndex]]];
    [backgroundView2 setAlpha:0.00];
    [self.view addSubview:backgroundView2];
    
    currentView = backgroundView;
    previousView = backgroundView2;
    
    backgroundImageTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(updateBackgroundImage) userInfo:nil repeats:YES];
    
}

- (void)updateBackgroundImage {
    if(imageIndex >= [backgroundImages count]-1)
        imageIndex = 0;
    else
        imageIndex++;
    
    [previousView setImage:[UIImage imageNamed:[backgroundImages objectAtIndex:imageIndex]]];
    [self swapBackgroundViews];
    
    [UIView animateWithDuration:2.0
                     animations:^(void) {
                         [currentView setAlpha:0.75];
                         [previousView setAlpha:0.00];
                     }completion:^(BOOL finished) {

                     }];
}

- (void)swapBackgroundViews {
    UIImageView *temp;
    temp = currentView;
    currentView = previousView;
    previousView = temp;
}



- (void)setupLoginVC
{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 350, 190, 50)];
    self.promptLabel.text = @"Successful signup";
    self.promptLabel.textColor = [UIColor greenColor];
    self.promptLabel.hidden = YES;
    
    self.emailInput = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 320, 50)];
    self.emailInput.backgroundColor = [UIColor whiteColor];
    self.emailInput.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.emailInput.layer.borderWidth = 0.2;
    self.emailInput.layer.cornerRadius = 5;
    self.emailInput.text = emailPlaceholder;
    self.emailInput.textColor = [UIColor servetextLabelGrayColor];
    self.emailInput.font = [UIFont systemFontOfSize:11.0f];
    self.emailInput.textAlignment = NSTextAlignmentCenter;
    self.emailInput.delegate =self;
    self.emailInput.tag = EmailInputTag;
    
    self.passInput= [[UITextField alloc]initWithFrame:CGRectMake(20, 170, 320, 50)];
    self.passInput.backgroundColor = [UIColor whiteColor];
    self.passInput.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passInput.layer.borderWidth = 0.2;
    self.passInput.layer.cornerRadius = 5;
    self.passInput.text = passwordPlaceholder;
    self.passInput.textColor = [UIColor servetextLabelGrayColor];
    self.passInput.font = [UIFont systemFontOfSize:11.0f];
    self.passInput.textAlignment = NSTextAlignmentCenter;
    self.passInput.delegate =self;
    self.passInput.tag = PasswordInputTag;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 245, 110, 48);
    button.backgroundColor = [UIColor serveTransparentColor];
    button.layer.cornerRadius = 5;
    [button setTitle:@"LOGIN" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor serveWhiteTranslucentColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signupButton.frame = CGRectMake(200, 245, 110, 48);
    signupButton.backgroundColor = [UIColor serveTransparentColor];
    [signupButton setTitle:@"SIGNUP" forState:UIControlStateNormal];
    signupButton.layer.cornerRadius = 5;
    [signupButton setTitleColor:[UIColor serveWhiteTranslucentColor] forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [signupButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-bold" size:14.0]];
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
    //[self.view addSubview:fbsignupButton];
    
    
    // Tab the view to dismiss keyboard
    UITapGestureRecognizer *tapViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tapViewGR];

}

- (void)setupLoginButtons {
    
    createAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createAccountButton addTarget:self
                       action:@selector(createAccountButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [createAccountButton setTitle:@"Create an Account" forState:UIControlStateNormal];
    [createAccountButton setEnabled:YES];
//    [createAccountButton.titleLabel setFont:[UIFont fontWithName:AppFont_HelveticaTextbook_Bold size:30]];
    createAccountButton.frame = CGRectMake(397.75, 547.5, 228.5, 54.5);
    [self.view addSubview:createAccountButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self
                       action:@selector(loginButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setEnabled:YES];
//    [loginButton.titleLabel setFont:[UIFont fontWithName:AppFont_HelveticaTextbook_Bold size:30]];
    loginButton.frame = CGRectMake(397.75, 547.5, 228.5, 54.5);
    [self.view addSubview:loginButton];
    
}

- (IBAction)createAccountButtonPressed:(id)sender {
    
}

- (IBAction)loginButtonPressed:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Complete LOGIN control

//- (IBAction)loginWithFacebook:(id)sender {
//    //NSArray *permissions;
//    NSArray *permissions = @[ @"public_profile",@"email",@"user_friends"];
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
//        
//        //        [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
//        //            if (succeeded) {
//        //                NSLog(@"The user is no longer associated with their Facebook account.");
//        //            }
//        //        }];
//        
//        
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//            self.rootViewController = [[ServeRootViewController alloc]init];
//            //[self.navigationController pushViewController:self.rootViewController animated:YES];
//            [self presentViewController:self.rootViewController animated:YES completion:nil];
//        } else {
//            NSLog(@"User logged in through Facebook!");
//            self.rootViewController = [[ServeRootViewController alloc]init];
//            [self presentViewController:self.rootViewController animated:YES completion:nil];
//            //[self.navigationController pushViewController:self.rootViewController animated:YES];
//        }
//        
//        if (![PFFacebookUtils isLinkedWithUser:user]) {
//            [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissions block:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    NSLog(@"Woohoo, user is linked with Facebook!");
//                }
//            }];
//        }
//        
//    }];
//    
//}
//- (IBAction)logoutWithFacebook:(id)sender {
//    
//    [PFUser logOut];
//    
//    //    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
//    //        if (succeeded) {
//    //            NSLog(@"The user is no longer associated with their Facebook account.");
//    //        }
//    //    }];
//}

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

@end
