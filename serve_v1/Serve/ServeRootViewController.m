//
//  ServeRootViewController.m
//  Serve
//
//  Created by Akhil Khemani on 8/23/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ServeRootViewController.h"
#import "MyListingsViewController.h"
#import "ReviewSubmitViewController.h"
#import "NewInputViewController.h"
#import "PublicListingViewController.h"
#import "AddressViewController.h"

#import "InboxViewController.h"
#import "NewViewController.h"
#import "SlideoutViewController.h"
#import "Listing.h"
#import "ServeSyncEngine.h"
#import "ServeCoreDataController.h"
#import "UIColor+Utils.h"
//#import "NewLoginViewController.h"


#define SLIDE_TIMING .25
#define PANEL_OFFSET 100

typedef enum: NSInteger {
    MyListingView = 0,
    PublicListingView,
    NewView,
    addressViewTag,
    slideOutViewTag,
    ReviewSubmitView,
    
} viewTags;

@interface ServeRootViewController ()<NewViewControllerDelegate,SlideoutViewControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NewViewController *addnewListingVC;
@property (strong, nonatomic) MyListingsViewController *mylistingsViewController;
@property (strong, nonatomic) SlideoutViewController *slideViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIView *backgroundOverlayView;
@property (assign, nonatomic) BOOL showingSlideInView;

@end

@implementation ServeRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.managedObjectContext = [[ServeCoreDataController sharedInstance] masterManagedObjectContext];
    [self initTabController];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabController {
    self.tabBarController = [[UITabBarController alloc] init];

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName: [UIColor lightGrayColor],}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor servePrimaryColor],}
                                             forState:UIControlStateSelected];
    
    self.mylistingsViewController = [[MyListingsViewController alloc]init];
    PublicListingViewController *publicListingViewController = [[PublicListingViewController alloc]init];
    UIViewController *dummyVC2 = [[UIViewController alloc]init];
    InboxViewController *addressViewController = [[InboxViewController alloc]init];
    
    ReviewSubmitViewController *reviewController = [[ReviewSubmitViewController alloc]init];
    UIViewController *dummyVC = [[UIViewController alloc]init];
    
    UIImage *mylistingsImage = [UIImage imageNamed:@"home_solid.png"];
    UIImage *mylistingsImageSelected = [UIImage imageNamed:@"home_solid_selected.png"];
    mylistingsImage = [mylistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mylistingsImageSelected = [mylistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mylistingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Listings" image:mylistingsImage selectedImage:mylistingsImageSelected];
    
    UIImage *publiclistingsImage = [UIImage imageNamed:@"search_solid.png"];
    UIImage *publiclistingsImageSelected = [UIImage imageNamed:@"search_solid_selected.png"];
    publiclistingsImage = [publiclistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publiclistingsImageSelected = [publiclistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publicListingViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search Food" image:publiclistingsImage selectedImage:publiclistingsImageSelected];
    
    UIImage *addlistingsImage = [UIImage imageNamed:@"centerButton.png"];
    UIImage *addlistingsImageSelected = [UIImage imageNamed:@"addgreen.png"];
    addlistingsImage = [addlistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addlistingsImageSelected = [addlistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dummyVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Post an Ad" image:addlistingsImage selectedImage:nil];
    dummyVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
    dummyVC.view.tag = NewView;
    
    UIImage *inboxImage = [UIImage imageNamed:@"inbox.png"];
    UIImage *inboxImageSelected = [UIImage imageNamed:@"inbox_selected.png"];
    inboxImage = [inboxImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    inboxImageSelected = [inboxImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addressViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Messages" image:inboxImage selectedImage:inboxImageSelected];
    
    UIImage *settingsImage = [UIImage imageNamed:@"user_solid.png"];
    UIImage *settingsImageSelected = [UIImage imageNamed:@"user_solid_selected.png"];
    settingsImage = [settingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingsImageSelected = [settingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dummyVC2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage selectedImage:settingsImageSelected];
    
    
    UINavigationController *myListingsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mylistingsViewController];
    UINavigationController *publicListingsNavigationController = [[UINavigationController alloc] initWithRootViewController:publicListingViewController];
    UINavigationController *addressViewNavigationController = [[UINavigationController alloc] initWithRootViewController:addressViewController];
    
    myListingsNavigationController.view.tag = MyListingView;
    publicListingsNavigationController.view.tag = PublicListingView;
    addressViewNavigationController.view.tag = addressViewTag;
    dummyVC2.view.tag = slideOutViewTag;
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               nil];
    myListingsNavigationController.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    myListingsNavigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    publicListingsNavigationController.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    publicListingsNavigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    addressViewNavigationController.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    addressViewNavigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    
    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  myListingsNavigationController,
                                  publicListingsNavigationController,dummyVC,addressViewNavigationController,dummyVC2, nil];
    
    
    [self.tabBarController setViewControllers:myViewControllers animated:YES];
    [self.tabBarController setSelectedIndex:0];
    
    self.tabBarController.delegate = self;
    
    [self.view addSubview:self.tabBarController.view];

}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.view.tag == NewView)
    {
        self.addnewListingVC= [[NewViewController alloc] initWithNewItem];
        self.addnewListingVC.view.backgroundColor = [UIColor lightGrayColor];
        self.addnewListingVC.delegate = self;
        UINavigationController *navigationController1 = nil;
        navigationController1 = [[UINavigationController alloc] initWithRootViewController:self.addnewListingVC];
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor servetextLabelGrayColor],NSForegroundColorAttributeName,
                                                   nil];
        navigationController1.navigationBar.barTintColor = [UIColor serveBackgroundColor];//#007AFF
        navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
        [self presentViewController:navigationController1 animated:YES completion:^{}];
        
        return NO;
    }
    
    else if (viewController.view.tag == slideOutViewTag)
    {
        [self addBackgroundOverlay];
        [self slideInPanelFromRight];
        return NO;
    }

    else
    {
        return YES;
    }
    
}

#pragma mark Newviewcontroller delegate callbacks

- (void)newViewController:(NewViewController *)viewController didSaveItem:(id<ServeListingProtocol>)savedItem {
 
    [self.managedObjectContext performBlockAndWait:^
     {
         NSError *error = nil;
         BOOL saved = [self.managedObjectContext save:&error];
         if (!saved) {
             // do some real error handling
             NSLog(@"Could not save Date due to %@", error);
         }
         [[ServeCoreDataController sharedInstance] saveMasterContext];
     }
     ];
    
    //[self.homeTable reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.addnewListingVC = nil;
    
    [self.tabBarController setSelectedIndex:0];
    [[ServeSyncEngine sharedEngine] startUpSync];

    
}

- (void)newViewController:(NewViewController *)viewController didCancelItemEdit:(id<ServeListingProtocol>)item inMode:(NSInteger)mode {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(mode==CreateMode)
    {
        [self.managedObjectContext deleteObject:(Listing*)item];
        [[ServeCoreDataController sharedInstance] saveMasterContext];
    }
    self.addnewListingVC = nil;
    //[self.tabBarController setSelectedIndex:0];
}

- (void)didPressLogout
{
    NSLog(@"Reached Here HAHAH");
    [self slideOutPanelToRight];
}

#pragma mark -
#pragma mark ProfileViewController Manager Methods

- (UIView *)getSlideInViewRight {
    if (_slideViewController == nil) {
  
        self.slideViewController = [[SlideoutViewController alloc] init];
        self.slideViewController.delegate = self;
        
        [self.view addSubview:self.slideViewController.view];
        
        [self addChildViewController:self.slideViewController];
        [_slideViewController didMoveToParentViewController:self];
        
        _slideViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.showingSlideInView = YES;
    
    UIView *view = self.slideViewController.view;
    return view;
}

- (void)slideInPanelFromRight {
    
    
    UIView *childView = [self getSlideInViewRight];
    [self.view bringSubviewToFront:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _slideViewController.view.frame = CGRectMake(0 + self.view.frame.size.width/3, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }
     ];
    
}

- (void)slideOutPanelToRight {
    [self removeBackgroundOverlay];
    [UIView animateWithDuration:SLIDE_TIMING
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _slideViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.showingSlideInView = NO;
                         }
                     }];
}

- (void)addBackgroundOverlay {
    if(_backgroundOverlayView == nil) {
        self.backgroundOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_backgroundOverlayView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
        [self.view addSubview:self.backgroundOverlayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideOutPanelToRight)];
        [self.backgroundOverlayView addGestureRecognizer:tap];
    }
    
    [_backgroundOverlayView setAlpha:0.0];
    [_backgroundOverlayView setHidden:NO];
    
    [self.view bringSubviewToFront:self.backgroundOverlayView];
    
    [UIView animateWithDuration:SLIDE_TIMING
                     animations:^{
                         [_backgroundOverlayView setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
    
}

- (void)removeBackgroundOverlay {
    [UIView animateWithDuration:SLIDE_TIMING
                     animations:^{
                         [_backgroundOverlayView setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [_backgroundOverlayView setHidden:YES];
                     }
     ];
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_backgroundOverlayView addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        if (_showingSlideInView) {
            [self slideOutPanelToRight];
        }
        
        //        UIView *childView = nil;
        //
        //        if(velocity.x > 0) {
        //            if (!_showingSlideInView) {
        //                childView = [self getLeftView];
        //            }
        //        } else {
        //            if (!_showingLeftPanel) {
        //                childView = [self getRightView];
        //            }
        //
        //        }
        //        // make sure the view we're working with is front and center
        //        [self.view sendSubviewToBack:childView];
        //        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        //        if (_showingSlideInView) {
        //            [self slideOutPanelToRight];
        //        }
        //        else {
        //            if (_showingLeftPanel) {
        //                [self movePanelRight];
        //            }  else if (_showingRightPanel) {
        //                [self movePanelLeft];
        //            }
        //        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (_showingSlideInView) {
            [self slideOutPanelToRight];
        }
        
        //        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
        //        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
        //
        //        // allow dragging only in x coordinates by only updating the x coordinate with translation position
        //        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        //        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        //
        //        // if you needed to check for a change in direction, you could use this code to do so
        //        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
        //            // NSLog(@"same direction");
        //        } else {
        //            // NSLog(@"opposite direction");
        //        }
        //        
        //        _preVelocity = velocity;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
