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

#import "NewViewController.h"
#import "InboxTableViewController.h"
#import "Listing.h"
#import "ServeSyncEngine.h"

#import "ServeCoreDataController.h"

#import "UIColor+Utils.h"

@interface ServeRootViewController ()<NewViewControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NewViewController *addnewListingVC;
@property (strong, nonatomic) MyListingsViewController *mylistingsViewController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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
    [[UITabBar appearance] setBarTintColor:[UIColor serveBackgroundColor]];
    
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
    InboxTableViewController *inboxTableViewController = [[InboxTableViewController alloc]init];
    AddressViewController *addressViewController = [[AddressViewController alloc]init];
    ReviewSubmitViewController *reviewController = [[ReviewSubmitViewController alloc]init];
    UIViewController *dummyVC = [[UIViewController alloc]init];
    
    UIImage *mylistingsImage = [UIImage imageNamed:@"home.png"];
    UIImage *mylistingsImageSelected = [UIImage imageNamed:@"home_selected.png"];
    mylistingsImage = [mylistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mylistingsImageSelected = [mylistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mylistingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Listings" image:mylistingsImage selectedImage:mylistingsImageSelected];
    
    UIImage *publiclistingsImage = [UIImage imageNamed:@"search.png"];
    UIImage *publiclistingsImageSelected = [UIImage imageNamed:@"search_selected.png"];
    publiclistingsImage = [publiclistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publiclistingsImageSelected = [publiclistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    publicListingViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search Food" image:publiclistingsImage selectedImage:publiclistingsImageSelected];
    
    UIImage *addlistingsImage = [UIImage imageNamed:@"centerButton.png"];
    UIImage *addlistingsImageSelected = [UIImage imageNamed:@"addgreen.png"];
    addlistingsImage = [addlistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addlistingsImageSelected = [addlistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dummyVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Post an Ad" image:addlistingsImage selectedImage:nil];
    dummyVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-15, 0, 15, 0);
    dummyVC.view.tag = 1;
    
    UIImage *inboxImage = [UIImage imageNamed:@"inbox.png"];
    UIImage *inboxImageSelected = [UIImage imageNamed:@"inbox_selected.png"];
    inboxImage = [inboxImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    inboxImageSelected = [inboxImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    inboxTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Messages" image:inboxImage selectedImage:inboxImageSelected];
    
    UIImage *settingsImage = [UIImage imageNamed:@"user.png"];
    UIImage *settingsImageSelected = [UIImage imageNamed:@"user_selected.png"];
    settingsImage = [settingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingsImageSelected = [settingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addressViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage selectedImage:settingsImageSelected];
    
    
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:self.mylistingsViewController];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:publicListingViewController];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:inboxTableViewController];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:addressViewController];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               nil];
    navigationController1.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    //navigationController1.toolbar.translucent = YES ;
    navigationController2.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    navigationController2.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    navigationController3.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    navigationController3.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    navigationController4.navigationBar.barTintColor = [UIColor blackColor];//#007AFF
    navigationController4.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    
    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  navigationController1,
                                  navigationController2,dummyVC,inboxTableViewController,navigationController4, nil];
    
    
    [self.tabBarController setViewControllers:myViewControllers];
    [self.tabBarController setSelectedIndex:0];
    
    self.tabBarController.delegate = self;
    
    [self.view addSubview:self.tabBarController.view];

}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.view.tag == 1)
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

//- (void)newViewController:(NewViewController *)viewController deleteItem:(id<ServeListingProtocol>)item {
//    [self.managedObjectContext performBlockAndWait:^{
//        if ([[item objectId] isEqualToString:@""] || [item objectId] == nil) {
//            [self.managedObjectContext deleteObject:item];
//        } else {
//            [item setSyncStatus:[NSNumber numberWithInt:ServeObjectDeleted]];
//        }
//        NSError *error = nil;
//        BOOL saved = [self.managedObjectContext save:&error];
//        if (!saved) {
//            NSLog(@"Error saving main context: %@", error);
//        }
//        [[ServeCoreDataController sharedInstance] saveMasterContext];
//        
//    }];
//    
//    //[self.homeTable reloadData];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    [self.tabBarController setSelectedIndex:0];
//    [[ServeSyncEngine sharedEngine] startUpSync];
//    
//}

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

@end
