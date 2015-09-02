//
//  NewLoginViewController.m
//  Serve
//
//  Created by Prayaas Jain on 8/1/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "NewLoginViewController.h"

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

- (void)setupConstraints {
    UIView *superview = self.view;
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
