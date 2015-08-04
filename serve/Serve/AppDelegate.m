//
//  AppDelegate.m
//  Serve
//
//  Created by Akhil Khemani on 5/11/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "AppDelegate.h"
#import "InputViewController.h"
#import "EditListingViewController.h"
#import "PickUpInfoViewController.h"
#import "MyListingsViewController.h"
#import "PickImageViewController.h"
#import "ReviewSubmitViewController.h"
#import "NewInputViewController.h"
#import "NewPickUpInfoViewController.h"
#import "PublicListingViewController.h"
#import "FilterTableViewController.h"
#import "MapViewController.h"
#import "NewViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Listing.h"
#import "ServeSyncEngine.h"
#import "Filter.h"
#import "ServeCoreDataController.h"
#import "ServeLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ///google maps
    [GMSServices provideAPIKey:@"AIzaSyDHdTN_gkC_RqUdUQs_CNiaLUK7VDLGbh4"];
    [[ServeSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Listing class]];
    
    [Parse setApplicationId:@"ZFpCdXKc9QoeUeTzFLtvK9JJ5rZd3CeF6FVzHTfW" clientKey:@"KvvKmvSkbajcQluKWEQDwiOpvwB05Ket60RwTBbH"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

        //[PFUser logOut];////just for testing
//        if (![PFUser currentUser]) {
//    
//            ServeLoginViewController *logInViewController = [[ServeLoginViewController alloc]init];
//    
//            self.window.rootViewController = logInViewController;
//    
//            navigationController = [[UINavigationController alloc]
//                                    initWithRootViewController:logInViewController];
//    
//        }
//
//        else
        {
            
//            MyListingsViewController *myListingsViewController = [[MyListingsViewController alloc]init];
//            self.window.rootViewController = myListingsViewController;
//            
//            navigationController = [[UINavigationController alloc]
//                                initWithRootViewController:myListingsViewController];
            
//            PublicListingViewController *myListingsViewController = [[PublicListingViewController alloc]init];
//            //NewViewController *myListingsViewController = [[NewViewController alloc]init];
//            self.window.rootViewController = myListingsViewController;
//            
//            navigationController = [[UINavigationController alloc]
//                                    initWithRootViewController:myListingsViewController];
        }
    
    //
    
        self.tabBarController = [[UITabBarController alloc] init];
        // Change the tab bar background
        [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:48/255.0 blue:92/255.0 alpha:1.0],}
                                             forState:UIControlStateNormal];
    
        [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:138/255.0 blue:196/255.0 alpha:1.0],}
                                             forState:UIControlStateSelected];
    
        MyListingsViewController *myListingsViewController = [[MyListingsViewController alloc]init];
        PublicListingViewController *publicListingViewController = [[PublicListingViewController alloc]init];
        //NewInputViewController *newInputViewController = [[NewInputViewController alloc]init];
        NewViewController *newViewController = [[NewViewController alloc]init];
    
        UIImage *mylistingsImage = [UIImage imageNamed:@"add_list2.png"];
        UIImage *mylistingsImageSelected = [UIImage imageNamed:@"add_list2_selected.png"];
        mylistingsImage = [mylistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mylistingsImageSelected = [mylistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        myListingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Listings" image:mylistingsImage selectedImage:mylistingsImageSelected];
    
        UIImage *publiclistingsImage = [UIImage imageNamed:@"plate_filled.png"];
        UIImage *publiclistingsImageSelected = [UIImage imageNamed:@"plate_filled_selected.png"];
        publiclistingsImage = [publiclistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        publiclistingsImageSelected = [publiclistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        publicListingViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Available Food" image:publiclistingsImage selectedImage:publiclistingsImageSelected];
    
        UIImage *addlistingsImage = [UIImage imageNamed:@"addgreen.png"];
        UIImage *addlistingsImageSelected = [UIImage imageNamed:@"addgreen.png"];
        addlistingsImage = [addlistingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        addlistingsImageSelected = [addlistingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //newInputViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Add Listing" image:addlistingsImage selectedImage:addlistingsImageSelected];
    
        UIImage *settingsImage = [UIImage imageNamed:@"user.png"];
        UIImage *settingsImageSelected = [UIImage imageNamed:@"user_selected.png"];
        settingsImage = [settingsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        settingsImageSelected = [settingsImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        newViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage selectedImage:settingsImageSelected];

        UINavigationController *navigationController1 = nil;
        navigationController1 = [[UINavigationController alloc] initWithRootViewController:myListingsViewController];
   
        UINavigationController *navigationController2 = nil;
        navigationController2 = [[UINavigationController alloc] initWithRootViewController:publicListingViewController];
    
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                   nil];
        navigationController1.navigationBar.barTintColor = [UIColor darkGrayColor];//#007AFF
        navigationController1.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
        navigationController1.toolbar.barTintColor = [UIColor darkGrayColor];
        //navigationController1.toolbar.translucent = YES ;
        navigationController2.navigationBar.barTintColor = [UIColor darkGrayColor];//#007AFF
        navigationController2.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
        navigationController2.toolbar.barTintColor = [UIColor darkGrayColor];
       // navigationController2.toolbar.translucent = YES ;
    
        NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  navigationController1,
                                  navigationController2,newViewController, nil];
    

    
        //set the view controllers for the tab bar controller
        [self.tabBarController setViewControllers:myViewControllers];
        [self.tabBarController setSelectedIndex:0];
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //add the tab bar controllers view to the window
        //[self.window addSubview:self.tabBarController.view];
    
        [self.window setRootViewController:self.tabBarController];

        [self.window makeKeyAndVisible];
    
    //Raised center button for tabbar
//    UIImage *buttonImage = [UIImage imageNamed:@"plate_filled.png"];
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
//    
//    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
//    if (heightDifference < 0)
//        button.center = self.tabBarController.tabBar.center;
//    else
//    {
//        CGPoint center = self.tabBarController.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }
//    
//    [self.window addSubview:button];
    
    
    
    //
    
    
    
//    PickUpInfoViewController *pickUpViewController = [[PickUpInfoViewController alloc]init];
//    InputViewController *inputViewController = [[InputViewController alloc]init];
//    PickImageViewController *imageViewController =[[PickImageViewController alloc]init];
//    ReviewSubmitViewController *reviewSubmitViewController = [[ReviewSubmitViewController alloc]init];
//    NewInputViewController *newInputViewController = [[NewInputViewController alloc]init];
//    NewPickUpInfoViewController *newPickUpinfoViewController = [[NewPickUpInfoViewController alloc]init];
//    PublicListingViewController *publicListingViewController = [[PublicListingViewController alloc]init];
//    FilterTableViewController *filterTableViewController = [[FilterTableViewController alloc]init];
    //self.window.rootViewController = pickUpViewController;
    //self.window.rootViewController = inputViewController;
    //self.window.rootViewController = imageViewController;
    //self.window.rootViewController = reviewSubmitViewController;
    //self.window.rootViewController = newInputViewController;
    //self.window.rootViewController = newPickUpinfoViewController;
    //self.window.rootViewController = publicListingViewController;
    //self.window.rootViewController = filterTableViewController;
    
    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [navigationController.view.layer addAnimation:transition forKey:nil];
//    [navigationController popViewControllerAnimated:NO];

    //self.window.rootViewController = navigationController;
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
    //[[ServeSyncEngine sharedEngine] startSync];
    
    //This should happen only once in a lifecycle
//    NSManagedObjectContext *managedObjectContext;
//    NSManagedObject *filter;
//    managedObjectContext = [[ServeCoreDataController sharedInstance] newManagedObjectContext];
//    filter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter" inManagedObjectContext:managedObjectContext];
//    
//    [filter setValue:[NSNumber numberWithInt:Next5Hrs] forKey:@"availability"];
//    [filter setValue:[NSNumber numberWithInt:Name] forKey:@"sortBy"];
//    [filter setValue:[NSNumber numberWithInt:2] forKey:@"type"];
//    [filter setValue:[NSNumber numberWithInt:10] forKey:@"distance"];
//    
//    [managedObjectContext performBlockAndWait:^
//     {
//         NSError *error = nil;
//         BOOL saved = [managedObjectContext save:&error];
//         if (!saved) {
//             // do some real error handling
//             NSLog(@"Could not save Date due to %@", error);
//         }
//         [[ServeCoreDataController sharedInstance] saveMasterContext];
//     }
//     ];
    

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

//#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Serve.serve.Serve" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Serve" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Serve.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
