//
//  ImageField.m
//  Serve
//
//  Created by Akhil Khemani on 7/29/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "TypeField.h"

@interface TypeField()

@property (strong, nonatomic) UILabel *vegLabel;
@property (strong, nonatomic) UILabel *nonVegLabel;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *horizontalSeparator;
@property (nonatomic, assign) NSInteger selectedType;


//@property (strong, nonatomic) UIImage *fullSelectedImage;

@end

@implementation TypeField

@synthesize imageOne = _imageOne;
@synthesize imageTwo = _imageTwo;


- (id)init
{
    self = [super init];
    if (self) {
        
        self.selectedType = veg;
        
        self.imageOne = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.imageOne.contentMode = UIViewContentModeScaleAspectFill;
        //[self.imageOne setClipsToBounds:YES];
        self.imageOne.image = [UIImage imageNamed:@"veg_selected.png"];
        [self.imageOne setUserInteractionEnabled:YES];
        self.imageOne.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.imageTwo.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageTwo setClipsToBounds:YES];
        self.imageTwo.image = [UIImage imageNamed:@"nonVeg.png"];
        //self.imageTwo.layer.borderColor = [UIColor blackColor].CGColor;
        //self.imageTwo.layer.borderWidth = 0.5f;
        //self.imageTwo.layer.cornerRadius = 10;
        [self.imageTwo setUserInteractionEnabled:YES];
        self.imageTwo.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.horizontalSeparator = [[UIView alloc]initWithFrame:CGRectZero];
        //self.horizontalSeparator.backgroundColor = [UIColor lightGrayColor];
        self.horizontalSeparator.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.horizontalSeparator.layer.borderWidth = 0.3f;
        self.horizontalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.vegLabel = [[UILabel alloc]init];
        CGRect rect = CGRectMake(0, 0, 80, 80);
        self.vegLabel = [[UILabel alloc]initWithFrame:rect];
        self.vegLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0f];
        self.vegLabel.textAlignment = NSTextAlignmentCenter;
        self.vegLabel.clipsToBounds = YES;
        self.vegLabel.text = @"VEGETARIAN";
        self.vegLabel.textColor = [UIColor redColor];
        self.vegLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.nonVegLabel = [[UILabel alloc]init];
        self.nonVegLabel = [[UILabel alloc]initWithFrame:rect];
        self.nonVegLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0f];
        self.nonVegLabel.textAlignment = NSTextAlignmentCenter;
        self.nonVegLabel.clipsToBounds = YES;
        self.nonVegLabel.text = @"NON VEGETARIAN";
        self.nonVegLabel.textColor = [UIColor lightGrayColor];
        self.nonVegLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.imageOne];
        [self addSubview:self.vegLabel];
        [self addSubview:self.imageTwo];
        [self addSubview:self.nonVegLabel];
        [self addSubview:self.horizontalSeparator];
        
        [self setUpConstraints];
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectedType = veg;
        
        self.imageOne = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.imageOne.contentMode = UIViewContentModeScaleAspectFill;
        //[self.imageOne setClipsToBounds:YES];
        self.imageOne.image = [UIImage imageNamed:@"veg_selected.png"];
        [self.imageOne setUserInteractionEnabled:YES];
        self.imageOne.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.imageTwo.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageTwo setClipsToBounds:YES];
        self.imageTwo.image = [UIImage imageNamed:@"nonVeg.png"];
        //self.imageTwo.layer.borderColor = [UIColor blackColor].CGColor;
        //self.imageTwo.layer.borderWidth = 0.5f;
        //self.imageTwo.layer.cornerRadius = 10;
        [self.imageTwo setUserInteractionEnabled:YES];
        self.imageTwo.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.horizontalSeparator = [[UIView alloc]initWithFrame:CGRectZero];
        //self.horizontalSeparator.backgroundColor = [UIColor lightGrayColor];
        self.horizontalSeparator.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.horizontalSeparator.layer.borderWidth = 0.3f;
        self.horizontalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.vegLabel = [[UILabel alloc]init];
        CGRect rect = CGRectMake(0, 0, 80, 80);
        self.vegLabel = [[UILabel alloc]initWithFrame:rect];
        self.vegLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0f];
        self.vegLabel.textAlignment = NSTextAlignmentCenter;
        self.vegLabel.clipsToBounds = YES;
        self.vegLabel.text = @"VEGETARIAN";
        self.vegLabel.textColor = [UIColor redColor];
        self.vegLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.nonVegLabel = [[UILabel alloc]init];
        self.nonVegLabel = [[UILabel alloc]initWithFrame:rect];
        self.nonVegLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:8.0f];
        self.nonVegLabel.textAlignment = NSTextAlignmentCenter;
        self.nonVegLabel.clipsToBounds = YES;
        self.nonVegLabel.text = @"NON VEGETARIAN";
        self.nonVegLabel.textColor = [UIColor lightGrayColor];
        self.nonVegLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.imageOne];
        [self addSubview:self.vegLabel];
        [self addSubview:self.imageTwo];
        [self addSubview:self.nonVegLabel];
        [self addSubview:self.horizontalSeparator];
    
        [self setUpConstraints];
    
    }
    return self;
}

-(void)setUpConstraints{
    id views = @{@"vegButton":self.imageOne,
                 @"nonVegButton":self.imageTwo,
                 @"separator":self.horizontalSeparator
                 };
    
    id metrics = @{@"topMargin": @5, @"bottommargin":@50,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@50,@"fieldSpacing":@40};
    
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[vegButton]-fieldSpacing-[nonVegButton]|" options:0 metrics:metrics views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[vegButton]|" options:0 metrics: metrics views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[nonVegButton]|" options:0 metrics: metrics views:views]];
    
    NSLayoutConstraint *imageOneCenterXConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.imageOne attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual toItem:self
                                                   attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];
    NSLayoutConstraint *imageOneCenterYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.imageOne attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *imageTwoCenterXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.imageTwo attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0];
    NSLayoutConstraint *imageTwoCenterYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.imageTwo attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *separatorCenterXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.horizontalSeparator attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *separatorCenterYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.horizontalSeparator attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *separatorCenterHeightConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.horizontalSeparator attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual toItem:self
                                                      attribute:NSLayoutAttributeHeight multiplier:0.7 constant:0];
    NSLayoutConstraint *separatorCenterWidthConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.horizontalSeparator attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual toItem:self
                                                           attribute:NSLayoutAttributeWidth multiplier:0.003 constant:0];
    
    NSLayoutConstraint *vegLabelCenterXConstraint = [NSLayoutConstraint
                                                           constraintWithItem:self.vegLabel attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual toItem:self.imageOne
                                                           attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *vegLabelCenterYConstraint = [NSLayoutConstraint
                                                          constraintWithItem:self.vegLabel attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual toItem:self
                                                          attribute:NSLayoutAttributeCenterY multiplier:1.7 constant:0];
   
    NSLayoutConstraint *nonVegLabelCenterXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.nonVegLabel attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual toItem:self.imageTwo
                                                     attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *nonVegLabelCenterYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.nonVegLabel attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeCenterY multiplier:1.7 constant:0];
    
    
    
    
    [self addConstraints:@[imageOneCenterXConstraint,imageOneCenterYConstraint]];
    [self addConstraints:@[vegLabelCenterXConstraint,vegLabelCenterYConstraint]];
    
    [self addConstraints:@[imageTwoCenterXConstraint,imageTwoCenterYConstraint]];
    [self addConstraints:@[nonVegLabelCenterXConstraint,nonVegLabelCenterYConstraint]];
    
    [self addConstraints:@[separatorCenterXConstraint,separatorCenterYConstraint,separatorCenterHeightConstraint,separatorCenterWidthConstraint]];
    
    
    
}

-(void)updateSelectionWithTag:(NSInteger)tag
{
    if (self.selectedType == veg && tag!=veg)
    {
        self.imageTwo.image = [UIImage imageNamed:@"nonVeg_selected.png"];
        self.imageOne.image = [UIImage imageNamed:@"veg.png"];
        self.nonVegLabel.textColor = [UIColor redColor];
        self.vegLabel.textColor = [UIColor lightGrayColor];
        self.selectedType = nonveg;
    }
    
    if (self.selectedType == nonveg && tag!=nonveg)
    {
        self.imageTwo.image = [UIImage imageNamed:@"nonVeg.png"];
        self.imageOne.image = [UIImage imageNamed:@"veg_selected.png"];
        self.nonVegLabel.textColor = [UIColor lightGrayColor];
        self.vegLabel.textColor = [UIColor redColor];
        self.selectedType = veg;
    }

}

@end
