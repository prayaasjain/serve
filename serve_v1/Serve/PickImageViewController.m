//
//  ImageViewController.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PickImageViewController.h"


@interface PickImageViewController ()

@property (nonatomic, strong) UIImageView *pickImageView;
@property (nonatomic, strong) UIButton *addImageButton;

- (IBAction)chooseButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation PickImageViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Pick Image"];
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.pickImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height-64-45)];
    
    //self.pickImageView.image = [UIImage imageNamed:@"food1-gray.jpg"];
    self.pickImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.pickImageView.layer.borderWidth = 0.5f;
    //self.pickImageView.layer.cornerRadius = 10;
    self.pickImageView.tag = 1;
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    UIBarButtonItem *chooseButton = [[UIBarButtonItem alloc]initWithTitle:@"Continue"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(chooseButtonPressed:)];
    //@selector(:)
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(cancelButtonPressed:)];
    //[continueButton setTitle:@"Continue"];
    [chooseButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    [cancelButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica-Bold" size:12.0],
      NSFontAttributeName, nil]forState:UIControlStateNormal];
    
    //create an array of buttons
    NSArray *items = [NSArray arrayWithObjects:cancelButton, itemSpace, chooseButton, nil];
    //add the buttons to the toolbar
    self.toolbarItems = items;
    
    [self.view addSubview:self.pickImageView];
    [self.view addSubview:self.addImageButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    if(self.imageRecievedFromPhotoStream)
    {
        self.pickImageView.image = self.imageRecievedFromPhotoStream;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIButton *)addImageButton {
//    
//    if (!_addImageButton) {
//        _addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_addImageButton setFrame:CGRectMake(40,640,20,20)];
//        UIImage *image = [[UIImage imageNamed:@"add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [_addImageButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
//        _addImageButton.layer.cornerRadius = 10;
//        [_addImageButton setImage:image forState:UIControlStateNormal];
//        _addImageButton.tintColor = [UIColor grayColor];
//    
//    }
//    return _addImageButton;
//}

#pragma mark -
#pragma mark IBActions

//- (IBAction) didTapButton:(id)sender
//{
//    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
//                                                 init];
//    pickerController.delegate = self;
//    [self presentModalViewController:pickerController animated:YES];
//}

- (IBAction)chooseButtonPressed:(id)sender {
    
    UIImage *imageToPassBack = self.pickImageView.image;
    [self.delegate addItemViewController:self didFinishEnteringItem:imageToPassBack];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

//- (void) imagePickerController:(UIImagePickerController *)picker
//         didFinishPickingImage:(UIImage *)image
//                   editingInfo:(NSDictionary *)editingInfo
//{
//    self.pickImageView.image = image;
//    [self dismissModalViewControllerAnimated:YES];
//}

@end

//