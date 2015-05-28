//
//  ReviewSubmitViewController.m
//  Serve Akhil
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ReviewSubmitViewController.h"
#import <GoogleMaps/GoogleMaps.h>

const CGFloat reviewProgressButtonSize = 19.0f;
const CGFloat reviewProgressButtonY = 365.0f;
const CGFloat reviewProgressButtonX = 80.0f;
const CGFloat reviewProgressButtonInset = -2.0f;
const CGFloat reviewProgressIndicatorTextSize = 9.0f;

//const CGFloat imageViewHeight = 160.0f;
//const CGFloat formRightMargin = -15.0f;
//const CGFloat formLeftMargin = 15.0f;
//const CGFloat formTopMargin = 160.0f;
//const CGFloat formItemHeight = 30.0f;
//const CGFloat formItemToItemOffset = 20.0f;
//const CGFloat formLabelToFieldOffset = 10.0f;
//const CGFloat formFieldHeight = 20.0f;
//static NSString * const titlePlaceholder = @"Title";

static NSArray *deleteButtonActionSheetItems = nil;
const CGFloat reviewDeleteButtonTag = 1;

@interface ReviewSubmitViewController ()

@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, strong) UIActionSheet *deleteButtonActionSheet;


//starting fresh
@property (nonatomic, strong) UIImageView *addImageBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *titleInput;
@property (nonatomic, strong) UIButton *addPhotoActionSheetButton;
@property (nonatomic, strong) UITextView *descriptionInput;
@property (nonatomic, readwrite,assign) NSInteger numberOfServes;
@property (nonatomic, strong) UITextField *servesInput;
@property (nonatomic, strong) UITextField *typeInput;
@property (nonatomic, strong) UITextField *cuisineInput;
@property (nonatomic, retain) NSArray* itemTypes;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)showActionSheet:(id)sender;

@end

@implementation ReviewSubmitViewController

 GMSMapView *mapView_;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CLLocationCoordinate2D center;
    center=[self getLocationFromAddressString:@"1235,wildwood ave,sunnyvale,california"];
    double  latitude=center.latitude;
    double  longitude=center.longitude;
    [self displayMapwithLatitude:latitude Longitude:longitude];
    //NSMutableArray *array = [NSMutableArray arrayWithObjects:@"12.981902,80.266333",@"12.982902,80.266363", nil];
    
    
    [self setUpActionSheets];
    [self setUpNavigationController];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mapView_];

}

- (void)displayMapwithLatitude:(double)latitude Longitude:(double)longitude {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:17];
    CGRect frame = CGRectMake(50, 200, 300, 300);
    
    mapView_ = [GMSMapView mapWithFrame:frame camera:camera];
    mapView_.myLocationEnabled = YES;
    //self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude+.001, longitude+.001);
    marker.title = @"My";
    marker.snippet = @"Location";
    marker.map = mapView_;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    
    ///
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker2.title = @"Your Listing";
    marker2.snippet = @"Location";
    marker2.map = mapView_;
    
    marker2.appearAnimation = kGMSMarkerAnimationPop;
    //marker2.icon = [UIImage imageNamed:@"trash.png"];

}

- (CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}

- (UIView *)progressIndicator {
    
    _progressIndicator = [[UIView alloc]initWithFrame:CGRectMake(35, 45, 100, 40)];
    
    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step1Button setTitle:@"1" forState:UIControlStateNormal];
    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step1Button.layer.borderWidth=1.0f;
    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step1Button.layer.cornerRadius = 10;
    step1Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step1Label = [[UILabel alloc]initWithFrame:CGRectMake(_progressIndicator.frame.origin.x, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 60, 20)];
    [step1Label setText:@"Item Details"];
    [step1Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_progressIndicator.frame.origin.x+16+reviewProgressButtonSize, _progressIndicator.frame.origin.y+reviewProgressButtonSize/2, 75, 1.0f)];
    lineView1.backgroundColor = [UIColor blackColor];
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step2Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16+reviewProgressButtonSize+lineView1.frame.size.width,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[part1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step2Button.layer.borderWidth=1.0f;
    step2Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step2Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step2Button.layer.cornerRadius = 10;
    step2Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step2Label = [[UILabel alloc]initWithFrame:CGRectMake(step1Label.frame.origin.x+lineView1.frame.size.width+8, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 80, 20)];
    [step2Label setText:@"Pickup Information"];
    [step2Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
   
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x+lineView1.frame.size.width+reviewProgressButtonSize, _progressIndicator.frame.origin.y+reviewProgressButtonSize/2, 75, 2.0f)];
    lineView2.backgroundColor = [UIColor blackColor];
    
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step3Button setFrame:CGRectMake(lineView2.frame.origin.x+lineView2.frame.size.width,_progressIndicator.frame.origin.y,reviewProgressButtonSize, reviewProgressButtonSize)];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [step3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step3Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step3Button.layer.borderWidth=1.0f;
    step3Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step3Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step3Button.layer.cornerRadius = 10;
    step3Button.contentEdgeInsets = UIEdgeInsetsMake(reviewProgressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step3Label = [[UILabel alloc]initWithFrame:CGRectMake(step2Label.frame.origin.x+lineView2.frame.size.width+26, _progressIndicator.frame.origin.y+reviewProgressButtonSize, 80, 20)];
    [step3Label setText:@"Review/Submit"];
    [step3Label setFont:[UIFont systemFontOfSize:reviewProgressIndicatorTextSize]];
    [step3Label setTextColor:[UIColor redColor]];
    
    [_progressIndicator addSubview:step1Button];
    [_progressIndicator addSubview:step1Label];
    [_progressIndicator addSubview:lineView1];
    [_progressIndicator addSubview:step2Button];
    [_progressIndicator addSubview:step2Label];
    [_progressIndicator addSubview:lineView2];
    [_progressIndicator addSubview:step3Button];
    [_progressIndicator addSubview:step3Label];
    
    return _progressIndicator;
}

- (void) setUpNavigationController {
    [self.navigationItem setTitle:@"Review & Submit"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backButtonPressed:)];
    
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Submit"
                                     style: UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(submitButtonPressed:)];
    
    //trash button
    UIImage *trashImage = [UIImage imageNamed:@"trash.png"];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:trashImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, trashImage.size.width, trashImage.size.height)];
    button.tag = reviewDeleteButtonTag;
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    /////
    
    ///setting color of back and continue buttons to black
    [submitButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [backButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    ////////////////////////////////////////////////////////////
    
    NSArray *items = [NSArray arrayWithObjects:backButton, itemSpace, trashButton, itemSpace, submitButton, nil];
    self.toolbarItems = items;
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender {
    NSLog(@"Trying to submit");
}

- (void) setUpActionSheets {
    
    deleteButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"Are you sure you want to delete the listing?",
                                    @"Discard Listing",@"Cancel", nil];
    
    self.deleteButtonActionSheet= [[UIActionSheet alloc]initWithTitle:[deleteButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[deleteButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[deleteButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void) showActionSheet:(id)sender {
    NSInteger senderTag = [sender tag];
    
    if(senderTag == reviewDeleteButtonTag)
    {
        [self.deleteButtonActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Discard Listing"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"Other Button 1"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Other Button 2"]) {
        NSLog(@"Other 2 pressed");
    }
    if ([buttonTitle isEqualToString:@"Other Button 3"]) {
        NSLog(@"Other 3 pressed");
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
