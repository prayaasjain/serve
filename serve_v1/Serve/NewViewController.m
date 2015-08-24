//
//  NewViewController.m
//  Serve
//
//  Created by Akhil Khemani on 7/15/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//
//this view controller handles image select/capture

#import "NewViewController.h"
#import "TypeField.h"
#import "ImageField.h"
#import "UIColor+Utils.h"
#import "ServeListingProtocol.h"
#import "Listing.h"
#import "ServeCoreDataController.h"

#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen].bounds.size.height]

typedef enum : NSInteger
{
    TitleInputTag = 0,
    ServesInputTag,
    TypeInputTag,
    DescInputTag,
    AddImageButtonTag,
    ImageBackgroundViewTag,
    CancelButtonTag,
    ContinueButtonTag
    
} Tags;

const CGFloat labelBorderWidth = .5f;

static NSString * const titlePlaceholder = @"Name of the item";
static NSString * const descriptionPlaceholder = @"Description Text (Optional)";
static NSArray  * addPhotoActionSheetItems = nil;
static NSArray  * cancelButtonActionSheetItems = nil;

const CGFloat labelFontSize = 11.0f;
const int allowedNumberOfCharactersInDesc = 160;
const int allowedNumberOfCharactersInTitle = 10;

@interface NewViewController ()

@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TypeField  *typeField;
@property (nonatomic, strong) ImageField *imageField;
@property (nonatomic ,strong) UITableView* homeTable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *servesLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextField *titleInput;
@property (nonatomic, strong) UIButton *deleteField;
@property (nonatomic, strong) UITextView *addressInput;
@property (nonatomic, strong) UIButton *addServeButton;
@property (nonatomic, strong) UIButton *reduceServeButton;
@property (nonatomic, strong) UITextView *descInput;
@property (nonatomic, readwrite,assign) NSNumber *numberOfServes;
@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) UIView *selectorView;
@property (nonatomic, retain) NSArray* pickerViewArray;
@property (nonatomic, assign) int serveCount;
@property (nonatomic, assign) BOOL pickerSelectionIndicatorInstalled;
@property (nonatomic, strong) UIView *submitView;
@property (nonatomic, retain) NSMutableArray* imageArray;

@property (nonatomic, strong) UIView *lockOverlayView;
@property (nonatomic,assign)  NSInteger currentMode;
@property (nonatomic, strong) UIButton *editButton;




//@property (strong, nonatomic) id<ServeListingProtocol> listingItem;

@property(nonatomic ,strong) id <ServeListingProtocol> listingItem;

- (void) showActionSheet:(id)sender;

@end

@implementation NewViewController

@synthesize myPickerView;
@synthesize typeField;
@synthesize listingItem = _listingItem;

//
//- (instancetype)initWithNewItem {
//    
//    id<ServeListingProtocol>newItem = [Listing createNewListinginContext:[[ServeCoreDataController sharedInstance] masterManagedObjectContext]];
//    
//    return [self initWithExistingItem:newItem];
//}
//
//- (instancetype)initWithExistingItem:(id<ServeListingProtocol>)item {
//    
//    if (self = [super initWithNibName:nil bundle:nil]) {
//        
//        self.listingItem = item;
//    }
//    
//    return self;
//}


- (instancetype)initWithNewItem {
    
    if (self = [super initWithNibName:nil bundle:nil])
    {
        id<ServeListingProtocol>newItem = [Listing createNewListinginContext:[[ServeCoreDataController sharedInstance] masterManagedObjectContext]];
        
        self.listingItem = newItem;
        self.currentMode = CreateMode;
    }
    
    return self;
}

- (instancetype)initWithExistingItem:(id<ServeListingProtocol>)item {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        self.listingItem = item;
        self.currentMode = EditMode;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    self.lockOverlayView = [[UIView alloc]init];
    self.lockOverlayView.backgroundColor = [UIColor blackColor];
    self.lockOverlayView.alpha = 0.1;
    self.lockOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setUpNavigationController];
    [self setUpViewControllerObjects];

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.submitView];
    [self.scrollView addSubview:self.imageField];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.titleInput];
    [self.scrollView addSubview:self.descLabel];
    [self.scrollView addSubview:self.descInput];
    [self.scrollView addSubview:self.servesLabel];
    [self.scrollView addSubview:self.typeLabel];
    [self.scrollView addSubview:self.myPickerView];
    [self.scrollView addSubview:self.typeField];
    [self.scrollView addSubview:self.selectorView];
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.addressInput];
    
    
    [self.scrollView addSubview:self.lockOverlayView];
    [self.scrollView addSubview:self.deleteField];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setUpConstraints];
     self.titleInput.layer.cornerRadius = 5;
     self.submitView.layer.cornerRadius = 5;
     self.addressInput.layer.cornerRadius = 5;
}

- (void)setUpViewControllerObjects {
    
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor serveBackgroundColor];
    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.descInput.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    
    self.titleLabel  = [UILabel new];
    self.titleLabel.textColor = [UIColor servetextLabelGrayColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.servesLabel  = [UILabel new];
    self.servesLabel.textColor = [UIColor servetextLabelGrayColor];
    self.servesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.typeLabel  = [UILabel new];
    self.typeLabel.textColor = [UIColor servetextLabelGrayColor];
    self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.descLabel = [UILabel new];
    self.descLabel.textColor = [UIColor servetextLabelGrayColor];
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.addressLabel  = [UILabel new];
    self.addressLabel.textColor = [UIColor servetextLabelGrayColor];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.titleInput = [[UITextField alloc]init];
    [self.titleInput setBackgroundColor:[UIColor whiteColor]];
    [self setTextFieldProperties:self.titleInput withPlaceholder:titlePlaceholder withTag:TitleInputTag];
    //self.titleInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    //[clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.addressInput.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    //[self.addressInput setRightView:clearButton];
   
    self.addressInput = [[UITextView alloc]init];
    [self.addressInput setBackgroundColor:[UIColor whiteColor]];
    self.addressInput.textColor = [UIColor lightGrayColor];
    self.addressInput.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    self.addressInput.textAlignment = NSTextAlignmentCenter;
    self.addressInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressInput.layer.cornerRadius = 0;
    self.addressInput.clipsToBounds = YES;
    self.addressInput.delegate = self;
    //self.addressInput.editable = NO;
    self.addressInput.contentInset = UIEdgeInsetsMake(5, 5, 10, 10);
    UITapGestureRecognizer *addresstap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressInputTapped:)];
    [self.addressInput addGestureRecognizer:addresstap];
    [self.addressInput setEditable:NO];
    [self.addressInput setUserInteractionEnabled:YES];
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
    //[clearButton setFrame:CGRectMake(250, 50, 20, 20)];
    arrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.addressInput addSubview:arrowButton];
    NSLayoutConstraint *arrowButtonLeftConstraint = [NSLayoutConstraint
                                                        constraintWithItem:arrowButton attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual toItem:self.addressInput
                                                      attribute:NSLayoutAttributeRight multiplier:1.0 constant:-16];
    NSLayoutConstraint *arrowButtonCenterYConstraint = [NSLayoutConstraint
                                                        constraintWithItem:arrowButton attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.addressInput
                                                        attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.addressInput addConstraints:@[arrowButtonLeftConstraint,arrowButtonCenterYConstraint]];

    
    
    
    
    
    
    self.descInput = [[UITextView alloc]init];
    self.descInput.text = descriptionPlaceholder;
    self.descInput.delegate = self;
    self.descInput.textColor = [UIColor lightGrayColor];
    self.descInput.textAlignment = NSTextAlignmentCenter;
    self.descInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.descInput.layer.cornerRadius = 5;//changed from 15
    self.descInput.clipsToBounds = YES;
    self.descInput.tag = DescInputTag;
    [self.descInput setReturnKeyType:UIReturnKeyDefault];
    [self.descInput setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self.titleLabel setText:@"TITLE"];
    [self.servesLabel setText:@"SERVES"];
    [self.typeLabel setText:@"TYPE"];
    [self.descLabel setText:@"DESCRIPTION"];
    [self.addressLabel setText:@"ADDRESS"];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self.servesLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self.typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self.descLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self.addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     self.view.window.frame.size.width,
                                                                     44.0f)];
    
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
    
    
    self.submitView = [[UIView alloc]initWithFrame:CGRectZero];
    self.submitView.backgroundColor = [UIColor servePrimaryColor];
    self.submitView.translatesAutoresizingMaskIntoConstraints  = NO;
    UILabel *submitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    submitLabel.text = @"SUBMIT";
    [submitLabel setTextColor:[UIColor whiteColor]];
    [submitLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0]];
    [self.submitView addSubview:submitLabel];
    submitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *submitLabelCenterXConstraint = [NSLayoutConstraint
                                                      constraintWithItem:submitLabel attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:self.submitView
                                                      attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *submitLabelCenterYConstraint = [NSLayoutConstraint
                                                        constraintWithItem:submitLabel attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual toItem:self.submitView
                                                        attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [self.submitView addConstraints:@[submitLabelCenterXConstraint,submitLabelCenterYConstraint]];
    UITapGestureRecognizer *submitTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitButtonPressed:)];
    [self.submitView addGestureRecognizer:submitTap];
    
    
    self.typeField = [[TypeField alloc]initWithFrame:CGRectZero];
    [self.typeField.imageTwo setTag:nonveg];
    [self.typeField.imageOne setTag:veg];
    [self.typeField.imageTwo setUserInteractionEnabled:YES];
    [self.typeField.imageOne setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeSelection:)];
    [singleTap setNumberOfTapsRequired:1];
    UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeSelection:)];
    [singleTap2 setNumberOfTapsRequired:1];
    [self.typeField.imageOne addGestureRecognizer:singleTap];
    [self.typeField.imageTwo addGestureRecognizer:singleTap2];
    self.typeField.backgroundColor = [UIColor whiteColor];
    self.typeField.translatesAutoresizingMaskIntoConstraints  = NO;
    
    self.deleteField = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.deleteField.layer.borderWidth = .5f;
    self.deleteField.layer.cornerRadius = 5;
    [self.deleteField setTitle:@"DEACTIVATE LISTING" forState:UIControlStateNormal];
    [self.deleteField setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.deleteField setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.deleteField.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
     self.deleteField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.deleteField addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[self.deleteField setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
 
    self.serveCount = 1;
    self.pickerSelectionIndicatorInstalled = nil;
    self.pickerViewArray = [NSArray arrayWithObjects:
                            @"1", @"2", @"3",
                            @"4", @"5", @"6", @"7",@"8",@"9",@"10",@">",
                            nil];
    //self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    self.myPickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    self.myPickerView.delegate = self;
    self.myPickerView.backgroundColor = [UIColor whiteColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [self.myPickerView setTransform:rotate];
    self.myPickerView.dataSource = self;
    self.myPickerView.translatesAutoresizingMaskIntoConstraints  = NO;
    
    self.selectorView = [[UIView alloc]initWithFrame:CGRectZero];
    self.selectorView.layer.borderColor = [[UIColor servePrimaryColor] CGColor];
    self.selectorView.layer.borderWidth = 1.0f;
    self.selectorView.layer.cornerRadius = 25.0f;
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.imageArray = [[NSMutableArray alloc]init];
    if(self.currentMode == CreateMode)
    {
        self.descInput.text = descriptionPlaceholder;
        self.titleInput.text = titlePlaceholder;
        self.addressInput.text = @"1235,Wildwood Ave,Sunnyvale, CA-94089";
        [self.lockOverlayView setHidden:YES];
        //make delete button invisible
        [self.editButton setHidden:YES];
        [self.deleteField setHidden:YES];
    }
    else
    {
        self.titleInput.text = [self.listingItem name];
        self.descInput.text = [self.listingItem desc];
        self.addressInput.text = [self.listingItem address1];
        NSInteger pickerRow = [[self.listingItem serveCount] integerValue] -1;
        [self.myPickerView selectRow:pickerRow inComponent:0 animated:NO];
        [self prepareImageArrayForEditMode];
        [self.submitView setHidden:YES];
    }
    
    self.imageField= [[ImageField alloc]initWithFrame:CGRectZero andImages:self.imageArray];
    self.imageField.backgroundColor = [UIColor whiteColor];
    self.imageField.translatesAutoresizingMaskIntoConstraints  = NO;
    
    UITapGestureRecognizer *imageOneTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    UITapGestureRecognizer *imageTwoTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    UITapGestureRecognizer *imageThreeTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    UITapGestureRecognizer *imageFourTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    UITapGestureRecognizer *initialTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    
    [self.imageField.imageOne addGestureRecognizer:imageOneTap];
    [self.imageField.imageTwo addGestureRecognizer:imageTwoTap];
    [self.imageField.imageThree addGestureRecognizer:imageThreeTap];
    [self.imageField.imageFour addGestureRecognizer:imageFourTap];
    [self.imageField.initialView addGestureRecognizer:initialTap];
    
    
}


-(void)prepareImageArrayForEditMode
{
    if(self.listingItem.image) {
        [self.imageArray addObject:[UIImage imageWithData:self.listingItem.image]];
    
        if(self.listingItem.image2) {
            [self.imageArray addObject:[UIImage imageWithData:self.listingItem.image2]];
        
            if(self.listingItem.image3) {
                [self.imageArray addObject:[UIImage imageWithData:self.listingItem.image3]];
                
                if(self.listingItem.image4) {
                    [self.imageArray addObject:[UIImage imageWithData:self.listingItem.image4]];
                }
            }
        }
    }
}


- (void)setUpNavigationController {
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"New Post"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 28);
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    
    
    if(self.currentMode == EditMode){
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 70, 20);
    [self.editButton setTitleColor:[UIColor servePrimaryColor] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.editButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [self.editButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setImage: [UIImage imageNamed:@"lock_b.png"] forState:UIControlStateNormal];
    [self.editButton setImage: [UIImage imageNamed:@"unlock_b.png"] forState:UIControlStateDisabled];
        
    [self.editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.navigationItem.rightBarButtonItem = editBarButton;
    }
    
 
    
    
}

- (void)setUpConstraints{
    id views = @{@"imageField":self.imageField,
                 @"selectorView":self.selectorView,
                 @"pickerView":self.myPickerView,
                 @"typeField":self.typeField,
                 @"scrollView":self.scrollView,
                 @"titleLabel":self.titleLabel,
                 @"titleInput": self.titleInput,
                 @"servesLabel":self.servesLabel,
                 @"typeLabel":self.typeLabel,
                 @"descLabel":self.descLabel,
                 @"descInput":self.descInput,
                 @"addressLabel":self.addressLabel,
                 @"addressInput":self.addressInput,
                 @"lockOverlay":self.lockOverlayView,
                 @"deleteField":self.deleteField
                 }
    ;
    
    //@"imageView":self.imageView,
    id metrics = @{@"topMargin": @40, @"bottomMargin":@100,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@10,@"fieldSpacing":@40};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lockOverlay]|" options:0 metrics: metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lockOverlay]|" options:0 metrics: metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageField]|" options:0 metrics:metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[typeField]-leftMargin-|" options:0 metrics:metrics views:views]];

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageField]-fieldSpacing-[titleLabel]-[titleInput]-fieldSpacing-[descLabel]-[descInput]-fieldSpacing-[typeLabel]-[typeField]-fieldSpacing-[servesLabel]-[pickerView]-fieldSpacing-[addressLabel]-[addressInput]-fieldSpacing-[deleteField]|" options:0 metrics: metrics views:views]];
    
    NSLayoutConstraint *titleInputWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.titleInput attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                     attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0];
    
    NSLayoutConstraint *titleInputCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.titleInput attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *addressInputWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.addressInput attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                     attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0];
    
    NSLayoutConstraint *descInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.descInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *titleInputHeightConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.titleInput attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                      attribute:NSLayoutAttributeHeight multiplier:.10 constant:0];
    
    NSLayoutConstraint *addressInputHeightConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.addressInput attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                      attribute:NSLayoutAttributeHeight multiplier:.10 constant:0];
    
    
    NSLayoutConstraint *descInputHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.descInput attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                     attribute:NSLayoutAttributeHeight multiplier:.20 constant:0];
    
    NSLayoutConstraint *descInputCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.descInput attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pickerWidthConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.myPickerView attribute:NSLayoutAttributeWidth
                                                 relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pickerHeightConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.myPickerView attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                  attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    NSLayoutConstraint *pickerCenterXConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.myPickerView attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                  attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    
    NSLayoutConstraint *typeFieldWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.typeField attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *typeFieldHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.typeField attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                     attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *imageFieldWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.imageField attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                     attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *imageFieldHeightConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.imageField attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                      attribute:NSLayoutAttributeHeight multiplier:2 constant:0];
    
    NSLayoutConstraint *selectorViewCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectorView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.myPickerView
                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *selectorViewCenterYConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectorView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual toItem:self.myPickerView
                                                         attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *selectorViewWidthConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.selectorView attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual toItem:nil
                                                       attribute:NSLayoutAttributeWidth multiplier:1 constant:50.0];
    
    NSLayoutConstraint *selectorViewHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.selectorView attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:nil
                                                        attribute:NSLayoutAttributeHeight multiplier:1 constant:50.0];
    
    NSLayoutConstraint *titleLabelCenterXConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                       attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *addressLabelCenterXConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.addressLabel attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                       attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *addressInputCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.addressInput attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *typeLabelCenterXConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.typeLabel attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                      attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *servesLabelCenterXConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.servesLabel attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                        attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *descLabelCenterXConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.descLabel attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                      attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    
    
    NSLayoutConstraint *submitButtonWidthConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.submitView attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                       attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *submitButtonHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.submitView attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:self.view
                                                        attribute:NSLayoutAttributeHeight multiplier:0.07 constant:0];
    
    NSLayoutConstraint *submitButtonCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.submitView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    
    NSLayoutConstraint *submitButtonBottomConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.submitView attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual toItem:self.view
                                                        attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    
    
    
    NSLayoutConstraint *deleteFieldWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.deleteField attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                    attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *deleteFieldHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.deleteField attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                     attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0];
    
    NSLayoutConstraint *deleteFieldCenterXConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.deleteField attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                       attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    
    [self.scrollView addConstraints:@[deleteFieldWidthConstraint,deleteFieldHeightConstraint,deleteFieldCenterXConstraint]];
    
    [self.view addConstraints:@[submitButtonWidthConstraint,submitButtonHeightConstraint,submitButtonBottomConstraint, submitButtonCenterXConstraint]];
    
    [self.scrollView addConstraints:@[titleInputWidthConstraint,titleInputHeightConstraint,titleInputCenterXConstraint,
                                      titleLabelCenterXConstraint,
                                      typeLabelCenterXConstraint,typeFieldWidthConstraint,typeFieldHeightConstraint,
                                      descInputWidthConstraint,descInputHeightConstraint,descInputCenterXConstraint, descLabelCenterXConstraint,
                                      selectorViewCenterXConstraint,selectorViewCenterYConstraint,selectorViewWidthConstraint,selectorViewHeightConstraint,
                                      servesLabelCenterXConstraint,imageFieldHeightConstraint,
                                      pickerHeightConstraint,pickerWidthConstraint,pickerCenterXConstraint
                                      //
                                      ]];
    
    [self.scrollView addConstraints:@[addressLabelCenterXConstraint,addressInputHeightConstraint,addressInputWidthConstraint,addressInputCenterXConstraint]];

}


- (IBAction)deleteButtonPressed:(id)sender {
    
    //present action sheet to contfirm
    
    [self.delegate newViewController:self deleteItem:self.listingItem];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.lockOverlayView setHidden:YES];
    [self.deleteField setHidden:YES];
    [self.editButton setEnabled:NO];
    
    [self.submitView setHidden:NO];
}

- (IBAction)submitButtonPressed:(id)sender {
//    if(self.currentMode == EditMode){
//        //[self.delegate newViewController:self deleteItem:self.listingItem];
//        
//        [self.listingItem setName:@"AHAHAHHAHA"];
//        [self.listingItem setServeCount:[NSNumber numberWithInt:5]];
//        [self.listingItem setSyncStatus:[NSNumber numberWithInt:3]];
////        [self.listingItem setDesc:self.descInput.text];
////        [self.listingItem setAddress1:self.addressInput.text];
////        if(self.imageArray.count)
////        {
////            [self.listingItem setImage:[NSData dataWithData:UIImageJPEGRepresentation([self.imageArray objectAtIndex:0], 1.0)]];
////        }
//        [self.delegate newViewController:self didSaveItem:self.listingItem];
//    }
//    else
    {
        [self.listingItem setName:self.titleInput.text];
        [self.listingItem setServeCount:[NSNumber numberWithInt:self.serveCount]];
        [self.listingItem setDesc:self.descInput.text];
        [self.listingItem setAddress1:self.addressInput.text];
        
        NSUInteger imageCount = [self.imageArray count];
        
        if(imageCount>0)
        {
            [self.listingItem setImage:[NSData dataWithData:UIImageJPEGRepresentation([self.imageArray objectAtIndex:0], 1.0)]];
            
            if(imageCount>1) {
                [self.listingItem setImage2:[NSData dataWithData:UIImageJPEGRepresentation([self.imageArray objectAtIndex:1], 1.0)]];

                if(imageCount>2) {
                    [self.listingItem setImage3:[NSData dataWithData:UIImageJPEGRepresentation([self.imageArray objectAtIndex:2], 1.0)]];
                
                    if(imageCount>3) {
                        [self.listingItem setImage4:[NSData dataWithData:UIImageJPEGRepresentation([self.imageArray objectAtIndex:3], 1.0)]];
                        
                    }
                }
            }
        }
        
        BOOL hasChanged = YES;
        
        if(hasChanged && self.currentMode==EditMode)
        {
            [self.listingItem setSyncStatus:[NSNumber numberWithInt:3]];
        }
        
        [self.delegate newViewController:self didSaveItem:self.listingItem];
    }
    


}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate newViewController:self didCancelItemEdit:self.listingItem inMode:self.currentMode];
}

-(IBAction)addressInputTapped:(id)sender {
    NSLog(@"AKhilHAHAHHA");
}

- (void)dismissKeyboard {
    [self.titleInput resignFirstResponder];
    [self.descInput resignFirstResponder];
}

- (void)setTextFieldProperties:(UITextField *)inputView withPlaceholder:(NSString*)placeholder withTag:(NSInteger)tag {
    //inputView.text = placeholder;
    inputView.textColor = [UIColor lightGrayColor];
    inputView.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    inputView.textAlignment = NSTextAlignmentCenter;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.layer.cornerRadius = 0;
    inputView.clipsToBounds = YES;
    inputView.tag = tag;
    inputView.delegate = self;
    [inputView setReturnKeyType:UIReturnKeyDone];
    [inputView setKeyboardAppearance:UIKeyboardAppearanceDark];
    
}

- (IBAction)keyboardDoneButtonPressed:(id)sender {
    [self.descInput resignFirstResponder];
}

- (void)typeSelection:(UITapGestureRecognizer*)sender {
    
    UIView *view = sender.view;
    
    NSLog(@"Akhil: |%@| tag: %ld",view,(long)[sender.view tag]);
    NSInteger sendertag = [sender.view tag];
    
    [self.typeField updateSelectionWithTag:sendertag];
    //NSLog(@"%d", view.tag);//By tag, you can find out where you had typed.
}

#pragma mark - UIPickerView Delegates

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    CGRect rect = CGRectMake(0, 0, 80, 80);
    self.pickerLabel = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [self.pickerLabel setTransform:rotate];
    self.pickerLabel.text = [self.pickerViewArray objectAtIndex:row];
    self.pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50.0f];
    self.pickerLabel.textAlignment = NSTextAlignmentCenter;
    self.pickerLabel.clipsToBounds = YES;
    
    self.pickerLabel.textColor = [UIColor darkGrayColor];//defaultcolor
    self.pickerLabel.tintColor = [UIColor redColor];
    
    if([self.myPickerView selectedRowInComponent:component] == row) //this is the selected one, change its color
    {
        self.pickerLabel.textColor = [UIColor servePrimaryColor];//[UIColor colorWithRed:0.0745 green:0.357 blue:1.0 alpha:1];
    }
    
    if (![self pickerSelectionIndicatorInstalled])
    {
        [[self.myPickerView.subviews objectAtIndex:1] setHidden:TRUE];
        [[self.myPickerView.subviews objectAtIndex:2] setHidden:TRUE];
        // set the flag; remember to reset it upon creation of a new UIPickerView
        [self setPickerSelectionIndicatorInstalled:YES];
    }

    return self.pickerLabel ;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)myPickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)myPickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 27.0f;
}

//this is being implemented just change color of label on select. Change of color happens only on completion of selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.serveCount = (int)row + 1;
    [self.myPickerView reloadComponent:component];
}

#pragma mark - UIImagePickerDelegate

- (void)photoCaptureButtonAction:(id)sender {
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        
        [actionSheet showInView:self.view];
        
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self shouldPresentPhotoCaptureController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image2 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageArray addObject:image];
    
    [self.imageField resetImageFieldWithImageArray:self.imageArray];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
}

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

- (void)showActionSheet:(id)sender {
    
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
    
    [self scrollFieldToTop:textView
              onCompletion:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [self scrollFieldReset:textView onCompletion:nil];
    
    [self.descInput resignFirstResponder];
    
    if([self.descInput.text isEqualToString:@""])
    {
        self.descInput.text = descriptionPlaceholder;
        self.descInput.textColor = [UIColor grayColor];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollFieldToTop:textField
              onCompletion:nil];
    
    if([textField.text isEqualToString:titlePlaceholder])
    {
        textField.text = @"";
        textField.textColor = [UIColor blackColor];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self scrollFieldReset:textField onCompletion:nil];
    
    if ([textField.text isEqualToString:@""]) {
        
        if(textField.tag == TitleInputTag){
            textField.text = titlePlaceholder;
            textField.textColor = [UIColor grayColor];
        }
        
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    
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
            
        default:
            return newLength <= allowedNumberOfCharactersInTitle;
    }
}

#pragma mark - Scroll Animation

- (void)scrollFieldToTop:(UITextField*)field onCompletion:(void (^)(void))completionBlock;{
    // Calculate the new scroll view offset.
    // TODO: Why aren't these needed when the keyboard is displayed.  Seemed they were w/o
    // the kybd.  Net-net shouldn't we be using the scrollview's content inset to avoid the
    // nav and status bar?  I don't understand why the code I've written works, I just did
    // what I had to do.  Review with Gabor.
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGPoint newOffset = CGPointMake(0, 100);
    self.currentOffset = self.scrollView.contentOffset;
    //CGPoint newOffset = CGPointMake(0, /*statusBarHeight + navBarHeight +*/ field.containerView.top - statusBarHeight);
    
    // Scroll the Location field to the top.
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.scrollView.contentOffset = newOffset;
                     }
                     completion:completionBlock ? ^(BOOL finished) {completionBlock();} : nil
     ];
    
}

- (void)scrollFieldReset:(UITextField*)field onCompletion:(void (^)(void))completionBlock;{

    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    //    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGPoint newOffset = self.currentOffset;
    self.currentOffset = self.scrollView.contentOffset;
    //CGPoint newOffset = CGPointMake(0, /*statusBarHeight + navBarHeight +*/ field.containerView.top - statusBarHeight);
    
    // Scroll the Location field to the top.
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.scrollView.contentOffset = newOffset;
                     }
                     completion:completionBlock ? ^(BOOL finished) {completionBlock();} : nil
     ];
    
}


//- (instancetype)initWithExistingItem:(id<WTTaskProtocol>)item {
//    if (self = [super initWithNibName:nil bundle:nil]) {
//        self.item = item;
//        self.itemStartDate = [self.item ui_startDate];
//        self.itemDueDate = [self.item ui_dueDate];
//        self.itemReminderDate = [self.item reminderTime];
//        self.itemCategoriesString = [self.item ui_categoriesString];
//        
//        if (!title) title = NSLocalizedString(@"Edit", nil);
//    }
//    
//    return self;
//}


@end
