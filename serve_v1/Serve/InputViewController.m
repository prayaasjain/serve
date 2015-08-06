//
//  InputViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/11/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "InputViewController.h"
#import "PickUpInfoViewController.h"


const CGFloat LabelX = 30.0f;
const CGFloat LabelY = 325.0f;
const CGFloat LabelWidth = 80.0f;
const CGFloat LabelHeight = 30.0f;
const CGFloat LabelToLabelOffset = 50.0f;
const CGFloat LabelToTextViewOffset = 65.0f;
const CGFloat TextViewWidth  = 250.0f;
const CGFloat TextViewHeight = 30.0f;
const CGFloat serveButtonSize = 19.0f;
const CGFloat serveButtonY = LabelY+55.0f;
const CGFloat serveButtonX = LabelX+65.0f;
const CGFloat typeButtonY = serveButtonY +50.0f;
const CGFloat buttonInset = -2.0f;
const CGFloat InputProgressIndicatorTextSize = 9.0f;

//const CGFloat cancelButtonTag = 1;
//const CGFloat addPhotoTag = 2;
//const CGFloat addImageBackgroundViewTag = 3;

static NSString * const titlePlaceholder = @"Title";
static NSString * const cuisinePlaceholder = @"Indian, Chinese etc?";
static NSString * const descriptionPlaceholder = @"Description Text (Optional)";
static NSArray  * addPhotoActionSheetItems = nil;
static NSArray  * cancelButtonActionSheetItems = nil;

@interface InputViewController ()

@property (nonatomic, readwrite,assign) NSInteger numberOfServes;
@property (nonatomic, strong) UITextView *titleInput;
@property (nonatomic, strong) UITextView *servesInput;
@property (nonatomic, strong) UITextView *typeInput;
@property (nonatomic, strong) UITextView *descInput;
@property (nonatomic, strong) UITextView *cuisineInput;
@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, retain) NSArray* itemTypes;

@property (nonatomic, strong) UIImageView *addImageBackgroundView;
//@property (nonatomic, strong) UIImagePickerController *imagePickerView;

@property (nonatomic, strong) UIButton *addServeButton;
@property (nonatomic, strong) UIButton *reduceServeButton;
@property (nonatomic, strong) UIButton *previousTypeButton;
@property (nonatomic, strong) UIButton *nextTypeButton;
@property (nonatomic, strong) UIActionSheet *addPhotoActionSheet;
@property (nonatomic, strong) UIActionSheet *cancelButtonActionSheet;

@property (strong, nonatomic) PickUpInfoViewController *pickUpInfoViewController;
@property (strong, nonatomic) PickImageViewController *pickImageViewController;

- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (void) showActionSheet:(id)sender;
- (IBAction) didTapButton:(id)sender;

@end

@implementation InputViewController

@synthesize pickUpInfoViewController;
@synthesize pickImageViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationController];
    [self setUpViewControllerObjects];
    [self setUpActionSheets];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.toolbarHidden = NO;
    
    [super viewWillAppear:animated];
}

- (void)setUpNavigationController {
    
    self.navigationItem.hidesBackButton = YES;
     self.navigationController.toolbarHidden = NO;
    [self.navigationItem setTitle:@"Item Information"];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
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
    
    //[continueButton setTitle:@"Continue"];
    [continueButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [cancelButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    //cancelButton.tag = cancelButtonTag;
    
    //create an array of buttons
    NSArray *items = [NSArray arrayWithObjects:cancelButton, itemSpace, continueButton, nil];
    //add the buttons to the toolbar
    self.toolbarItems = items;

}

- (void)setUpViewControllerObjects {
    
    //ADD PHOTO BIG BACKGROUND IMAGE
    self.addImageBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(LabelX-40, LabelY - 180, 500, 160)];
    self.addImageBackgroundView.image = [UIImage imageNamed:@"food1-gray.jpg"];
    //self.addImageBackgroundView.alpha = 0.6f;
    self.addImageBackgroundView.layer.borderColor = [UIColor blackColor].CGColor;
    self.addImageBackgroundView.layer.borderWidth = 0.5f;
    self.addImageBackgroundView.layer.cornerRadius = 10;
    //self.addImageBackgroundView.tag = addImageBackgroundViewTag;
    

    [self.addImageBackgroundView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActionSheet:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.addImageBackgroundView addGestureRecognizer:singleTap];
    
    //CAMERA ICON WITH TEXT
    UIButton *addPhotoActionSheetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [addPhotoActionSheetButton setImage:[UIImage imageNamed:@"camera-2.png"] forState:UIControlStateNormal];
    [addPhotoActionSheetButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [addPhotoActionSheetButton setFrame:CGRectMake(160.0f, 196.0f, 55.0f, 55.0f)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-20, 55.0f, 90, 20)];
    [label setText:@"Add Photo"];
    [label setFont:[UIFont systemFontOfSize:11.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [addPhotoActionSheetButton addSubview:label];
    //addPhotoActionSheetButton.tag = addPhotoTag;

    self.itemTypes = @[@"Vegetarian",@"Non-Vegetarian"];
    self.numberOfServes = 1;
    
    UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY,                       LabelWidth, LabelHeight)];
    UILabel *servesLabel = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY+ LabelToLabelOffset,   LabelWidth, LabelHeight)];
    UILabel *typeLabel   = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY+ 2*LabelToLabelOffset, LabelWidth, LabelHeight)];
    
    UILabel *cuisineLabel = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY+ 3*LabelToLabelOffset, LabelWidth, LabelHeight)];

    UILabel *descLabel  =  [[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY+ 4*LabelToLabelOffset, LabelWidth, LabelHeight)];
    
    self.titleInput =  [[UITextView alloc]initWithFrame:
                        CGRectMake(titleLabel.frame.origin.x+LabelToTextViewOffset, titleLabel.frame.origin.y, TextViewWidth, TextViewHeight)];
    self.servesInput = [[UITextView alloc]initWithFrame:
                        CGRectMake(servesLabel.frame.origin.x+LabelToTextViewOffset, servesLabel.frame.origin.y, TextViewWidth, TextViewHeight)];
    self.typeInput =   [[UITextView alloc]initWithFrame:
                        CGRectMake(typeLabel.frame.origin.x+LabelToTextViewOffset, typeLabel.frame.origin.y, TextViewWidth, TextViewHeight)];
    self.descInput =   [[UITextView alloc]initWithFrame:
                        CGRectMake(descLabel.frame.origin.x+LabelToTextViewOffset, descLabel.frame.origin.y, TextViewWidth, 3*TextViewHeight)];
    
    self.cuisineInput =   [[UITextView alloc]initWithFrame:
                        CGRectMake(cuisineLabel.frame.origin.x+LabelToTextViewOffset, cuisineLabel.frame.origin.y, TextViewWidth, TextViewHeight)];
    
    self.titleInput.text = titlePlaceholder;
    self.titleInput.delegate = self;
    self.titleInput.textColor = [UIColor grayColor];
    self.titleInput.textAlignment = NSTextAlignmentCenter;
    self.titleInput.tag = 0;
    [self.titleInput setScrollEnabled:NO];
    
    //self.titleInput.textContainer.maximumNumberOfLines = 1;
   
    self.titleInput.textContainer.maximumNumberOfLines = 1;
    self.titleInput.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.descInput.text = descriptionPlaceholder;
    self.descInput.delegate = self;
    self.descInput.textColor = [UIColor grayColor];
    self.descInput.textAlignment = NSTextAlignmentCenter;
    self.descInput.tag = 1;
    
    self.servesInput.text = [NSString stringWithFormat:@"%ld",self.numberOfServes];//this has to be a property counting serves
    self.servesInput.textColor = [UIColor blackColor];
    self.servesInput.textAlignment = NSTextAlignmentCenter;
    self.servesInput.editable = NO;
    
    self.typeInput.text = [self.itemTypes objectAtIndex:0];//default item type is veg
    self.typeInput.textColor = [UIColor blackColor];
    self.typeInput.textAlignment = NSTextAlignmentCenter;
    self.typeInput.editable = NO;
    
    self.cuisineInput.text = cuisinePlaceholder;//default item type is veg
    self.cuisineInput.textColor = [UIColor grayColor];
    self.cuisineInput.textAlignment = NSTextAlignmentCenter;
    self.cuisineInput.tag = 2;
    self.cuisineInput.delegate = self;
    
    [self setTextFieldProperties:self.titleInput];
    [self setTextFieldProperties:self.servesInput];
    [self setTextFieldProperties:self.typeInput];
    [self setTextFieldProperties:self.descInput];
    [self setTextFieldProperties:self.cuisineInput];
    
    [titleLabel setText:@"*Title:"];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [servesLabel setText:@"*Serves"];
    [servesLabel setFont:[UIFont systemFontOfSize:12]];
    [typeLabel setText:@"*Type"];
    [typeLabel setFont:[UIFont systemFontOfSize:12]];
    [cuisineLabel setText:@"*Cuisine"];
    [cuisineLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel setText:@"Desc:"];
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    

    //[self.view addSubview:self.addImageButton];
    [self.view addSubview:self.addImageBackgroundView];
    [self.view addSubview:addPhotoActionSheetButton];
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.titleInput];
    [self.view addSubview:servesLabel];
    [self.view addSubview:self.servesInput];
    [self.view addSubview:typeLabel];
    [self.view addSubview:self.typeInput];
    [self.view addSubview:descLabel];
    
    [self.view addSubview:self.cuisineInput];
    [self.view addSubview:cuisineLabel];
    
    
    [self.view addSubview:self.descInput];
    [self.view addSubview:self.addServeButton];//
    [self.view addSubview:self.reduceServeButton];//
    [self.view addSubview:self.previousTypeButton];//
    [self.view addSubview:self.nextTypeButton];//
    [self.view addSubview:self.progressIndicator];//
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //[self.view addSubview:self.imagePickerView];
    
    addPhotoActionSheetItems = [[NSArray alloc] initWithObjects:@"Remove Image",
                                @"Take Photo",@"Choose Existing", @"Search Web",@"Cancel", nil];
    
    cancelButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"Are you sure you want to delete the listing?",
                                    @"Discard Listing",@"Cancel", nil];
    


}

- (void)setTextFieldProperties:(UITextView *)inputView {
    inputView.layer.borderWidth = .5f;
    inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    inputView.layer.cornerRadius = 5;//changed from 15
    inputView.clipsToBounds = YES;
}

- (UIButton *)reduceServeButton {
    
    //_reduceServeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _reduceServeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage imageNamed:@"reduce_serve.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_reduceServeButton setFrame:CGRectMake(serveButtonX+8,serveButtonY+4, serveButtonSize, serveButtonSize-5)];
    
    //[_reduceServeButton setImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
    [_reduceServeButton setImage:image forState:UIControlStateNormal];
    [_reduceServeButton addTarget:self action:@selector(decrementServeCount:) forControlEvents:UIControlEventTouchUpInside];
    _reduceServeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    _reduceServeButton.tintColor = [UIColor grayColor];
    
    return _reduceServeButton;
}

- (UIButton *)addServeButton {
    
    if (!_addServeButton) {
    
    _addServeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addServeButton setFrame:CGRectMake(self.reduceServeButton.frame.origin.x+serveButtonSize+195,serveButtonY+4, serveButtonSize, serveButtonSize-5)];
    UIImage *image = [[UIImage imageNamed:@"add_serve.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_addServeButton addTarget:self action:@selector(incrementServeCount:) forControlEvents:UIControlEventTouchUpInside];
    _addServeButton.layer.cornerRadius = 10;
    _addServeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    [_addServeButton setImage:image forState:UIControlStateNormal];
    _addServeButton.tintColor = [UIColor grayColor];

//         _addServeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [_addServeButton setTitle:@"+" forState:UIControlStateNormal];
//        _addServeButton.layer.borderWidth=1.0f;
//        _addServeButton.layer.borderColor=[[UIColor blackColor] CGColor];
  
    }
    
    return _addServeButton;
}

- (UIButton *)nextTypeButton {
    
    _nextTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nextTypeButton setFrame:CGRectMake(self.previousTypeButton.frame.origin.x+serveButtonSize+195 ,typeButtonY+4, serveButtonSize, serveButtonSize-5)];
    UIImage *image = [[UIImage imageNamed:@"next.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_nextTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    _nextTypeButton.layer.cornerRadius = 10;
    _nextTypeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    [_nextTypeButton setImage:image forState:UIControlStateNormal];
    _nextTypeButton.tintColor = [UIColor grayColor];
   [_nextTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];

//    [_nextTypeButton setTitle:@">" forState:UIControlStateNormal];

//    _nextTypeButton.layer.borderWidth=1.0f;
//    _nextTypeButton.layer.borderColor=[[UIColor blackColor] CGColor];
//    _nextTypeButton.layer.cornerRadius = 10;
//    _nextTypeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    return _nextTypeButton;
}

- (UIButton *)previousTypeButton {
    
    _previousTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_previousTypeButton setFrame:CGRectMake(serveButtonX+8,typeButtonY+4, serveButtonSize, serveButtonSize-5)];
    
    UIImage *image = [[UIImage imageNamed:@"previous.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_previousTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    _previousTypeButton.layer.cornerRadius = 10;
    _previousTypeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    [_previousTypeButton setImage:image forState:UIControlStateNormal];
    _previousTypeButton.tintColor = [UIColor grayColor];
    [_previousTypeButton addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    
//    
//    [_previousTypeButton setTitle:@"<" forState:UIControlStateNormal];
//    _previousTypeButton.layer.borderWidth=1.0f;
//    _previousTypeButton.layer.borderColor=[[UIColor blackColor] CGColor];
//    _previousTypeButton.layer.cornerRadius = 10;
//    _previousTypeButton.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    return _previousTypeButton;
}

- (UIView *) progressIndicator {
    
    NSLog(@"%f",self.addImageBackgroundView.frame.origin.y);
    _progressIndicator = [[UIView alloc]initWithFrame:CGRectMake(35, 45, 100, 40)];
    
    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
    [step1Button setTitle:@"1" forState:UIControlStateNormal];
    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step1Button.layer.borderWidth=1.0f;
    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step1Button.layer.cornerRadius = 10;
    step1Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    UILabel *step1Label = [[UILabel alloc]initWithFrame:CGRectMake(_progressIndicator.frame.origin.x, _progressIndicator.frame.origin.y+serveButtonSize, 60, 20)];
    [step1Label setText:@"Item Details"];
    [step1Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
    [step1Label setTextColor:[UIColor redColor]];

    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_progressIndicator.frame.origin.x+16+serveButtonSize, _progressIndicator.frame.origin.y+serveButtonSize/2, 75, 1.0f)];
    lineView1.backgroundColor = [UIColor blackColor];
    
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step2Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16+serveButtonSize+lineView1.frame.size.width,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [step2Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[part1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step2Button.layer.borderWidth=1.0f;
    step2Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step2Button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    step2Button.layer.cornerRadius = 10;
    step2Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    UILabel *step2Label = [[UILabel alloc]initWithFrame:CGRectMake(step1Label.frame.origin.x+lineView1.frame.size.width+8, _progressIndicator.frame.origin.y+serveButtonSize, 80, 20)];
    [step2Label setText:@"Pickup Information"];
    [step2Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x+lineView1.frame.size.width+serveButtonSize, _progressIndicator.frame.origin.y+serveButtonSize/2, 75, 1.0f)];
    lineView2.backgroundColor = [UIColor blackColor];
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step3Button setFrame:CGRectMake(lineView2.frame.origin.x+lineView2.frame.size.width,_progressIndicator.frame.origin.y,serveButtonSize, serveButtonSize)];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [step3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[step3Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step3Button.layer.borderWidth=1.0f;
    step3Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step3Button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    step3Button.layer.cornerRadius = 10;
    step3Button.contentEdgeInsets = UIEdgeInsetsMake(buttonInset, 0.0, 0.0, 0.0);
    
    UILabel *step3Label = [[UILabel alloc]initWithFrame:CGRectMake(step2Label.frame.origin.x+lineView2.frame.size.width+26, _progressIndicator.frame.origin.y+serveButtonSize, 80, 20)];
    [step3Label setText:@"Review/Submit"];
    [step3Label setFont:[UIFont systemFontOfSize:InputProgressIndicatorTextSize]];
    
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

- (IBAction)incrementServeCount:(id)sender {
    self.numberOfServes++;
    self.servesInput.text = [NSString stringWithFormat:@"%ld",self.numberOfServes];
}

- (IBAction)decrementServeCount:(id)sender {
    
    if(self.numberOfServes!=1)
    {
        self.numberOfServes--;
        self.servesInput.text = [NSString stringWithFormat:@"%ld",self.numberOfServes];
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
    
    if(self.pickUpInfoViewController == nil){
        PickUpInfoViewController *secondView = [[PickUpInfoViewController alloc] init];
        self.pickUpInfoViewController= secondView;
    }
    [self.navigationController pushViewController:self.pickUpInfoViewController animated:YES];
}

- (IBAction) didTapButton:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
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

- (void)addItemViewController:(PickImageViewController *)controller didFinishEnteringItem:(UIImage *)imageRecieved
{
    //NSLog(@"This was returned from PickImageViewController %@",imageRecieved);
    
    self.addImageBackgroundView.image = imageRecieved;
    self.addImageBackgroundView.alpha = 1 ;

}


- (void)setUpActionSheets{
    
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
    
    if(senderTag == 2)
    {
        [self.addPhotoActionSheet showInView:self.view];
    }
    
    if(senderTag == 1)
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


//not copied here onwards


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:titlePlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    if ([textView.text isEqualToString:descriptionPlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    if ([textView.text isEqualToString:cuisinePlaceholder])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        if(textView.tag == 0) {
            textView.text = titlePlaceholder;
        }
        
        if(textView.tag == 1)
        {
            textView.text = descriptionPlaceholder;
        }
        
        if(textView.tag == 2)
        {
            textView.text = cuisinePlaceholder;
        }
        
        textView.textColor = [UIColor lightGrayColor];
        
    }
    [textView resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.titleInput resignFirstResponder];
    return YES;
}

- (void) dismissKeyboard
{
    // add self
    [self resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // dismiss keyboard through `resignFirstResponder`
    [self.titleInput resignFirstResponder];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end