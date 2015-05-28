//
//  NewPickUpInfoViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/25/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "NewPickUpInfoViewController.h"

typedef enum : NSInteger
{
    CancelButtonTag=0,
    ContinueButtonTag,
    DeleteButtonTag,
    Address1Tag,
    Address2Tag,
    
} InputViewTags;

static NSArray *deleteButtonActionSheetItems = nil;

@interface NewPickUpInfoViewController ()

@property (nonatomic, strong) UITextField *addressinput1;
@property (nonatomic, strong) UITextField *addressinput2;
@property (nonatomic, strong) UITextField *cityInput;
@property (nonatomic, strong) UITextField *stateInput;
@property (nonatomic, strong) UITextField *zipCodeInput;
@property (nonatomic, strong) UITextField *phoneInput;
@property (nonatomic, strong) UIButton *pickUpPrefInput;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *addressLabel2;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *zipCodeLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *pickUpPrefLabel;

@property (nonatomic, strong) UIView *progressIndicator;

@property (nonatomic, strong) UIActionSheet *deleteButtonActionSheet;

- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (void)showActionSheet:(id)sender;


@end

@implementation NewPickUpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpViewControllerObjects];
    [self setUpNavigationController];
    [self setUpActionSheets];
    [self setUpConstraints];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpViewControllerObjects
{
    self.progressIndicator = [[UIView alloc]init];
    self.progressIndicator.translatesAutoresizingMaskIntoConstraints=NO;
    self.progressIndicator.layer.borderColor = [UIColor blackColor].CGColor;
    self.progressIndicator.layer.borderWidth = 0.5f;
    [self.progressIndicator setBackgroundColor:[UIColor blackColor]];
    //self.progressIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.progressIndicator.opaque = NO;
    self.progressIndicator.alpha = 0.7;
    

    self.addressLabel  = [UILabel new];
    [self.addressLabel setText:@"ADDRESS\nLine1"];
    [self.addressLabel setFont:[UIFont systemFontOfSize:12]];
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.addressinput1 = [[UITextField alloc]init];
    self.addressinput1.layer.borderWidth = 1.0f;
    self.addressinput1.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addressinput1.layer.cornerRadius = 5;
    self.addressinput1.clipsToBounds = YES;
    self.addressinput1.tag = Address1Tag;
    self.addressinput1.delegate = self;
    self.addressinput1.textColor = [UIColor grayColor];
    self.addressinput1.font = [UIFont systemFontOfSize:10];
    self.addressinput1.textAlignment = NSTextAlignmentCenter;
    [self.addressinput1 setReturnKeyType:UIReturnKeyDone];
    //self.addressinput1.text = address;
    self.addressinput1.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.addressLabel2  = [UILabel new];
    [self.addressLabel2 setText:@"ADDRESS\nLine2"];
    [self.addressLabel2 setFont:[UIFont systemFontOfSize:12]];
    self.addressLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    self.addressLabel2.numberOfLines = 0;
    self.addressLabel2.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.addressinput2 = [[UITextField alloc]init];
    self.addressinput2.layer.borderWidth = 1.0f;
    self.addressinput2.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addressinput2.layer.cornerRadius = 5;
    self.addressinput2.clipsToBounds = YES;
    self.addressinput2.tag = Address1Tag;
    self.addressinput2.delegate = self;
    self.addressinput2.textColor = [UIColor grayColor];
    self.addressinput2.font = [UIFont systemFontOfSize:10];
    self.addressinput2.textAlignment = NSTextAlignmentCenter;
    [self.addressinput2 setReturnKeyType:UIReturnKeyDone];
    //self.addressinput1.text = address;
    self.addressinput2.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cityLabel  = [UILabel new];
    [self.cityLabel setText:@"City "];
    [self.cityLabel setFont:[UIFont systemFontOfSize:12]];
//    self.cityLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.cityLabel.numberOfLines = 0;
    self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cityInput= [[UITextField alloc]init];
    self.cityInput.layer.borderWidth = 1.0f;
    self.cityInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.cityInput.layer.cornerRadius = 5;
    self.cityInput.clipsToBounds = YES;
    self.cityInput.tag = Address1Tag;
    self.cityInput.delegate = self;
    self.cityInput.textColor = [UIColor grayColor];
    self.cityInput.font = [UIFont systemFontOfSize:10];
    self.cityInput.textAlignment = NSTextAlignmentCenter;
    [self.cityInput setReturnKeyType:UIReturnKeyDone];
    //self.addressinput1.text = address;
    self.cityInput.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.zipCodeLabel  = [UILabel new];
    [self.zipCodeLabel setText:@"ZipCode"];
    [self.zipCodeLabel setFont:[UIFont systemFontOfSize:12]];
    self.zipCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.zipCodeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.zipCodeInput= [[UITextField alloc]init];
    self.zipCodeInput.layer.borderWidth = 1.0f;
    self.zipCodeInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.zipCodeInput.layer.cornerRadius = 5;
    self.zipCodeInput.clipsToBounds = YES;
    self.zipCodeInput.tag = Address1Tag;
    self.zipCodeInput.delegate = self;
    self.zipCodeInput.textColor = [UIColor grayColor];
    self.zipCodeInput.font = [UIFont systemFontOfSize:10];
    self.zipCodeInput.textAlignment = NSTextAlignmentCenter;
    [self.zipCodeInput setReturnKeyType:UIReturnKeyDone];
    self.zipCodeInput.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.stateLabel  = [UILabel new];
    [self.stateLabel setText:@"State "];
    [self.stateLabel setFont:[UIFont systemFontOfSize:12]];
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.stateInput= [[UITextField alloc]init];
    self.stateInput.layer.borderWidth = 1.0f;
    self.stateInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.stateInput.layer.cornerRadius = 5;
    self.stateInput.clipsToBounds = YES;
    self.stateInput.tag = Address1Tag;
    self.stateInput.delegate = self;
    self.stateInput.textColor = [UIColor grayColor];
    self.stateInput.font = [UIFont systemFontOfSize:10];
    self.stateInput.textAlignment = NSTextAlignmentCenter;
    [self.stateInput setReturnKeyType:UIReturnKeyDone];
    self.stateInput.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.phoneLabel  = [UILabel new];
    [self.phoneLabel setText:@"Phone "];
    [self.phoneLabel setFont:[UIFont systemFontOfSize:12]];
    self.phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.phoneInput= [[UITextField alloc]init];
    self.phoneInput.layer.borderWidth = 1.0f;
    self.phoneInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.phoneInput.layer.cornerRadius = 5;
    self.phoneInput.clipsToBounds = YES;
    self.phoneInput.tag = Address1Tag;
    self.phoneInput.delegate = self;
    self.phoneInput.textColor = [UIColor grayColor];
    self.phoneInput.font = [UIFont systemFontOfSize:10];
    self.phoneInput.textAlignment = NSTextAlignmentCenter;
    [self.phoneInput setReturnKeyType:UIReturnKeyDone];
    self.phoneInput.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.progressIndicator];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressinput1];
    [self.view addSubview:self.addressLabel2];
    [self.view addSubview:self.addressinput2];
    [self.view addSubview:self.cityLabel];
    [self.view addSubview:self.cityInput];
    [self.view addSubview:self.zipCodeLabel];
    [self.view addSubview:self.zipCodeInput];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.stateInput];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneInput];

}

-(void)setUpConstraints {
    
    UIView *superview = self.view;

    NSLayoutConstraint *progressViewHeightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual toItem:superview
                                                        attribute:NSLayoutAttributeHeight multiplier:.10 constant:0];
    
    
    NSLayoutConstraint *address1LabelTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.addressLabel attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.addressinput1
                                                   attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *address2LabelTopConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.addressLabel2 attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual toItem:self.addressinput2
                                                      attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *address1InputWidthConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.addressinput1 attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual toItem:self.addressinput2
                                                        attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *cityLabelTopConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.cityLabel attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual toItem:self.cityInput
                                                      attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *zipLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.zipCodeLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.zipCodeInput
                                                  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

    NSLayoutConstraint *stateLabelTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.stateLabel attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.stateInput
                                                   attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *phoneLabelTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.phoneLabel attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.phoneInput
                                                   attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *cityLabelLeftConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.cityLabel attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual toItem:self.addressinput1
                                                  attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    
    
    
    NSLayoutConstraint *zipInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.zipCodeInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.addressinput1
                                                    attribute:NSLayoutAttributeWidth multiplier:.35 constant:0];
    
    NSLayoutConstraint *cityInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.cityInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.zipCodeInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *stateInputWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.stateInput attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.zipCodeInput
                                                    attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *phoneInputWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.phoneInput attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.zipCodeInput
                                                     attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    

    id views = @{@"progressView":self.progressIndicator,
                 @"address1label":self.addressLabel,
                 @"address1input":self.addressinput1,
                 @"address2label":self.addressLabel2,
                 @"address2input":self.addressinput2,
                 @"cityLabel":self.cityLabel,
                 @"cityInput":self.cityInput,
                 @"zipLabel":self.zipCodeLabel,
                 @"zipInput":self.zipCodeInput,
                 @"stateLabel":self.stateLabel,
                 @"stateInput":self.stateInput,
                 @"phoneLabel":self.phoneLabel,
                 @"phoneInput":self.phoneInput,
                 
                 }
    ;
    
    
    id metrics = @{@"topmargin": @70, @"bottommargin":@400,@"fieldheight":@25,@"descheight":@160,@"leftMargin":@10,@"rightMargin":@10,@"progressViewHeight":@80};
    
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topmargin-[progressView]-[address1input(==fieldheight)]-[address2input(==fieldheight)]-[cityInput(==fieldheight)]-[stateInput(==fieldheight)]-bottommargin-|" options:0 metrics:metrics views:views]];
    
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topmargin-[progressView]-[address1input(==fieldheight)]-[address2input(==fieldheight)]-[zipInput(==fieldheight)]-[phoneInput(==fieldheight)]-bottommargin-|" options:0 metrics:metrics views:views]];

    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]|" options:0 metrics:metrics views:views]];
    
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[address1label]-[address1input]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[address2label]-[address2input]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-leftMargin-[cityLabel]-[cityInput]-[zipLabel]-[zipInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-leftMargin-[stateLabel]-[stateInput]-[phoneLabel]-[phoneInput]-rightMargin-|" options:0 metrics:metrics views:views]];
    
    

    [superview addConstraints:@[address1LabelTopConstraint,address2LabelTopConstraint,address1InputWidthConstraint]];
    [superview addConstraints:@[cityLabelTopConstraint,zipLabelTopConstraint,cityInputWidthConstraint]];
    [superview addConstraints:@[stateLabelTopConstraint,phoneLabelTopConstraint,stateInputWidthConstraint,phoneInputWidthConstraint,zipInputWidthConstraint]];

}


- (void)setUpNavigationController {
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"PickUp Information"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    button.tag = DeleteButtonTag;
    
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

- (void)setUpActionSheets{
    
    self.deleteButtonActionSheet= [[UIActionSheet alloc]initWithTitle:[deleteButtonActionSheetItems objectAtIndex:0] delegate:self cancelButtonTitle:[deleteButtonActionSheetItems objectAtIndex:2] destructiveButtonTitle:[deleteButtonActionSheetItems objectAtIndex:1] otherButtonTitles:nil, nil];
    
}

- (void)showActionSheet:(id)sender {
    NSInteger senderTag = [sender tag];
    
    if(senderTag == DeleteButtonTag)
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


//- (void)autoFillTextFields {
//    
//    [self.addressinput1 setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    [self.addressinput2 setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    [self.cityInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    [self.stateInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    [self.zipCodeInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    [self.phoneInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    //[self.pickUpPrefInput setTextContainerInset:UIEdgeInsetsMake(7, 15, 0, 0)];
//    
//    
//    self.addressinput1.textColor = [UIColor grayColor];
//    self.addressinput2.textColor = [UIColor grayColor];
//    self.cityInput.textColor = [UIColor grayColor];
//    self.stateInput.textColor = [UIColor grayColor];
//    self.zipCodeInput.textColor = [UIColor grayColor];
//    self.phoneInput.textColor = [UIColor grayColor];
//    //self.pickUpPrefInput.textColor = [UIColor grayColor];
//    
//    self.addressinput1.tag = 0;
//    
//    self.addressinput1.text = @"19, Chachan Mansion";
//    self.addressinput2.text = @"Ladenla Road";
//    self.cityInput.text = @"Darjeeling";
//    self.stateInput.text = @"West Bengal";
//    self.zipCodeInput.text =@"734101";
//    self.phoneInput.text = @"+919434048340";
//    //self.pickUpPrefInput.text = @"All Day";
//    
//}

@end
