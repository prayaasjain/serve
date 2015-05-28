//
//  PickUpInfoViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/14/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PickUpInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "AppDelegate.h"

const CGFloat progressButtonSize = 19.0f;
const CGFloat progressButtonY = 365.0f;
const CGFloat progressButtonX = 80.0f;
const CGFloat progressButtonInset = -2.0f;
const CGFloat progressIndicatorTextSize = 9.0f;

const CGFloat PickUpLabelX = 30.0f;
const CGFloat PickUpLabelY = 170.0f;
const CGFloat PickUpLabelWidth = 50.0f;
const CGFloat PickUpLabelHeight = 30.0f;
const CGFloat PickUpLabelToLabelOffset = 50.0f;
const CGFloat PickUpLabelToTextViewOffset = 65.0f;
const CGFloat PickUpTextViewWidth  = 250.0f;
const CGFloat PickUpTextViewHeight = 30.0f;
//const CGFloat typeButtonY = 414.0f;
//const CGFloat buttonInset = -2.0f;

static NSArray *deleteButtonActionSheetItems = nil;
const CGFloat deleteButtonTag = 1;

static NSString * const titlePlaceholder = @"Title";
static NSString * const descriptionPlaceholder = @"Description Text (Optional)";

@interface PickUpInfoViewController ()<UITextViewDelegate>

@property (nonatomic, readwrite,assign) NSInteger numberOfServes;
@property (nonatomic, strong) UITextView *addressinput1;
@property (nonatomic, strong) UITextView *addressinput2;
@property (nonatomic, strong) UITextView *cityInput;
@property (nonatomic, strong) UITextView *stateInput;
@property (nonatomic, strong) UITextView *zipCodeInput;
@property (nonatomic, strong) UITextView *phoneInput;
@property (nonatomic, strong) UIButton *pickUpPrefInput;

@property (nonatomic, strong) UIView *progressIndicator;
@property (nonatomic, retain) NSArray* itemTypes;
@property (nonatomic, strong) UIActionSheet *deleteButtonActionSheet;

- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)showActionSheet:(id)sender;

@property (strong, nonatomic) PickUpInfoViewController *pickUpInfoViewController;
@end

@implementation PickUpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationController];
    [self setUpViewControllerObjects];
    [self setUpActionSheets];
    

}

- (void)viewWillAppear:(BOOL)animated {
    //display navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //display toolbar
    self.navigationController.toolbarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)setTextFieldProperties:(UITextView *)inputView {
    inputView.layer.borderWidth = 1.0f;
    inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    inputView.layer.cornerRadius = 5;
    inputView.clipsToBounds = YES;
}
- (void)autoFillTextFields {
    
    [self.addressinput1 setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    [self.addressinput2 setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    [self.cityInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    [self.stateInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    [self.zipCodeInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    [self.phoneInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    //[self.pickUpPrefInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
    
    
    self.addressinput1.textColor = [UIColor grayColor];
    self.addressinput2.textColor = [UIColor grayColor];
    self.cityInput.textColor = [UIColor grayColor];
    self.stateInput.textColor = [UIColor grayColor];
    self.zipCodeInput.textColor = [UIColor grayColor];
    self.phoneInput.textColor = [UIColor grayColor];
    //self.pickUpPrefInput.textColor = [UIColor grayColor];
    
    self.addressinput1.tag = 0;
    
    self.addressinput1.text = @"19, Chachan Mansion";
    self.addressinput2.text = @"Ladenla Road";
    self.cityInput.text = @"Darjeeling";
    self.stateInput.text = @"West Bengal";
    self.zipCodeInput.text =@"734101";
    self.phoneInput.text = @"+919434048340";
    //self.pickUpPrefInput.text = @"All Day";

}

- (UIView *)progressIndicator {
    
    _progressIndicator = [[UIView alloc]initWithFrame:CGRectMake(35, 45, 100, 40)];
    
    UIButton *step1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step1Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16,_progressIndicator.frame.origin.y,progressButtonSize, progressButtonSize)];
    [step1Button setTitle:@"1" forState:UIControlStateNormal];
    [step1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[step1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step1Button.layer.borderWidth=1.0f;
    step1Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step1Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step1Button.layer.cornerRadius = 10;
    step1Button.contentEdgeInsets = UIEdgeInsetsMake(progressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step1Label = [[UILabel alloc]initWithFrame:CGRectMake(_progressIndicator.frame.origin.x, _progressIndicator.frame.origin.y+progressButtonSize, 60, 20)];
    [step1Label setText:@"Item Details"];
    [step1Label setFont:[UIFont systemFontOfSize:progressIndicatorTextSize]];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_progressIndicator.frame.origin.x+16+progressButtonSize, _progressIndicator.frame.origin.y+progressButtonSize/2, 75, 2.0f)];
    lineView1.backgroundColor = [UIColor blackColor];
    
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step2Button setFrame:CGRectMake(_progressIndicator.frame.origin.x+16+progressButtonSize+lineView1.frame.size.width,_progressIndicator.frame.origin.y,progressButtonSize, progressButtonSize)];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[part1Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step2Button.layer.borderWidth=1.0f;
    step2Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step2Button.layer.backgroundColor = [[UIColor blackColor] CGColor];
    step2Button.layer.cornerRadius = 10;
    step2Button.contentEdgeInsets = UIEdgeInsetsMake(progressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step2Label = [[UILabel alloc]initWithFrame:CGRectMake(step1Label.frame.origin.x+lineView1.frame.size.width+8, _progressIndicator.frame.origin.y+progressButtonSize, 80, 20)];
    [step2Label setText:@"Pickup Information"];
    [step2Label setFont:[UIFont systemFontOfSize:progressIndicatorTextSize]];
    [step2Label setTextColor:[UIColor redColor]];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x+lineView1.frame.size.width+progressButtonSize, _progressIndicator.frame.origin.y+progressButtonSize/2, 75, 1.0f)];
    lineView2.backgroundColor = [UIColor blackColor];
    
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [step3Button setFrame:CGRectMake(lineView2.frame.origin.x+lineView2.frame.size.width,_progressIndicator.frame.origin.y,progressButtonSize, progressButtonSize)];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [step3Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[step3Button addTarget:self action:@selector(toggleItemType:) forControlEvents:UIControlEventTouchUpInside];
    step3Button.layer.borderWidth=1.0f;
    step3Button.layer.borderColor=[[UIColor blackColor] CGColor];
    step3Button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    step3Button.layer.cornerRadius = 10;
    step3Button.contentEdgeInsets = UIEdgeInsetsMake(progressButtonInset, 0.0, 0.0, 0.0);
    
    UILabel *step3Label = [[UILabel alloc]initWithFrame:CGRectMake(step2Label.frame.origin.x+lineView2.frame.size.width+26, _progressIndicator.frame.origin.y+progressButtonSize, 80, 20)];
    [step3Label setText:@"Review/Submit"];
    [step3Label setFont:[UIFont systemFontOfSize:progressIndicatorTextSize]];
    
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

- (void)setUpNavigationController {
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"PickUp Information"];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    UIBarButtonItem *continueButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Continue"
                                      style: UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(continueButtonPressed:)];
    

    deleteButtonActionSheetItems = [[NSArray alloc] initWithObjects:@"Are you sure you want to delete the listing?",
                                    @"Discard Listing",@"Cancel", nil];
    
    //trash button
    UIImage *trashImage = [UIImage imageNamed:@"trash.png"];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:trashImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, trashImage.size.width, trashImage.size.height)];
    button.tag = deleteButtonTag;
   
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 21, 50, 20)];
//    [label setText:@"Discard"];
//    [label setFont:[UIFont systemFontOfSize:9.0f]];
//    label.textAlignment = NSTextAlignmentCenter;
//    [label setTextColor:[UIColor blackColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
    //[button addSubview:label];
    
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    /////
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style: UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backButtonPressed:)];
    
    
    ///setting color of back and continue buttons to black
    [continueButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [backButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    ////////
    
    
    NSArray *items = [NSArray arrayWithObjects:backButton, itemSpace, trashButton, itemSpace, continueButton, nil];
    self.toolbarItems = items;

}

- (void)setUpViewControllerObjects {
    
    [self.view addSubview:self.progressIndicator];//
    
    //All labels
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *addressLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+2*PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+3*PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *zipCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+4*PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+5*PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    UILabel *pickUpPrefLabel = [[UILabel alloc]initWithFrame:CGRectMake(PickUpLabelX, PickUpLabelY+6*PickUpLabelToLabelOffset, PickUpLabelWidth, PickUpTextViewHeight)];
    
    [addressLabel setText:@"Address Line 1 "];
    [addressLabel setFont:[UIFont systemFontOfSize:12]];
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel.numberOfLines = 0;
    
    [addressLabel2 setText:@"Address Line 2"];
    [addressLabel2 setFont:[UIFont systemFontOfSize:12]];
    addressLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel2.numberOfLines = 0;

    [cityLabel setText:@"City"];
    [cityLabel setFont:[UIFont systemFontOfSize:12]];
    
    [stateLabel setText:@"State:"];
    [stateLabel setFont:[UIFont systemFontOfSize:12]];
    
    [zipCodeLabel setText:@"Zipcode:"];
    [zipCodeLabel setFont:[UIFont systemFontOfSize:12]];
    
    [phoneLabel setText:@"Phone:"];
    [phoneLabel setFont:[UIFont systemFontOfSize:12]];
    
    [pickUpPrefLabel setText:@"Pick Up Availablity:"];
    [pickUpPrefLabel setFont:[UIFont systemFontOfSize:10]];
    pickUpPrefLabel.lineBreakMode = NSLineBreakByWordWrapping;
    pickUpPrefLabel.numberOfLines = 0;
    

    self.addressinput1 = [[UITextView alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x+65, addressLabel.frame.origin.y, 250, 30)];
    self.addressinput2 = [[UITextView alloc]initWithFrame:CGRectMake(addressLabel2.frame.origin.x+65, addressLabel2.frame.origin.y, 250, 30)];
    self.cityInput = [[UITextView alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x+65, cityLabel.frame.origin.y, 150, 30)];
    self.stateInput = [[UITextView alloc]initWithFrame:CGRectMake(stateLabel.frame.origin.x+65, stateLabel.frame.origin.y, 150, 30)];
    self.zipCodeInput = [[UITextView alloc]initWithFrame:CGRectMake(zipCodeLabel.frame.origin.x+65, zipCodeLabel.frame.origin.y, 150, 30)];
    self.phoneInput = [[UITextView alloc]initWithFrame:CGRectMake(phoneLabel.frame.origin.x+65, phoneLabel.frame.origin.y, 150, 30)];
//    self.pickUpPrefInput = [[UITextView alloc]initWithFrame:CGRectMake(pickUpPrefLabel.frame.origin.x+65, pickUpPrefLabel.frame.origin.y, 150, 30)];
    
//    self.pickUpPrefInput = [[UITextView alloc]initWithFrame:CGRectMake(pickUpPrefLabel.frame.origin.x+65, pickUpPrefLabel.frame.origin.y, 150, 30)];
    
    self.pickUpPrefInput = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickUpPrefInput setFrame:CGRectMake(pickUpPrefLabel.frame.origin.x+65, pickUpPrefLabel.frame.origin.y, 150, 30)];
    //UIImage *image = [[UIImage imageNamed:@"add_serve.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pickUpPrefInput addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.pickUpPrefInput.layer.cornerRadius = 5;
    //[self.pickUpPrefInput setImage:image forState:UIControlStateNormal];
    self.pickUpPrefInput.tintColor = [UIColor grayColor];
    
    //for its action refer to LeveyPopListViewDemo project in downloads

    self.addressinput1.layer.borderWidth = 1.0f;
    self.addressinput1.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addressinput1.layer.cornerRadius = 5;
    self.addressinput1.clipsToBounds = YES;
    
    self.addressinput2.layer.borderWidth = 1.0f;
    self.addressinput2.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addressinput2.layer.cornerRadius = 5;
    self.addressinput2.clipsToBounds = YES;
    
    self.cityInput.layer.borderWidth = 1.0f;
    self.cityInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.cityInput.layer.cornerRadius = 5;
    self.cityInput.clipsToBounds = YES;
    
    self.stateInput.layer.borderWidth = 1.0f;
    self.stateInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.stateInput.layer.cornerRadius = 5;
    self.stateInput.clipsToBounds = YES;
    
    self.zipCodeInput.layer.borderWidth = 1.0f;
    self.zipCodeInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.zipCodeInput.layer.cornerRadius = 5;
    self.zipCodeInput.clipsToBounds = YES;
    
    self.phoneInput.layer.borderWidth = 1.0f;
    self.phoneInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.phoneInput.layer.cornerRadius = 5;
    self.phoneInput.clipsToBounds = YES;
    
    self.pickUpPrefInput.layer.borderWidth = 1.0f;
    self.pickUpPrefInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.pickUpPrefInput.layer.cornerRadius = 5;
    self.pickUpPrefInput.clipsToBounds = YES;
    //self.pickUpPrefInput.editable = NO;
    
    [self autoFillTextFields];
    
    [self.view addSubview:addressLabel];
    [self.view addSubview:self.addressinput1];
    [self.view addSubview:addressLabel2];
    [self.view addSubview:self.addressinput2];
    [self.view addSubview:cityLabel];
    [self.view addSubview:self.cityInput];
    [self.view addSubview:stateLabel];
    [self.view addSubview:self.stateInput];
    [self.view addSubview:zipCodeLabel];
    [self.view addSubview:self.zipCodeInput];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:self.phoneInput];
    [self.view addSubview:self.pickUpPrefInput];
    [self.view addSubview:pickUpPrefLabel];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)setUpActionSheets{
    
    self.deleteButtonActionSheet= [[UIActionSheet alloc]initWithTitle:[deleteButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[deleteButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[deleteButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void)showActionSheet:(id)sender {
    NSInteger senderTag = [sender tag];
    
    if(senderTag == deleteButtonTag)
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

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonPressed:(id)sender {
    
    if(self.reviewSubmitViewController == nil){
        ReviewSubmitViewController *secondView = [[ReviewSubmitViewController alloc] init];
        self.reviewSubmitViewController= secondView;
    }
    
    //tell the navigation controller to push a new view into the stack
    [self.navigationController pushViewController:self.reviewSubmitViewController animated:YES];
}





- (void)textViewDidBeginEditing:(UITextView *)textView {

    if(textView.tag==0){
    textView.textColor = [UIColor blackColor];
        [textView becomeFirstResponder];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedAnotherButton:(id)selector {
    // goes back to the last view controller in the stack
    [self.navigationController popViewControllerAnimated:YES];
}

@end
