//
//  ImageField.m
//  Serve
//
//  Created by Akhil Khemani on 7/29/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ImageField.h"
#import "UIColor+Utils.h"

@interface ImageField()

@property (strong, nonatomic) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *cameraButton;
@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray* localImageArray;


//@property (strong, nonatomic) UIImage *fullSelectedImage;

@end

@implementation ImageField

@synthesize imageOne = _imageOne;
@synthesize imageTwo = _imageTwo;
@synthesize imageThree = _imageThree;
@synthesize imageFour = _imageFour;



- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView  = [[UIScrollView alloc] init];
        self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        
        self.imageOne = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageOne.layer.cornerRadius = 5.0f;
        self.imageOne.layer.borderColor = [[UIColor servePrimaryColor] CGColor];
        self.imageOne.layer.borderWidth = 0.4f;
        self.imageOne.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.imageOne setUserInteractionEnabled:YES];
        self.imageOne.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.initialView = [[UIView alloc]initWithFrame:CGRectZero];
        self.initialView.backgroundColor = [UIColor whiteColor];
        self.initialView.translatesAutoresizingMaskIntoConstraints  = NO;
        self.cameraButton = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.cameraButton.image = [UIImage imageNamed:@"camera_big_b.png"];
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageTwo.contentMode = UIViewContentModeCenter;
        self.imageTwo.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageTwo.layer.borderWidth = 0.4f;
        self.imageTwo.layer.cornerRadius = 5;
        [self.imageTwo setUserInteractionEnabled:YES];
        self.imageTwo.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageThree = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageThree.contentMode = UIViewContentModeCenter;
        [self.imageThree setClipsToBounds:YES];
        self.imageThree.layer.borderColor = [[UIColor servePrimaryColor]CGColor ];
        self.imageThree.layer.borderWidth = 0.4f;
        self.imageThree.layer.cornerRadius = 5;
        [self.imageThree setUserInteractionEnabled:YES];
        self.imageThree.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageFour= [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageFour.contentMode = UIViewContentModeCenter;
        [self.imageFour setClipsToBounds:YES];
        self.imageFour.layer.cornerRadius = 5.0f;
        self.imageFour.layer.borderColor = [[UIColor servePrimaryColor]CGColor ];
        self.imageFour.layer.borderWidth = 0.4f;
        [self.imageFour setUserInteractionEnabled:YES];
        self.imageFour.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.titleLabel = [UILabel new];
        [self.titleLabel setText:@"ADD PHOTOS"];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
        self.titleLabel.textColor = [UIColor servetextLabelGrayColor];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.scrollView addSubview:self.imageOne];
        [self.scrollView addSubview:self.imageTwo];
        [self.scrollView addSubview:self.imageThree];
        [self.scrollView addSubview:self.imageFour];
        [self.scrollView addSubview:self.initialView];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        self.localImageArray = [[NSMutableArray alloc]init];
        
        [self.scrollView addSubview:self.initialView];
        [self.initialView addSubview:self.titleLabel];
        [self.initialView addSubview:self.cameraButton];
        
        self.imageOne.image = [UIImage imageNamed:@"addPhoto1.png"];
        self.imageTwo.image = [UIImage imageNamed:@"plus_b.png"];
        self.imageThree.image = [UIImage imageNamed:@"plus_b.png"];
        self.imageFour.image = [UIImage imageNamed:@"plus_b.png"];
        
        [self.initialView setHidden:NO];
        [self.imageOne setHidden:YES];
        [self.imageTwo setHidden:YES];
        [self.imageFour setHidden:YES];
        [self.imageThree setHidden:YES];
        
        [self resetImageFieldWithImageArray:images];
        [self setUpConstraints2];

    }
    return self;
    
}



-(void)resetImageFieldWithImageArray:(NSArray *)imageArray
{
    NSUInteger imageCount = [imageArray count];
    
    if(imageCount>0)
    {
        [self.imageOne setImage:[imageArray objectAtIndex:0]];
        [self.initialView setHidden:YES];
        [self.imageOne setHidden:NO];
        [self.imageTwo setHidden:NO];
        
        if(imageCount>1) {
            [self.imageTwo setImage:[imageArray objectAtIndex:1]];
            self.imageTwo.contentMode = UIViewContentModeScaleAspectFit;
            [self.imageThree setHidden:NO];
            
            if(imageCount>2) {
               self.scrollView.scrollEnabled = YES;
              [self.imageThree setImage:[imageArray objectAtIndex:2]];
                 self.imageThree.contentMode = UIViewContentModeScaleAspectFit;
                [self.imageFour setHidden:NO];
                
                if(imageCount>3) {
                    [self.imageFour setImage:[imageArray objectAtIndex:3]];
                    self.imageFour.contentMode = UIViewContentModeScaleAspectFit;

                }
            }
        }
    }
}

-(void)setUpConstraints2
{
    id views = @{@"scrollView":self.scrollView,
                 @"imageOne":self.imageOne,
                 @"imageTwo":self.imageTwo,
                 @"imageThree":self.imageThree,
                 @"imageFour":self.imageFour,
                 @"initView":self.initialView,
                 @"cameraButton":self.cameraButton
                 };
    
    id metrics = @{@"topMargin": @16, @"bottommargin":@50,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@10,@"fieldSpacing":@40};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[initView]|" options:0 metrics: metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[imageOne]-[imageTwo]-[imageThree]-[imageFour]|" options:0 metrics:metrics views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageOne]|" options:0 metrics: metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageTwo]|" options:0 metrics: metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageThree]|" options:0 metrics: metrics views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageFour]|" options:0 metrics: metrics views:views]];
    
    NSLayoutConstraint *imageOneHeightConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.imageOne attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual toItem:self.scrollView
                                                    attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0];
    
    NSLayoutConstraint *imageOneWidthConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.imageOne attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual toItem:self.imageOne
                                                   attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *imageTwoWidthConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.imageTwo attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual toItem:self.imageOne
                                                   attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *imageThreeWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.imageThree attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self.imageOne
                                                     attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *imageFourWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.imageFour attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.imageOne
                                                    attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    NSLayoutConstraint *initialViewHeightConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.initialView attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual toItem:self
                                                       attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *cameraButtonCenterXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self
                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *cameraButtonCenterYConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual toItem:self
                                                         attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    NSLayoutConstraint *titleLabelLeftMarginConstraint = [NSLayoutConstraint
                                                          constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeftMargin
                                                          relatedBy:NSLayoutRelationEqual toItem:self.initialView
                                                          attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:10];
    
    NSLayoutConstraint *titleLabelTopMarginConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTopMargin
                                                         relatedBy:NSLayoutRelationEqual toItem:self.initialView
                                                         attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:10];
    
    
    [self.scrollView addConstraints:@[imageOneWidthConstraint,imageOneHeightConstraint,imageTwoWidthConstraint,imageThreeWidthConstraint,imageFourWidthConstraint]];
    
    [self addConstraints:@[titleLabelTopMarginConstraint,titleLabelLeftMarginConstraint]];
    
    [self addConstraints:@[initialViewHeightConstraint,cameraButtonCenterXConstraint,cameraButtonCenterYConstraint]];
    
}
@end
