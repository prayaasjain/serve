//
//  ImageField.m
//  Serve
//
//  Created by Akhil Khemani on 7/29/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "ImageField.h"

@interface ImageField()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *horizontalSeparator;
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



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.scrollView  = [[UIScrollView alloc] init];
        self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
        self.scrollView.scrollEnabled = NO;
        
        self.imageOne = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageOne.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageOne setClipsToBounds:YES];
        self.imageOne.layer.cornerRadius = 5.0f;
        self.imageOne.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageOne.layer.borderWidth = 0.5f;
        self.imageOne.image = [UIImage imageNamed:@"addPhoto1.png"];
        [self.imageOne setUserInteractionEnabled:YES];
        self.imageOne.translatesAutoresizingMaskIntoConstraints = NO;

        
        self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.imageTwo.contentMode = UIViewContentModeScale;
        [self.imageTwo setClipsToBounds:YES];
        self.imageTwo.image = [UIImage imageNamed:@"plus_filled.png"];
        self.imageTwo.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageTwo.layer.borderWidth = 0.5f;
        self.imageTwo.layer.cornerRadius = 5;
        [self.imageTwo setUserInteractionEnabled:YES];
        self.imageTwo.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageThree = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageThree.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageThree setClipsToBounds:YES];
        self.imageThree.image = [UIImage imageNamed:@"plus.png"];
        self.imageThree.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageThree.layer.borderWidth = 0.5f;
        self.imageThree.layer.cornerRadius = 5;
        [self.imageThree setUserInteractionEnabled:YES];
        self.imageThree.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageFour= [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageFour.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageFour setClipsToBounds:YES];
        self.imageFour.layer.cornerRadius = 5.0f;
        self.imageFour.layer.borderColor = [UIColor blackColor].CGColor;
        self.imageFour.layer.borderWidth = 0.5f;
        self.imageFour.image = [UIImage imageNamed:@"addPhotoPressed1.png"];
        [self.imageFour setUserInteractionEnabled:YES];
        self.imageFour.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.imageTwo setHidden:YES];
        [self.imageFour setHidden:YES];
        [self.imageThree setHidden:YES];
        //switch off the scrolling till the third image is not switched on ? Maybe ?
        

        self.horizontalSeparator = [[UIView alloc]initWithFrame:CGRectZero];
        //self.horizontalSeparator.backgroundColor = [UIColor lightGrayColor];
        self.horizontalSeparator.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.horizontalSeparator.layer.borderWidth = 0.3f;
        self.horizontalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.scrollView addSubview:self.imageOne];
        [self.scrollView addSubview:self.imageTwo];
        [self.scrollView addSubview:self.imageThree];
        [self.scrollView addSubview:self.imageFour];
        
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        
        self.localImageArray = [[NSMutableArray alloc]init];
        
        [self setUpConstraints2];
        
    }
    return self;
    
}


-(void)setUpConstraints2
{
    id views = @{@"scrollView":self.scrollView,
                 @"imageOne":self.imageOne,
                 @"imageTwo":self.imageTwo,
                 @"imageThree":self.imageThree,
                 @"imageFour":self.imageFour,
                 };
    
    id metrics = @{@"topMargin": @16, @"bottommargin":@50,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@10,@"fieldSpacing":@40};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: metrics views:views]];
    
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
    
    [self.scrollView addConstraints:@[imageOneWidthConstraint,imageOneHeightConstraint,imageTwoWidthConstraint,imageThreeWidthConstraint,imageFourWidthConstraint]];
}

-(void)addPhotoWithPhotosArray:(NSArray*)photoArray
{
    //self.localImageArray = photoArray;
    
    switch(photoArray.count)
    {
        case 1: [self.imageTwo setHidden:NO];
                [self.imageOne setImage:[photoArray objectAtIndex:0]];
                break;
        case 2: [self.imageThree setHidden:NO];
                [self.imageTwo setImage:[photoArray objectAtIndex:1]];
                break;
        case 3: self.scrollView.scrollEnabled = YES;
                [self.imageFour setHidden:NO];
                [self.imageThree setImage:[photoArray objectAtIndex:2]];
                break;
        case 4:[self.imageFour setImage:[photoArray objectAtIndex:3]];
                break;
        default:
            break;
    }

}

@end
