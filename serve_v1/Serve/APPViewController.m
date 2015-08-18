//
//  APPViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"
#import "FilterTableViewController.h"
#import "AddressViewController.h"


@interface APPViewController ()

@end

@implementation APPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"food1.jpg"]];
    
    FilterTableViewController *initialViewController = [[FilterTableViewController alloc]init];
    
    NSArray *viewControllers = [NSArray arrayWithObject:imageView1];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (UIImageView *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIImageView *)viewController {
    
    //AddressViewController *initialViewController = [[AddressViewController alloc]init];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"food1.jpg"]];
    
    return imageView1;
    
}

- (UIImageView *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIImageView *)viewController {
    
    //AddressViewController *initialViewController = [[AddressViewController alloc]init];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"food1.jpg"]];
    
    return imageView1;
    
}

//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//
//    AddressViewController *initialViewController = [[AddressViewController alloc]init];
//    
//    return initialViewController;
//    
//}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
