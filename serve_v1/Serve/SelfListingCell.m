//
//  AddListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "SelfListingCell.h"

@implementation SelfListingCell

@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        //self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
        
        self.typeServesLabel = [[UILabel alloc] init];
        self.typeServesLabel.textColor = [UIColor grayColor];
        self.typeServesLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.availablityLabel = [[UILabel alloc] init];
        self.availablityLabel.textColor = [UIColor grayColor];
        self.availablityLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        
        self.syncStatus = [[UIButton alloc]init];
        self.syncStatus =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.syncStatus setFrame:CGRectMake(340, 75, 128.0/9, 99.0/9)];
        [self.syncStatus setImage:[UIImage imageNamed:@"cloud.png"] forState:UIControlStateNormal];
        [self.syncStatus addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.imageView.layer.borderWidth = .5;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView setClipsToBounds:YES];
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.typeServesLabel];
        [self addSubview:self.availablityLabel];
        [self addSubview:self.syncStatus];
    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
        self.titleLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,5,300, 30);
        self.typeServesLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,25,300, 30);
        self.availablityLabel.frame = CGRectMake(self.contentView.frame.size.width/3+15,65,300, 30);
    
//        self.imageView.frame= CGRectMake(10,17,self.contentView.frame.size.width/5,self.contentView.frame.size.height/1.5);

        self.typeServesLabel.text = [NSString stringWithFormat:@"%@, Serves %@ persons",self.typeString, self.serveCount];
        self.availablityLabel.text = @"Available 4:30 pm - 6:30 pm";
    
//        NSNumber *val = [NSNumber numberWithInteger:1];
//        if(self.syncStatusValue == val)
//        {
//            [self.syncStatus setFrame:CGRectMake(340, 75, 128.0/9, 99.0/9)];
//            [self addSubview:self.syncStatus];
//        }
    
    
    [self setUpConstraints];
    
}


-(void)setUpConstraints
{
    id views = @{@"titleLabel":self.titleLabel,
                 @"typeServesLabel":self.typeServesLabel,
                 @"availablityLabel":self.availablityLabel,
                 @"imageView":self.imageView,
                 };
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageOne]|" options:0 metrics: metrics views:views]];
//    
//    id metrics = @{@"topMargin": @16, @"bottommargin":@50,@"fieldheight":@60,@"descheight":@160,@"leftMargin":@16,@"rightMargin":@10,@"fieldSpacing":@40};
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: metrics views:views]];
//    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[initView]|" options:0 metrics: metrics views:views]];
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[imageOne]-[imageTwo]-[imageThree]-[imageFour]|" options:0 metrics:metrics views:views]];
//    
//
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageTwo]|" options:0 metrics: metrics views:views]];
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageThree]|" options:0 metrics: metrics views:views]];
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[imageFour]|" options:0 metrics: metrics views:views]];
    
    NSLayoutConstraint *imageViewHeightConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual toItem:self
                                                    attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0];
    NSLayoutConstraint *imageViewWidthConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual toItem:self
                                                   attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0];
    NSLayoutConstraint *imageViewLeftConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual toItem:self
                                                   attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    
    NSLayoutConstraint *imageViewTopConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.imageView attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual toItem:self
                                                         attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    
    [self addConstraints:@[imageViewHeightConstraint,imageViewWidthConstraint,imageViewLeftConstraint,imageViewTopConstraint]];

    
}

@end
