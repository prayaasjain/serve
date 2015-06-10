//
//  NewInputViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/19/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "NewInputViewController.h"
#import "NewPickUpInfoViewController.h"
#import "PickUpInfoViewController.h"
#import "PickImageViewController.h"

#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen].bounds.size.height]

typedef enum : NSInteger
{
    TitleInputTag = 0,
    ServesInputTag,
    TypeInputTag,
    CusineInputTag,
    DescInputTag,
    AddImageButtonTag,
    ImageBackgroundViewTag,
    CancelButtonTag,
    ContinueButtonTag
    
} Tags;

const CGFloat labelBorderWidth = 0.3f;

static NSString * const titlePlaceholder = @"Title";
static NSString * const cuisinePlaceholder = @"Indian,Chinese etc?";
static NSString * const descriptionPlaceholder = @"Description Text (Optional)";
static NSArray  * addPhotoActionSheetItems = nil;
static NSArray  * cancelButtonActionSheetItems = nil;

const CGFloat labelFontSize = 11.0f;
const int allowedNumberOfCharactersInDesc = 160;
const int allowedNumberOfCharactersInTitle = 10;
const int allowedNumberOfCharactersInCuisine = allowedNumberOfCharactersInTitle;

//for animation
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

//flag for Title Error Message
static const BOOL showtitleCheckError = TRUE;

@interface NewInputViewController ()

@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, strong) UIImageView *addImageBackgroundView;
@property (nonatomic, strong) UIButton *addPhotoActionSheetButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *servesLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *cuisineLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextField *titleInput;
@property (nonatomic, strong) UITextField *servesInput;
@property (nonatomic, strong) UIButton *addServeButton;
@property (nonatomic, strong) UIButton *reduceServeButton;
@property (nonatomic, strong) UIButton *previousTypeButton;
@property (nonatomic, strong) UIButton *nextTypeButton;
@property (nonatomic, strong) UITextField *typeInput;
@property (nonatomic, strong) UITextView *descInput;
@property (nonatomic, strong) UITextField *cuisineInput;
@property (nonatomic, readwrite,assign) NSNumber *numberOfServes;
@property (nonatomic, retain) NSArray* itemTypes;

@property (strong, nonatomic) PickUpInfoViewController *pickUpInfoViewController;
@property (strong, nonatomic) PickImageViewController *pickImageViewController;
@property (strong, nonatomic) ListingNavigationData *currentListing;
@property (nonatomic, strong) UIActionSheet *addPhotoActionSheet;
@property (nonatomic, strong) UIActionSheet *cancelButtonActionSheet;

- (IBAction)continueButtonPressed:(id)sender;
- (void) showActionSheet:(id)sender;
- (IBAction) didTapButton:(id)sender;

@end

@implementation NewInputViewController

- (id)initWithListing:(ListingNavigationData *)_listing {
    
    if(self = [super init]) {
        self.currentListing = _listing;
    }
    
    return self;
}

- (void)updateListingWith:(ListingNavigationData *)_newListing {
    self.currentListing = _newListing;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewControllerObjects];
    [self.view addSubview:self.addImageBackgroundView];
    [self.view addSubview:self.addPhotoActionSheetButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.titleInput];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.descInput];
    [self.view addSubview:self.servesLabel];
    [self.view addSubview:self.servesInput];
    [self.view addSubview:self.addServeButton];
    [self.view addSubview:self.reduceServeButton];
    [self.view addSubview:self.typeLabel];
    [self.view addSubview:self.typeInput];
    [self.view addSubview:self.previousTypeButton];
    [self.view addSubview:self.nextTypeButton];
    [self.view addSubview:self.cuisineLabel];
    [self.view addSubview:self.cuisineInput];
    
    
    [self.view addSubview:self.progressIndicator];
    
    
    [self setUpNavigationController];
    [self setUpConstraints];
    [self setUpActionSheets];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.currentListing = [[ListingNavigationData alloc] init];
}

- (void)setUpViewControllerObjects {
    
    self.progressIndicator = [[UIView alloc]init];
    self.progressIndicator.translatesAutoresizingMaskIntoConstraints=NO;
    self.progressIndicator.layer.borderColor = [UIColor blackColor].CGColor;
    self.progressIndicator.layer.borderWidth = 0.5f;
    //self.progressIndicator.layer.cornerRadius = 120;
    [self.progressIndicator setBackgroundColor:[UIColor lightGrayColor]];
    //    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //    //[step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
    //    [step1Button setTitle:@"1" forState:UIControlStateNormal];
    //    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    //    step1Button.layer.borderWidth=1.0f;
    //    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
    //    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    //    step1Button.layer.cornerRadius = 10;
    //    step1Button.contentEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
    //    [self.progressIndicator addSubview:step1Button];
    
    
    //ADD PHOTO BIG BACKGROUND IMAGE
    self.addImageBackgroundView = [[UIImageView alloc]init];
    self.addImageBackgroundView.image = [UIImage imageNamed:@"food1.jpg"];
    //self.addImageBackgroundView.alpha = 0.6f;
    self.addImageBackgroundView.layer.borderColor = [UIColor blackColor].CGColor;
    self.addImageBackgroundView.layer.borderWidth = 0.5f;
    self.addImageBackgroundView.layer.cornerRadius = 10;
    self.addImageBackgroundView.tag = ImageBackgroundViewTag;
    [self.addImageBackgroundView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActionSheet:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.addImageBackgroundView addGestureRecognizer:singleTap];
    self.addImageBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.addPhotoActionSheetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPhotoActionSheetButton setImage:[UIImage imageNamed:@"camera-2.png"] forState:UIControlStateNormal];
    [self.addPhotoActionSheetButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    //[self.addPhotoActionSheetButton setFrame:CGRectMake(160.0f, 196.0f, 55.0f, 55.0f)];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-20, 55.0f, 90, 20)];
    //    [label setText:@"Add Photo"];
    //    [label setFont:[UIFont systemFontOfSize:11.0f]];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    [label setTextColor:[UIColor whiteColor]];
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [self.addPhotoActionSheetButton addSubview:label];
    self.addPhotoActionSheetButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.addPhotoActionSheetButton.tag = AddImageButtonTag;
    
    self.titleLabel  = [UILabel new];
    [self.titleLabel setText:@"*TITLE:"];
    [self.titleLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.servesLabel  = [UILabel new];
    [self.servesLabel setText:@"*SERVES:"];
    [self.servesLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    self.servesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.typeLabel  = [UILabel new];
    [self.typeLabel setText:@"*TYPE:"];
    [self.typeLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cuisineLabel = [UILabel new];
    [self.cuisineLabel setText:@"*CUISINE:"];
    [self.cuisineLabel setFont:[UIFont systemFontOfSize:labelFontSize]];
    self.cuisineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.descLabel = [UILabel new];
    [self.descLabel setText:@"DESCRIPTION:"];
    [self.descLabel setFont:[UIFont systemFontOfSize:10]];
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.titleInput = [[UITextField alloc]init];
    [self setTextFieldProperties:self.titleInput withPlaceholder:titlePlaceholder withTag:TitleInputTag];
    
    self.cuisineInput = [[UITextField alloc]init];
    [self setTextFieldProperties:self.cuisineInput withPlaceholder:cuisinePlaceholder withTag:CusineInputTag];
    
    self.numberOfServes = [NSNumber numberWithInt:1];
    self.servesInput = [[UITextField alloc]init];
    [self setTextFieldProperties:self.servesInput withPlaceholder:[NSString stringWithFormat:@"%@",self.numberOfServes] withTag:ServesInputTag];
    self.servesInput.textColor = [UIColor redColor];
    self.servesInput.userInteractionEnabled = NO;
    
    self.itemTypes = @[@"Vegetarian",@"Non-Vegetarian"];
    self.typeInput = [[UITextField alloc]init];
    [self setTextFieldProperties:self.typeInput withPlaceholder:[self.itemTypes objectAtIndex:0] withTag:TypeInputTag];
    self.typeInput.userInteractionEnabled = NO;
    self.typeInput.textColor = [UIColor redColor];
    
    self.descInput = [[UITextView alloc]init];
    self.descInput.text = descriptionPlaceholder;
    self.descInput.delegate = self;
    self.descInput.textColor = [UIColor grayColor];
    self.descInput.font = [UIFont systemFontOfSize:labelFontSize];
    self.descInput.textAlignment = NSTextAlignmentCenter;
    self.descInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.descInput.layer.borderWidth = labelBorderWidth;
    self.descInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descInput.layer.cornerRadius = 5;//changed from 15
    self.descInput.clipsToBounds = YES;
    self.descInput.tag = DescInputTag;
    [self.descInput setReturnKeyType:UIReturnKeyDefault];
    [self.descInput setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     self.view.window.frame.size.width,
                                                                     44.0f)];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        toolBar.tintColor = [UIColor colorWithRed:0.6f
    //                                            green:0.6f
    //                                             blue:0.64f
    //                                            alpha:1.0f];
    //    }
    //    else
    //    {
    //        toolBar.tintColor = [UIColor colorWithRed:0.56f
    //                                            green:0.59f
    //                                             blue:0.63f
    //                                            alpha:1.0f];
    //    }
    //    toolBar.translucent = NO;
    toolBar.items =   @[
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                      target:nil
                                                                      action:nil],
                        
                        [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(keyboardDoneButtonPressed:)]
                        ,
                        ];
    
    toolBar.backgroundColor = [UIColor blackColor];
    
    toolBar.alpha = 0.5;
    toolBar.tintColor = [UIColor blackColor];
    toolBar.translucent = YES;
    
    self.descInput.inputAccessoryView = toolBar;
    
    
}

- (UIButton *)addServeButton {
    
    if (!_addServeButton) {
        
        _addServeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage *image = [[UIImage imageNamed:@"add_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_addServeButton addTarget:self action:@selector(incrementServeCount:) forControlEvents:UIControlEventTouchUpInside];
        //[_addServeButton setImage:image forState:UIControlStateNormal];
        [_addServeButton setTitle:@"+" forState:UIControlStateNormal];
        _addServeButton.tintColor = [UIColor redColor];
        self.addServeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _addServeButton;
}

- (UIButton *)reduceServeButton {
    
    if (!_reduceServeButton) {
        
        //_reduceServeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceServeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_reduceServeButton setTitle:@"-" forState:UIControlStateNormal];
        //UIImage *image = [[UIImage imageNamed:@"reduce_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_reduceServeButton addTarget:self action:@selector(decrementServeCount:) forControlEvents:UIControlEventTouchUpInside];
        //[_reduceServeButton setImage:image forState:UIControlStateNormal];
        _reduceServeButton.tintColor = [UIColor redColor];
        self.reduceServeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _reduceServeButton;
}

- (UIButton *)nextTypeButton {
    
    if (!_nextTypeButton) {
        
        _nextTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //UIImage *image = [[UIImage imageNamed:@"previous_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_nextTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
        //[_nextTypeButton setImage:image forState:UIControlStateNormal];
        [_nextTypeButton setTitle:@">" forState:UIControlStateNormal];
        _nextTypeButton.tintColor = [UIColor redColor];
        self.nextTypeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _nextTypeButton;
}

- (UIButton *)previousTypeButton {
    
    if (!_previousTypeButton) {
        _previousTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //UIImage *image = [[UIImage imageNamed:@"trash.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_previousTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
        //[_previousTypeButton setImage:image forState:UIControlStateNormal];
        [_previousTypeButton setTitle:@"<" forState:UIControlStateNormal];
        _previousTypeButton.tintColor = [UIColor redColor];
        self.previousTypeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _previousTypeButton;
}


-(void)setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.toolbarHidden = NO;
    [self.navigationItem setTitle:@"Item Information"];
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    UIBarButtonItem *continueButton = [[UIBarButtonItem alloc]initWithTitle:@"Continue"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(continueButtonPressed:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(showActionSheet:)];
    
    [continueButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [cancelButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    cancelButton.tag = CancelButtonTag;// this has tto be assigned
    
    //create an array of buttons
    NSArray *items = [NSArray arrayWithObjects:cancelButton, itemSpace, continueButton, nil];
    //add the buttons to the toolbar
    self.toolbarItems = items;
    
}

-(void)setUpConstraints {
    
    UIView *superview = self.view;
    
    NSLayoutConstraint *servesLabelTopConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.servesLabel attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual toItem:self.servesInput
                                                    attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *titleLabelTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                   attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *typeLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.typeLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.typeInput
                                                  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *cuisineLabelTopConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.cuisineLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:self.cuisineInput
                                                     attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *descLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.descLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.descInput
                                                  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *titleInputWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.titleInput attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.cuisineInput
                                                     attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *servesInputWidthConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.servesInput attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual toItem:self.cuisineInput
                                                      attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *typeInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.typeInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.cuisineInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *descInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.descInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.cuisineInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *progressViewHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:superview
                                                        attribute:NSLayoutAttributeHeight multiplier:.10 constant:0];
    
    //    NSLayoutConstraint *imageViewHeightConstraint = [NSLayoutConstraint
    //                                                        constraintWithItem:self.addImageBackgroundView attribute:NSLayoutAttributeHeight
    //                                                        relatedBy:NSLayoutRelationEqual toItem:self.addImageBackgroundView
    //                                                        attribute:NSLayoutAttributeWidth multiplier:4.0/3.0 constant:0];
    
    NSLayoutConstraint *addPhotoButtonCenterXConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.addPhotoActionSheetButton attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual toItem:self.addImageBackgroundView attribute:
                                                           NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *addPhotoButtonCenterYConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.addPhotoActionSheetButton attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual toItem:self.addImageBackgroundView attribute:
                                                           NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    
    NSLayoutConstraint *addServeButtonCenterXConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.addServeButton attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual toItem:self.servesInput attribute:
                                                           NSLayoutAttributeRightMargin multiplier:1 constant:0];
    
    NSLayoutConstraint *addServeButtonCenterYConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.addServeButton attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual toItem:self.servesInput attribute:
                                                           NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *reduceServeButtonCenterXConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.reduceServeButton attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual toItem:self.servesInput attribute:
                                                              NSLayoutAttributeLeftMargin multiplier:1 constant:0];
    
    NSLayoutConstraint *reduceServeButtonCenterYConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.reduceServeButton attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual toItem:self.servesInput attribute:
                                                              NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *previousTypeButtonCenterYConstraint = [NSLayoutConstraint
                                                               constraintWithItem:self.previousTypeButton attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual toItem:self.typeInput attribute:
                                                               NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *previousTypeButtonCenterXConstraint = [NSLayoutConstraint
                                                               constraintWithItem:self.previousTypeButton attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual toItem:self.typeInput attribute:
                                                               NSLayoutAttributeLeftMargin multiplier:1 constant:0];
    
    
    NSLayoutConstraint *nextTypeButtonCenterXConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.nextTypeButton attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual toItem:self.typeInput attribute:
                                                           NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *nextTypeButtonCenterYConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.nextTypeButton attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual toItem:self.typeInput attribute:
                                                           NSLayoutAttributeRightMargin multiplier:1 constant:0];
    
    
    
    
    
    
    id views = @{@"progressView":self.progressIndicator,
                 @"imageView": self.addImageBackgroundView,
                 @"titleLabel":self.titleLabel,
                 @"titleInput": self.titleInput,
                 @"servesLabel":self.servesLabel,
                 @"servesInput": self.servesInput,
                 @"typeLabel":self.typeLabel,
                 @"typeInput": self.typeInput,
                 @"cuisineLabel":self.cuisineLabel,
                 @"cuisineInput":self.cuisineInput,
                 @"descLabel":self.descLabel,
                 @"descInput":self.descInput
                 }
    ;
    
    //bottommargin---
    //4s=50
    //5=
    //6=
    //ipad
    
    id metrics = @{@"topmargin": @70, @"bottommargin":@50,@"fieldheight":@25,@"descheight":@160,@"leftMargin":@10,@"rightMargin":@10,@"progressViewHeight":@80};
    
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topmargin-[progressView]-[imageView]-[titleInput(==fieldheight)]-[servesInput(==fieldheight)]-[typeInput(==fieldheight)]-[cuisineInput(==fieldheight)]-[descInput(==descheight)]-bottommargin-|" options:0 metrics:metrics views:views]];
    
    [superview addConstraints:@[titleLabelTopConstraint,typeLabelTopConstraint,servesLabelTopConstraint,cuisineLabelTopConstraint,descLabelTopConstraint,titleInputWidthConstraint,servesInputWidthConstraint,typeInputWidthConstraint,descInputWidthConstraint]];
    
    [superview addConstraints:@[progressViewHeightConstraint]];
    
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[imageView]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[titleLabel]-[titleInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[typeLabel]-[typeInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[servesLabel]-[servesInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[cuisineLabel]-[cuisineInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[descLabel]-[descInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    
    
    [superview addConstraints:@[addPhotoButtonCenterXConstraint,addPhotoButtonCenterYConstraint]];
    [superview addConstraints:@[addServeButtonCenterXConstraint,addServeButtonCenterYConstraint]];
    [superview addConstraints:@[reduceServeButtonCenterXConstraint,reduceServeButtonCenterYConstraint]];
    [superview addConstraints:@[previousTypeButtonCenterXConstraint,previousTypeButtonCenterYConstraint]];
    [superview addConstraints:@[nextTypeButtonCenterXConstraint,nextTypeButtonCenterYConstraint]];
    
}

- (IBAction)incrementServeCount:(id)sender {
    int currentServes = [self.numberOfServes intValue];
    currentServes++;
    self.numberOfServes = [NSNumber numberWithInt:currentServes];
    self.servesInput.text = [NSString stringWithFormat:@"%@",self.numberOfServes];
}

- (IBAction)decrementServeCount:(id)sender {
    if([self.numberOfServes intValue]!=1)
    {
        int currentServes = [self.numberOfServes intValue];
        currentServes--;
        self.numberOfServes = [NSNumber numberWithInt:currentServes];
        self.servesInput.text = [NSString stringWithFormat:@"%@",self.numberOfServes];
    }
}

- (IBAction)toggleItemType:(id)sender {
    if ([self.typeInput.text isEqualToString:[self.itemTypes objectAtIndex:0]])
    {
        self.typeInput.text = [self.itemTypes objectAtIndex:1];
    }
    else
    {
        self.typeInput.text = [self.itemTypes objectAtIndex:0];
    }
}

- (IBAction)continueButtonPressed:(id)sender {
    
    if([self writeDataToListing]) {
        if(self.pickUpInfoViewController == nil){
            //        PickUpInfoViewController *secondView = [[PickUpInfoViewController alloc] init];
            PickUpInfoViewController *secondView = [[PickUpInfoViewController alloc] initWithListing:self.currentListing];
            self.pickUpInfoViewController= secondView;
        }
        else {
            [self.pickUpInfoViewController updateListingWith:self.currentListing];
            //self.pickUpInfoViewController.currentListing = self.currentListing;
        }
        [self.navigationController pushViewController:self.pickUpInfoViewController animated:YES];
    }
    else {
        NSLog(@"Problem in writing data to listing object.");
    }
    
    
}

- (IBAction)keyboardDoneButtonPressed:(id)sender {
    [self.descInput resignFirstResponder];
}

//this is to present uimage picker on tapping the backround image
- (IBAction) didTapButton:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo {
    if(self.pickImageViewController == nil){
        PickImageViewController *secondView = [[PickImageViewController alloc] init];
        self.pickImageViewController= secondView;
    }
    
    self.pickImageViewController.imageRecievedFromPhotoStream = image;
    self.pickImageViewController.delegate = self ;
    
    [self.navigationController pushViewController:self.pickImageViewController animated:YES];
    
    //    self.addImageBackgroundView.image = image;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addItemViewController:(PickImageViewController *)controller didFinishEnteringItem:(UIImage *)imageRecieved {
    //NSLog(@"This was returned from PickImageViewController %@",imageRecieved);
    
    self.addImageBackgroundView.image = imageRecieved;
    self.addImageBackgroundView.alpha = 1 ;
    
}

- (void)setUpActionSheets{
    
    addPhotoActionSheetItems = [[NSArray alloc] initWithObjects:@"Remove Image",
                                @"Take Photo",@"Choose Existing", @"Search Web",@"Cancel", nil];
    
    cancelButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"Are you sure you want to delete the listing?",
                                    @"Discard Listing",@"Cancel", nil];
    
    self.addPhotoActionSheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:[addPhotoActionSheetItems objectAtIndex:4]
                                destructiveButtonTitle:[addPhotoActionSheetItems objectAtIndex:0]
                                otherButtonTitles:[addPhotoActionSheetItems objectAtIndex:1], [addPhotoActionSheetItems objectAtIndex:2], [addPhotoActionSheetItems objectAtIndex:3], nil];
    
    
    self.cancelButtonActionSheet= [[UIActionSheet alloc]initWithTitle:[cancelButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[cancelButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[cancelButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void)showActionSheet:(id)sender {
    
    NSInteger senderTag = [sender tag];
    
    if(senderTag == AddImageButtonTag)
    {
        [self.addPhotoActionSheet showInView:self.view];
    }
    
    if(senderTag == CancelButtonTag)
    {
        [self.cancelButtonActionSheet showInView:self.view];
    }
    
}

- (void)imageActionSheet:(id)sender{
    [self.addPhotoActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Discard Listing"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"Choose Existing"]) {
        
        [self didTapButton:nil];
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

- (void)setTextFieldProperties:(UITextField *)inputView withPlaceholder:(NSString*)placeholder withTag:(NSInteger)tag {
    inputView.text = placeholder;
    inputView.textColor = [UIColor grayColor];
    inputView.font = [UIFont systemFontOfSize:labelFontSize];
    inputView.textAlignment = NSTextAlignmentCenter;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.layer.borderWidth = labelBorderWidth;
    inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    inputView.layer.cornerRadius = 5;
    inputView.clipsToBounds = YES;
    inputView.tag = tag;
    inputView.delegate = self;
    [inputView setReturnKeyType:UIReturnKeyDone];
    [inputView setKeyboardAppearance:UIKeyboardAppearanceDark];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField/ Text View related methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:descriptionPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [self textViewAnimationStart:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [self textViewAnimationEnd];
    [self.descInput resignFirstResponder];
    
    if([self.descInput.text isEqualToString:@""])
    {
        self.descInput.text = descriptionPlaceholder;
        self.descInput.textColor = [UIColor grayColor];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self textViewAnimationStart:textField];
    
    if([textField.text isEqualToString:titlePlaceholder])
    {
        textField.text = @"";
        textField.textColor = [UIColor blackColor];
    }
    else if ([textField.text isEqualToString:cuisinePlaceholder])
    {
        textField.text = @"";
        textField.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textViewAnimationEnd];
    
    if ([textField.text isEqualToString:@""]) {
        
        if(textField.tag == TitleInputTag){
            textField.text = titlePlaceholder;
            textField.textColor = [UIColor grayColor];
        }
        
        else if(textField.tag == CusineInputTag){
            textField.text = cuisinePlaceholder;
            textField.textColor = [UIColor grayColor];
        }
        
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewAnimationStart:(UITextField *)textField {
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textViewAnimationEnd {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    
    switch (textView.tag)
    {
        case DescInputTag:
            return newLength <= allowedNumberOfCharactersInDesc;
            
        default:
            return newLength <= allowedNumberOfCharactersInDesc;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag)
    {
        case TitleInputTag:
            return newLength <= allowedNumberOfCharactersInTitle;
            
        case CusineInputTag:
            return newLength <= allowedNumberOfCharactersInCuisine;
            
        default:
            return newLength <= allowedNumberOfCharactersInCuisine;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // dismiss keyboard through `resignFirstResponder`
    [self.titleInput resignFirstResponder];
    [self.descInput resignFirstResponder];
    [self.cuisineInput resignFirstResponder];
    
}

#pragma mark Alert View for Errors

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [error show];
}

#pragma mark Listing Object Methods

- (BOOL)writeDataToListing {
    
    
    if(showtitleCheckError && (self.titleInput.text.length == 0 || [self.titleInput.text isEqualToString:titlePlaceholder])) {
        [self showErrorWithTitle:@"Incomplete Info" message:@"Please enter a title for your listing." cancelButtonTitle:@"OK"];
        
        return FALSE;
    }
    
    [self.currentListing setTitle:self.titleInput.text];
    [self.currentListing setServeCount:self.numberOfServes];
    [self.currentListing setType:self.typeInput.text];
    
    if(self.cuisineInput.text.length == 0 || [self.cuisineInput.text isEqualToString:cuisinePlaceholder]) {
        [self.currentListing setCuisine:@""];
    }
    else {
        [self.currentListing setCuisine:self.cuisineInput.text];
    }
    
    if(self.descInput.text.length == 0 || [self.descInput.text isEqualToString:descriptionPlaceholder]) {
        [self.currentListing setDesc:@""];
    }
    else {
        [self.currentListing setDesc:self.descInput.text];
    }
    
    [self.currentListing setImage:self.addImageBackgroundView.image];
    [self.currentListing setImageData:[NSData dataWithData:UIImageJPEGRepresentation(self.addImageBackgroundView.image, 1.0)]];
    
    return TRUE;
}

@end


//- (UIView *) progressIndicator {
//
//    //NSLog(@"%f",self.addImageBackgroundView.frame.origin.y);
//
//    _progressIndicator = [[UIView alloc]init];
//    _progressIndicator.backgroundColor = [UIColor yellowColor];
//    _progressIndicator.translatesAutoresizingMaskIntoConstraints=NO;
//
//
//    //_progressIndicator = [[UIView alloc]initWithFrame:CGRectMake(35, 45, 100, 40)];
//
//    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
//    [step1Button setTitle:@"1" forState:UIControlStateNormal];
//    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
//    step1Button.layer.borderWidth=1.0f;
//    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
//    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
//    step1Button.layer.cornerRadius = 10;
//    step1Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
////
////    UILabel *step1Label = [[UILabel alloc]initWithFrame:CGRectMake(_progressIndicator.frame.origin.x, _progressIndicator.frame.origin.y+serveButtonSize, 60, 20)];
////    [step1Label setText:@"Item Details"];
////    [step1Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
////    [step1Label setTextColor:[UIColor redColor]];
////
////
////    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_progressIndicator.frame.origin.x+16+serveButtonSize, _progressIndicator.frame.origin.y+serveButtonSize/2, 75, 1.0f)];
////    lineView1.backgroundColor = [UIColor blackColor];
////
////
////    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    [step2Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16+serveButtonSize+lineView1.frame.size.width,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
////    [step2Button setTitle:@"2" forState:UIControlStateNormal];
////    [step2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    //[part1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
////    step2Button.layer.borderWidth=1.0f;
////    step2Button.layer.borderColor=[[UIColor blackColor] CGColor];
////    step2Button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
////    step2Button.layer.cornerRadius = 10;
////    step2Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
////
////    UILabel *step2Label = [[UILabel alloc]initWithFrame:CGRectMake(step1Label.frame.origin.x+lineView1.frame.size.width+8, _progressIndicator.frame.origin.y+serveButtonSize, 80, 20)];
////    [step2Label setText:@"Pickup Information"];
////    [step2Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
////
////
////    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x+lineView1.frame.size.width+serveButtonSize, _progressIndicator.frame.origin.y+serveButtonSize/2, 75, 1.0f)];
////    lineView2.backgroundColor = [UIColor blackColor];
////
////    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    [step3Button setFrame:CGRectMake(lineView2.frame.origin.x+lineView2.frame.size.width,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
////    [step3Button setTitle:@"3" forState:UIControlStateNormal];
////    [step3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    //[step3Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
////    step3Button.layer.borderWidth=1.0f;
////    step3Button.layer.borderColor=[[UIColor blackColor] CGColor];
////    step3Button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
////    step3Button.layer.cornerRadius = 10;
////    step3Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
////
////    UILabel *step3Label = [[UILabel alloc]initWithFrame:CGRectMake(step2Label.frame.origin.x+lineView2.frame.size.width+26, _progressIndicator.frame.origin.y+serveButtonSize, 80, 20)];
////    [step3Label setText:@"Review/Submit"];
////    [step3Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
////
////    [_progressIndicator addSubview:step1Button];
////    [_progressIndicator addSubview:step1Label];
////    [_progressIndicator addSubview:lineView1];
////    [_progressIndicator addSubview:step2Button];
////    [_progressIndicator addSubview:step2Label];
////    [_progressIndicator addSubview:lineView2];
////    [_progressIndicator addSubview:step3Button];
////    [_progressIndicator addSubview:step3Label];
//
//
//    return _progressIndicator;
//}

