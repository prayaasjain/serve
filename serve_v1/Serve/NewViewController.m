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
//const int allowedNumberOfCharactersInCuisine = allowedNumberOfCharactersInTitle;

//for animation
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


@interface NewViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TypeField  *typeField;
@property (nonatomic, strong) ImageField *imageField;
@property (nonatomic ,strong) UITableView* homeTable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *servesLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextField *titleInput;
@property (nonatomic, strong) UIButton *addServeButton;
@property (nonatomic, strong) UIButton *reduceServeButton;
@property (nonatomic, strong) UITextView *descInput;
@property (nonatomic, readwrite,assign) NSNumber *numberOfServes;

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UILabel *pickerLabel;
@property (nonatomic, strong) UIView *selectorView;
@property (nonatomic, retain) NSArray* pickerViewArray;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) BOOL pickerSelectionIndicatorInstalled;

@property (nonatomic, strong) UIView *submitView;

@property (nonatomic, retain) NSMutableArray* imageArray;

- (void) showActionSheet:(id)sender;

@end



@implementation NewViewController

@synthesize myPickerView;
@synthesize typeField;

- (void)viewDidLoad {
    
    [self setUpViewControllerObjects];
    [self setUpNavigationController];

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
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setUpConstraints];
    
     self.titleInput.layer.cornerRadius = self.titleInput.frame.size.width/20;
     self.submitView.layer.cornerRadius = 5;
}
- (void)setUpViewControllerObjects {
    
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor serveBackgroundColor];
    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    self.titleLabel  = [UILabel new];
    [self.titleLabel setText:@"Title"];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
    self.titleLabel.textColor = [UIColor servetextLabelGrayColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.servesLabel  = [UILabel new];
    [self.servesLabel setText:@"Serves"];
    [self.servesLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
    self.servesLabel.textColor = [UIColor servetextLabelGrayColor];
    self.servesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.typeLabel  = [UILabel new];
    [self.typeLabel setText:@"Type"];
    [self.typeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
    self.typeLabel.textColor = [UIColor servetextLabelGrayColor];
    self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.descLabel = [UILabel new];
    [self.descLabel setText:@"Description"];
    [self.descLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
    self.descLabel.textColor = [UIColor servetextLabelGrayColor];
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.titleInput = [[UITextField alloc]init];
    [self.titleInput setBackgroundColor:[UIColor whiteColor]];
    self.titleInput.layer.cornerRadius = self.titleInput.frame.size.width/2;
    [self setTextFieldProperties:self.titleInput withPlaceholder:titlePlaceholder withTag:TitleInputTag];
    
    self.descInput = [[UITextView alloc]init];
    self.descInput.text = descriptionPlaceholder;
    self.descInput.delegate = self;
    self.descInput.textColor = [UIColor lightGrayColor];
    self.descInput.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];;
    self.descInput.textAlignment = NSTextAlignmentCenter;
    self.descInput.translatesAutoresizingMaskIntoConstraints = NO;
    self.descInput.layer.cornerRadius = 5;//changed from 15
    self.descInput.clipsToBounds = YES;
    self.descInput.tag = DescInputTag;
    [self.descInput setReturnKeyType:UIReturnKeyDefault];
    [self.descInput setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    self.submitView = [[UIView alloc]initWithFrame:CGRectZero];
    self.submitView.backgroundColor = [UIColor serveRedButtonColor];
    self.submitView.translatesAutoresizingMaskIntoConstraints  = NO;
    UILabel *submitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    submitLabel.text = @"Submit";
    [submitLabel setTextColor:[UIColor whiteColor]];
    [submitLabel setFont:[UIFont fontWithName:@"Helvetica" size:25.0]];
    //[submitLabel setCenter:self.submitView.center];
    [self.submitView addSubview:submitLabel];
    
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
    
    
    self.imageArray = [[NSMutableArray alloc]init];
    
    self.imageField= [[ImageField alloc]initWithFrame:CGRectZero];
    self.imageField.backgroundColor = [UIColor whiteColor];
    self.imageField.translatesAutoresizingMaskIntoConstraints  = NO;
    UITapGestureRecognizer *imageOneTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    [imageOneTap setNumberOfTapsRequired:1];
    UITapGestureRecognizer *imageTwoTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    [imageTwoTap setNumberOfTapsRequired:1];
    UITapGestureRecognizer *imageThreeTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    [imageThreeTap setNumberOfTapsRequired:1];
    UITapGestureRecognizer *imageFourTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
    [imageFourTap setNumberOfTapsRequired:1];
    [self.imageField.imageOne addGestureRecognizer:imageOneTap];
    [self.imageField.imageTwo addGestureRecognizer:imageTwoTap];
    [self.imageField.imageThree addGestureRecognizer:imageThreeTap];
    [self.imageField.imageFour addGestureRecognizer:imageFourTap];
    
    
    self.selectedRow = 2;
    self.pickerSelectionIndicatorInstalled = nil;
    self.pickerViewArray = [NSArray arrayWithObjects:
                            @"1", @"2", @"3",
                            @"4", @"5", @"6", @"7",@"8",@"9",@"10",@">10",
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
    self.selectorView.layer.borderColor = [[UIColor serveRedButtonColor] CGColor];
    self.selectorView.layer.borderWidth = 1.0f;
    self.selectorView.layer.cornerRadius = 25.0f;
    self.selectorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}
- (void)setUpNavigationController {
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"Create a Posting"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectZero;
    button.frame = CGRectMake(0, 0, 50, 28);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = .2f;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor blackColor]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 50, 28);
    button2.layer.borderColor = [UIColor whiteColor].CGColor;
    button2.layer.borderWidth = .2f;
    button2.layer.cornerRadius = 5;
    [button2 setTitle:@"Save" forState:UIControlStateNormal];
    [button2.titleLabel setTextColor:[UIColor blackColor]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [button2 addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = saveBarButton;
    
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
                 @"descInput":self.descInput
                 }
    ;
    
    //@"imageView":self.imageView,
    id metrics = @{@"topMargin": @40, @"bottommargin":@50,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@10,@"fieldSpacing":@40};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: metrics views:views]];
    
    //[scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[imageView]-rightMargin-|" options:0 metrics:metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageField]|" options:0 metrics:metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[titleInput]-leftMargin-|" options:0 metrics:metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[descInput]-leftMargin-|" options:0 metrics:metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[typeField]-leftMargin-|" options:0 metrics:metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[pickerView]-leftMargin-|" options:0 metrics:metrics views:views]];
    
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageField]-fieldSpacing-[titleLabel]-[titleInput]-fieldSpacing-[servesLabel]-[pickerView]-fieldSpacing-[typeLabel]-[typeField]-fieldSpacing-[descLabel]-[descInput]-|" options:0 metrics: metrics views:views]];
    
    NSLayoutConstraint *titleInputWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.titleInput attribute:NSLayoutAttributeWidth
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
    
    NSLayoutConstraint *descInputHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.descInput attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                     attribute:NSLayoutAttributeHeight multiplier:.40 constant:0];
    
    NSLayoutConstraint *pickerWidthConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.myPickerView attribute:NSLayoutAttributeWidth
                                                 relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pickerHeightConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.myPickerView attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual toItem:self.titleInput
                                                  attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
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
    
    NSLayoutConstraint *submitButtonCenterYConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.submitView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY multiplier:1.88 constant:0];
    
    
    //    NSLayoutConstraint *submitButtonCenterYConstraint = [NSLayoutConstraint
    //                                                         constraintWithItem:self.submitView attribute:NSLayoutAttributeCenterY
    //                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
    //                                                         attribute:NSLayoutAttributeBottom multiplier:1 constant:-40];
    
    
    [self.view addConstraints:@[submitButtonWidthConstraint,submitButtonHeightConstraint,submitButtonCenterXConstraint,submitButtonCenterYConstraint
                                ]];
    
    [self.scrollView addConstraints:@[titleInputWidthConstraint,descInputWidthConstraint,descInputHeightConstraint,titleInputHeightConstraint,selectorViewCenterXConstraint,selectorViewCenterYConstraint,
                                      selectorViewWidthConstraint,selectorViewHeightConstraint,titleLabelCenterXConstraint,typeLabelCenterXConstraint,servesLabelCenterXConstraint,descLabelCenterXConstraint,
                                      typeFieldWidthConstraint,typeFieldHeightConstraint,pickerHeightConstraint,
                                      imageFieldHeightConstraint
                                      //
                                      ]];
    
    //imageViewWidthConstraint,imageViewHeightConstraint
}


-(void)dismissKeyboard {
    [self.titleInput resignFirstResponder];
    [self.descInput resignFirstResponder];
}

- (void)setTextFieldProperties:(UITextField *)inputView withPlaceholder:(NSString*)placeholder withTag:(NSInteger)tag {
    inputView.text = placeholder;
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

#pragma mark - UIPickerView ServeCountView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

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
        self.pickerLabel.textColor = [UIColor serveRedButtonColor];//[UIColor colorWithRed:0.0745 green:0.357 blue:1.0 alpha:1];
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

- (void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    
//    self.imageField.imageOne.image = image;
//    self.imageField.imageTwo.image = image;
    
    [self.imageArray addObject:image];
    [self.imageField addPhotoWithPhotosArray:self.imageArray];
    
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
//    else if ([textField.text isEqualToString:cuisinePlaceholder])
//    {
//        textField.text = @"";
//        textField.textColor = [UIColor blackColor];
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textViewAnimationEnd];
    
    if ([textField.text isEqualToString:@""]) {
        
        if(textField.tag == TitleInputTag){
            textField.text = titlePlaceholder;
            textField.textColor = [UIColor grayColor];
        }
        
//        else if(textField.tag == CusineInputTag){
//            textField.text = cuisinePlaceholder;
//            textField.textColor = [UIColor grayColor];
//        }
        
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



@end






/*
 //- (void)viewDidLoad {
 //    [super viewDidLoad];
 //
 //    //content filling has to be aspect ratio
 //
 ////    self.homeTable = [[UITableView alloc]init];
 ////    CGRect viewRect = self.view.bounds;
 ////    self.homeTable.frame = CGRectMake(0, 30, viewRect.size.width-20, (viewRect.size.height));
 ////    self.homeTable.delegate = self;
 ////    self.homeTable.dataSource = self;
 ////    [self.homeTable registerClass:[ImageFieldCell class] forCellReuseIdentifier:imageFieldCellIdentifier];
 ////    [self.view addSubview:self.homeTable];
 //    [self setUpViewControllerObjects];
 //
 ////    [self.view addSubview:self.titleLabel];
 ////    [self.view addSubview:self.titleInput];
 ////    [self.view addSubview:self.descLabel];
 ////    [self.view addSubview:self.descInput];
 ////    [self.view addSubview:self.servesLabel];
 ////    [self.view addSubview:self.servesInput];
 ////    [self.view addSubview:self.addServeButton];
 ////    [self.view addSubview:self.reduceServeButton];
 ////    [self.view addSubview:self.typeLabel];
 ////    [self.view addSubview:self.typeInput];
 ////    [self.view addSubview:self.previousTypeButton];
 ////    [self.view addSubview:self.nextTypeButton];
 ////    [self.view addSubview:self.cuisineLabel];
 ////    [self.view addSubview:self.cuisineInput];
 ////    [self setUpConstraints];
 ////    [self.view setBackgroundColor:[UIColor whiteColor]];
 //
 //    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 390, self.view.frame.size.height)];
 //    [self.scrollview setBackgroundColor:[UIColor grayColor]];
 //    self.scrollview.translatesAutoresizingMaskIntoConstraints = NO;
 //    [self.view setBackgroundColor:[UIColor redColor]];
 //
 //    NSInteger viewcount= 2;
 //    for(int i = 0; i< viewcount; i++) {
 //
 //        CGFloat y = i * self.view.frame.size.height;
 //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,self.view.frame.size.width, self .view.frame.size.height)];
 //        view.backgroundColor = [UIColor whiteColor];
 //        [self.scrollview addSubview:view];
 //    }
 //
 //    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *viewcount);
 //    [self.scrollview addSubview:self.titleLabel];
 //    [self.scrollview addSubview:self.titleInput];
 //    [self.scrollview addSubview:self.descLabel];
 //    [self.scrollview addSubview:self.descInput];
 //    [self.scrollview addSubview:self.servesLabel];
 //    [self.scrollview addSubview:self.servesInput];
 //    [self.scrollview addSubview:self.addServeButton];
 //    [self.scrollview addSubview:self.reduceServeButton];
 //    [self.scrollview addSubview:self.typeLabel];
 //    [self.scrollview addSubview:self.typeInput];
 //    [self.scrollview addSubview:self.previousTypeButton];
 //    [self.scrollview addSubview:self.nextTypeButton];
 //    [self.scrollview addSubview:self.cuisineLabel];
 //    [self.scrollview addSubview:self.cuisineInput];
 //    [self.view addSubview:self.scrollview];
 
 ////    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 100, 100)];
 ////    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
 ////    [self.imageView setClipsToBounds:YES];
 ////    self.imageView.image = [UIImage imageNamed:@"camera-2.png"];
 ////    self.imageView.layer.borderColor = [UIColor redColor].CGColor;
 ////    self.imageView.layer.borderWidth = 0.5f;
 ////    self.imageView.layer.cornerRadius = 10;
 ////    [self.imageView setUserInteractionEnabled:YES];
 ////    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoCaptureButtonAction:)];
 ////    [singleTap setNumberOfTapsRequired:1];
 ////    [self.imageView addGestureRecognizer:singleTap];
 ////    [self.view addSubview:self.imageView];
 //
 //    self.view.backgroundColor = [UIColor whiteColor];
 //    
 //    // Do any additional setup after loading the view.
 //}

 */
