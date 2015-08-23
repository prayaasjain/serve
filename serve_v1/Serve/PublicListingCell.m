//
//  PublicListingCell.m
//  Serve
//
//  Created by Akhil Khemani on 5/17/15.
//  Copyright (c) 2015 Akhil Khemani. All rights reserved.
//

#import "PublicListingCell.h"
#import "UIColor+Utils.h"



@interface PublicListingCell ()

@end

@implementation PublicListingCell

@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withListing:(id<ServeListingProtocol>)Item
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpCellObjects];
        
        //set the values
        //self.serveCountLabel.text = [[Item serveCount] stringValue];
        //        self.addressLabel.text = [Item address1];
        //        self.titleLabel.text = [Item name];
        //        self.imageView.image = [UIImage imageWithData:[Item image]];
        
        
        self.distanceLabel.text = @"0.3 mi";
        self.availablityLabel.text = @"Available 4:30 pm - 6:30 pm";
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.typeLabel];
        [self addSubview:self.availablityLabel];
        [self addSubview:self.serveIcon];
        [self addSubview:self.serveCountLabel];
        [self addSubview:self.distanceLabel];
        [self addSubview:self.addressLabel];
        
    }
    return self;
    
}


- (void) layoutSubviews {
    [super layoutSubviews];
    [self setUpConstraints];
}


-(void)setUpCellObjects {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0;
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textColor = [UIColor servetextLabelGrayColor];
    self.addressLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    self.typeLabel.text = [NSString stringWithFormat:@"VEG"];
    //self.typeLabel.layer.borderWidth = 0.5;
    //self.typeLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.typeLabel.layer.cornerRadius = 5;
    self.typeLabel.backgroundColor = [UIColor blackColor];
    self.typeLabel.textAlignment =NSTextAlignmentCenter;
    self.typeLabel.alpha = 0.6;
    self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.typeLabel setClipsToBounds:YES];
    
    self.availablityLabel = [[UILabel alloc] init];
    self.availablityLabel.textColor = [UIColor servetextLabelGrayColor];
    self.availablityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    self.availablityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.serveIcon =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.serveIcon setImage:[UIImage imageNamed:@"person.png"] forState:UIControlStateNormal];
    //[self.serveIcon addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.serveIcon.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.serveCountLabel = [[UILabel alloc] init];
    self.serveCountLabel.textColor = [UIColor servePrimaryColor];
    self.serveCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
    self.serveCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.textColor = [UIColor grayColor];
    self.distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.imageView.layer.borderWidth = .5;
    
}

-(void)setUpConstraints {
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
    
    NSLayoutConstraint *titleLabelLeftConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                   attribute:NSLayoutAttributeRight multiplier:1 constant:10];
    
    NSLayoutConstraint *titleLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                  attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    
    NSLayoutConstraint *addressLabelLeftConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.addressLabel attribute:NSLayoutAttributeLeft
                                                    relatedBy:NSLayoutRelationEqual toItem:self.titleLabel
                                                    attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *addressLabelTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.addressLabel attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.titleLabel
                                                   attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    NSLayoutConstraint *addressLabelWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.addressLabel attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeWidth multiplier:.60 constant:0];
    
    NSLayoutConstraint *availablityLabelLeftConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.availablityLabel attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual toItem:self.titleLabel
                                                      attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *availablityLabelBottomConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.availablityLabel attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual toItem:self
                                                     attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    
    NSLayoutConstraint *distanceLabelRightConstraint = [NSLayoutConstraint
                                                          constraintWithItem:self.distanceLabel attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual toItem:self
                                                          attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    
    NSLayoutConstraint *distanceLabelTopConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.distanceLabel attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                         attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    

    NSLayoutConstraint *typeLabelWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.typeLabel attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                    attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *typeLabelLeftConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.typeLabel attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                        attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *typeLabelBottomConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.typeLabel attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual toItem:self.imageView
                                                      attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *serveCountLabelRightConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.serveCountLabel attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual toItem:self
                                                   attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    
    NSLayoutConstraint *serveCountLabelTopConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.serveCountLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:self.addressLabel
                                                     attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *serveIconTopConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.serveIcon attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual toItem:self.serveCountLabel
                                                        attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *serveIconRightConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.serveIcon attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual toItem:self.serveCountLabel
                                                  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *serveIconWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.serveIcon attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:nil
                                                    attribute:NSLayoutAttributeWidth multiplier:1 constant:15];
    NSLayoutConstraint *serveIconHeightConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.serveIcon attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual toItem:nil
                                                    attribute:NSLayoutAttributeHeight multiplier:1 constant:15];
    
    
    
    [self addConstraints:@[imageViewHeightConstraint,imageViewWidthConstraint,imageViewLeftConstraint,imageViewTopConstraint]];

    [self addConstraints:@[titleLabelLeftConstraint,titleLabelTopConstraint]];
    [self addConstraints:@[addressLabelLeftConstraint,addressLabelTopConstraint,addressLabelWidthConstraint]];
    [self addConstraints:@[availablityLabelLeftConstraint,availablityLabelBottomConstraint]];
    [self addConstraints:@[distanceLabelRightConstraint,distanceLabelTopConstraint]];
    [self addConstraints:@[typeLabelWidthConstraint,typeLabelLeftConstraint,typeLabelBottomConstraint]];
    [self addConstraints:@[serveCountLabelRightConstraint,serveCountLabelTopConstraint]];
    [self addConstraints:@[serveIconTopConstraint,serveIconRightConstraint,
                           serveIconWidthConstraint,serveIconHeightConstraint
                           ]];
}

@end
